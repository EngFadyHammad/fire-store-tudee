import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'database/firestore_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

Future<void> initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
}

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  String? userName = await FirestoreService().getUserName();

  runApp(MyApp(userName: userName));
}

class MyApp extends StatelessWidget {
  final String? userName;

  const MyApp({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tudee',
      theme: ThemeData(useMaterial3: false),
      home: userName == null
          ? const OnboardingScreen()
          : HomeScreen(userName: userName!),
    );
  }
}
