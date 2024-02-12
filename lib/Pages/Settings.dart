import 'package:bubblediary/Pages/ResetPassword.dart';
import 'package:bubblediary/Services/notes_provider.dart';
import 'package:bubblediary/Utils/toast.dart';
import 'package:bubblediary/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Themenotifier.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _isBiometricAuthOn;
  bool isDarkMode = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    _loadDarkModePreference();
    super.initState();
    _isBiometricAuthOn = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('isBiometricAuthOn') ?? false;
    });
  }

  _loadDarkModePreference() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isDarkMode') != null) {
      setState(() {
        isDarkMode = prefs.getBool('isDarkMode')!;
      });
      // Get the ThemeNotifier from the context
      ThemeNotifier themeNotifier =
          Provider.of<ThemeNotifier>(context, listen: false);
      // Set the theme
      themeNotifier.setTheme(isDarkMode ? ThemeData.dark() : ThemeData.light());
    }
  }

  _updatePrefs(bool isDarkMode) async {
    prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _toggleBiometricAuth(bool value) async {
    final SharedPreferences prefs = await _prefs;

    if (value) {
      LocalAuthentication auth = LocalAuthentication();
      await auth.authenticate(
        localizedReason: 'Enable Biometric Authentication',
      );
    }
    if (!value) {
      LocalAuthentication auth = LocalAuthentication();
      await auth.authenticate(
          localizedReason: 'Disable Biometric Authentication');
    }
    setState(() {
      _isBiometricAuthOn =
          prefs.setBool('isBiometricAuthOn', value).then((bool success) {
        return value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String Username = FirebaseAuth.instance.currentUser!.displayName.toString();
    return WillPopScope(
        onWillPop: () async {
          // Handle the back button press here
          // You can exit the app using SystemNavigator.pop()
          SystemNavigator.pop();
          return false; // Returning false prevents default back navigation
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            children: <Widget>[
              Positioned(
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Hi, $Username!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Biometric Authentication'),
                leading: const Icon(Icons.fingerprint),
                trailing: FutureBuilder<bool>(
                  future: _isBiometricAuthOn,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return Switch(
                      value: snapshot.data ?? false,
                      onChanged: _toggleBiometricAuth,
                    );
                  },
                ),
              ),
              // ListTile(
              //   title: const Text('Dark Theme'),
              //   trailing: Switch(
              //     value: isDarkMode,
              //     onChanged: (newValue) {
              //       setState(() {
              //         isDarkMode = newValue;
              //       });

              //       ThemeNotifier themeNotifier =
              //           Provider.of<ThemeNotifier>(context, listen: false);
              //       // Set the theme
              //       themeNotifier.setTheme(
              //           isDarkMode ? ThemeData.dark() : ThemeData.light());
              //       _updatePrefs(isDarkMode);
              //     },
              //   ),
              // ),
              ListTile(
                title: const Text('Change Password'),
                leading: const Icon(Icons.lock_outline),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/logout');
                  //if google sign in is enabled
                  try {
                    if (GoogleSignIn().currentUser != null) {
                      GoogleSignIn().signOut();
                    }
                    //if firebase sign in is enabled
                    FirebaseAuth.instance.signOut();
                  } catch (e) {
                    showToast(message: e.toString());
                  }

                  _prefs.then((SharedPreferences prefs) {
                    prefs.clear();
                  });
                },
              ),
              ListTile(
                title: Text('Clear All Notes'),
                leading: Icon(Icons.dangerous),
                onTap: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                            'Are you sure you want to delete all notes?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm != null && confirm) {
                    // Call the deleteAllNotes() method from NotesProvider
                    Provider.of<NotesProvider>(context, listen: false)
                        .deleteAllNotes();
                  }
                },
              ),
            ],
          ),
        ));
  }
}
