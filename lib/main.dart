import 'package:bubblediary/Home.dart';
import 'package:bubblediary/Pages/AddNotePage.dart';
import 'package:bubblediary/Pages/Settings.dart';
import 'package:bubblediary/Pages/bubble_lens_notes.dart';
import 'package:bubblediary/Pages/login_page.dart';
import 'package:bubblediary/Pages/signup_page.dart';
import 'package:bubblediary/Services/database_service.dart';
import 'package:bubblediary/Services/notes_provider.dart';
import 'package:bubblediary/Utils/Themenotifier.dart';
import 'package:bubblediary/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  bool isBiometricAuthOn = prefs.getBool('isBiometricAuthOn') ?? false;
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (isLoggedIn && isBiometricAuthOn) {
    LocalAuthentication auth = LocalAuthentication();
    bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Authenticate to  Bubble Note App',
    );
    isLoggedIn = didAuthenticate;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ThemeNotifier(isDarkMode ? ThemeData.dark() : ThemeData.light()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NotesProvider(DatabaseService(FirebaseFirestore.instance)),
        ),
      ],
      child: BubbleNoteApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class BubbleNoteApp extends StatelessWidget {
  final bool isLoggedIn;

  BubbleNoteApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return MaterialApp(
        title: 'Bubble Note',
        debugShowCheckedModeBanner: false,
        theme: theme.getTheme(),
        routes: {
          '/': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
          '/bubbleLensNotes': (context) => BubbleLensNotes(),
          '/addNote': (context) => AddNotePage(),
          '/settings': (context) => SettingsScreen(),
          '/logout': (context) => const LoginPage(),
          '/home': (context) => MainPage(),
        },
        initialRoute: isLoggedIn ? '/home' : '/',
      );
    });
  }
}
