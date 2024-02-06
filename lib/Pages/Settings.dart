import 'package:bubblediary/Pages/ResetPassword.dart';
import 'package:bubblediary/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    _loadDarkModePreference();
    super.initState();
    _isBiometricAuthOn = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('isBiometricAuthOn') ?? false;
    });
  }

  _loadDarkModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  _updateDarkModePreference(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', newValue);
    setState(() {
      isDarkMode = newValue;
    });
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
              ListTile(
                title: const Text('Biometric Authentication'),
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
              ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (newValue) {
                    // Get the ThemeNotifier from the context
                    ThemeNotifier themeNotifier =
                        Provider.of<ThemeNotifier>(context, listen: false);

                    _updateDarkModePreference(newValue);
                    // Set the theme
                    themeNotifier.setTheme(
                        newValue ? ThemeData.dark() : ThemeData.light());
                  },
                ),
              ),
              ListTile(
                title: const Text('Change Password'),
                trailing: const Icon(Icons.keyboard_arrow_right),
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
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/logout');

                  _prefs.then((SharedPreferences prefs) {
                    prefs.clear();
                  });
                },
              ),
            ],
          ),
        ));
  }
}
