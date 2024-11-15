import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/controllers/providers/auth_provider.dart';
import 'package:tasks_app/utils/utils.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  bool isHidden = true;
  bool isHiddenConfirm = true;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String confirmPassword = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.deepPurple,
            )),
        automaticallyImplyLeading: true,
        title: const Text(
          "S'inscrire",
          style: TextStyle(
              color: Colors.deepPurple,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                10.ph,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "L'email est requis";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                              .hasMatch(value)) {
                            return "Email invalide";
                          } else {
                            email = value;
                          }
                          return null;
                        },
                        maxLength: 40,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: "Entrez votre email",
                          hintStyle: const TextStyle(color: Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Icon(
                              Icons.email,
                              size: 18.0,
                              color: Colors.deepPurple,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            gapPadding: 10,
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              gapPadding: 10,
                              borderSide: const BorderSide(
                                  color: Colors.deepPurple, width: 2.0)),
                        ),
                      ),
                      20.ph,
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Le mot de passe est requis";
                          } else {
                            password = value;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: isHidden,
                        maxLength: 25,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: "Entrez votre mot de passe",
                          hintStyle: const TextStyle(color: Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: IconButton(
                              icon: Icon(
                                !isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.deepPurple,
                                size: 23.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  isHidden = !isHidden;
                                });
                              },
                            ),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Icon(
                              Icons.lock,
                              size: 18.0,
                              color: Colors.deepPurple,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            gapPadding: 10,
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              gapPadding: 10,
                              borderSide: const BorderSide(
                                  color: Colors.deepPurple, width: 2.0)),
                        ),
                      ),
                      20.ph,
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "La confirmation du mot de passe est requise";
                          } else if (value != password) {
                            return "Les mots de passe ne correspondent pas";
                          } else {
                            confirmPassword = value;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: isHiddenConfirm,
                        maxLength: 25,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: "Confirmez votre mot de passe",
                          hintStyle: const TextStyle(color: Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: IconButton(
                              icon: Icon(
                                !isHiddenConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.deepPurple,
                                size: 23.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  isHiddenConfirm = !isHiddenConfirm;
                                });
                              },
                            ),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Icon(
                              Icons.lock,
                              size: 18.0,
                              color: Colors.deepPurple,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            gapPadding: 10,
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              gapPadding: 10,
                              borderSide: const BorderSide(
                                  color: Colors.deepPurple, width: 2.0)),
                        ),
                      ),
                    ],
                  ),
                ),
                50.ph,
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ref
                              .read(authProvider.notifier)
                              .signUp(email, password, confirmPassword);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
