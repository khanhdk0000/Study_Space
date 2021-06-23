import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study_space/Authentication/components/textfield_container.dart';
import 'package:study_space/Authentication/components/round_button.dart';
import 'package:study_space/Authentication/screen/log_in_screen.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/global.dart';
import 'package:study_space/Controller/userController.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Body()));
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              'SIGN UP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SvgPicture.asset(
              'assets/img/login.svg',
              height: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RegisterForm(),
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account ? ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kContentColorLightTheme),
                ),
                GestureDetector(
                  onTap: () {
                    print('sign up');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogInScreen()),
                    );
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    print(_emailController.text);
    print(_passwordController.text);
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ))
          .user;

      if (user != null) {
        await user.updateProfile(displayName: _usernameController.text.trim());
        print('sign up success');

        var c = new userController();
        await c.addUser(user.displayName);
        user_id = await c.getUserId(user.displayName, context);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text(
        //         'Successfully signed up ' + _userEmail + ' ' + _username)));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        print('no');
      }
    } on FirebaseAuthException catch (e) {
      print('exception: ' + e.code);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFieldContainer(
            child: TextFormField(
              controller: _usernameController,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.email_rounded,
                  color: kPrimaryColor,
                ),
                hintText: 'Your username',
                border: InputBorder.none,
              ),
            ),
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: _emailController,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.email_rounded,
                  color: kPrimaryColor,
                ),
                hintText: 'Your email',
                border: InputBorder.none,
              ),
            ),
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
                hintText: 'Your password',
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.visibility,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          RoundedButton(
            press: () async {
              if (_formKey.currentState.validate()) {
                _register();
              }
            },
            text: 'SIGN UP',
            size: size,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}

class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        autofocus: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
