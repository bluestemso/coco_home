import 'package:flutter/material.dart';
import '../models/household.dart';
import '../services/household_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HouseholdScreen extends StatefulWidget {
  const HouseholdScreen({super.key});

  @override
  State<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends State<HouseholdScreen> {
  final HouseholdService _householdService = HouseholdService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createHousehold() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _householdService.createHousehold(
        name: _nameController.text,
        description: _descriptionController.text,
        createdBy: user.uid,
      );

      _nameController.clear();
      _descriptionController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Household created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating household: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('Not authenticated'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Households'),
      ),
      body: StreamBuilder<List<Household>>(
        stream: _householdService.getUserHouseholds(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final households = snapshot.data ?? [];

          return ListView.builder(
            itemCount: households.length,
            itemBuilder: (context, index) {
              final household = households[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(household.name),
                  subtitle: Text(household.description),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      // Handle menu actions
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateHouseholdDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateHouseholdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Household'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              _createHousehold();
              Navigator.pop(context);
            },
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create'),
          ),
        ],
      ),
    );
  }
} 