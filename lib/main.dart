import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/expenses_screen.dart';
import 'screens/whiteboard_screen.dart';
import 'screens/household_screen.dart';
import 'screens/family_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CocoHomeApp());
}

class CocoHomeApp extends StatelessWidget {
  const CocoHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coco Home',
      // Using Flex Color Scheme as mentioned in README
      theme: FlexThemeData.light(
        scheme: FlexScheme.greenM3,
        useMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.greenM3,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      routes: {
        '/expenses': (context) => const ExpensesScreen(),
        '/whiteboard': (context) => const WhiteboardScreen(),
        '/households': (context) => const HouseholdScreen(),
        '/families': (context) => const FamilyScreen(),
      },
    );
  }
}
