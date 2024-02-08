import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bubblediary/Services/auth_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  static final auth = FirebaseAuth.instance;
  static late AuthStatus _status;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please enter your email address to recover your password.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Email address',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).dividerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: TextFormField(
                    obscureText: false,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Empty email';
                      }
                      return null;
                    },
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30.0,
                          ),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        // ignore: prefer_const_constructors
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30.0,
                          ),
                        ),
                      ),
                      fillColor: Theme.of(context).canvasColor,

                      isDense: true,
                      // fillColor: kPrimaryColor,
                      filled: true,
                      errorStyle: const TextStyle(fontSize: 15),
                      hintText: 'Email address',
                      hintStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).dividerColor),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Expanded(child: SizedBox()),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColorLight,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          final _status = await resetPassword(
                              email: _emailController.text.trim());
                          if (_status == AuthStatus.successful) {
                            //show popup dialoug saying check mail
                            // ignore: use_build_context_synchronously
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.scale,
                              title: 'Success',
                              desc: 'Check your email to reset your password',
                              btnOkOnPress: () {
                                Navigator.pop(context);
                              },
                            ).show();
                          } else {}
                        }
                      },
                      minWidth: double.infinity,
                      child: Text(
                        'RECOVER PASSWORD',
                        style: TextStyle(
                            color: Theme.of(context).shadowColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
