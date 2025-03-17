import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coco Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Text(
                'Welcome Home',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your home together with ease',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 180),
                ),
              ),
              const SizedBox(height: 32),
              
              // Main navigation options
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Expenses Card
                    _buildNavigationCard(
                      context: context,
                      icon: Icons.receipt_long,
                      title: 'Expenses',
                      description: 'Track and split shared expenses',
                      onTap: () {
                        Navigator.of(context).pushNamed('/expenses');
                      },
                    ),
                    
                    // Households Card
                    _buildNavigationCard(
                      context: context,
                      icon: Icons.home,
                      title: 'Households',
                      description: 'Manage shared living spaces',
                      onTap: () {
                        Navigator.of(context).pushNamed('/households');
                      },
                    ),
                    
                    // Families Card
                    _buildNavigationCard(
                      context: context,
                      icon: Icons.family_restroom,
                      title: 'Families',
                      description: 'Organize family groups',
                      onTap: () {
                        Navigator.of(context).pushNamed('/families');
                      },
                    ),
                    
                    // Whiteboard Card
                    _buildNavigationCard(
                      context: context,
                      icon: Icons.note_alt,
                      title: 'Whiteboard',
                      description: 'Share notes with your household',
                      onTap: () {
                        Navigator.of(context).pushNamed('/whiteboard');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 180),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 