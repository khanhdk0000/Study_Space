import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study_space/Authentication/components/textfield_container.dart';
import 'package:study_space/Authentication/components/round_button.dart';
import 'package:study_space/Authentication/screen/sign_up_screen.dart';
import 'package:study_space/Home/view/home_screen.dart';
import 'package:study_space/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_space/Model/user.dart' as us;
import 'package:study_space/Controller/userController.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LogInScreen extends StatelessWidget {
  const LogInScreen({Key key}) : super(key: key);

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
              'LOGIN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SvgPicture.asset(
              'assets/img/login.svg',
              height: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            LogInForm(),
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account ? ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kContentColorLightTheme),
                ),
                GestureDetector(
                  onTap: () {
                    print('sign up');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
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

class LogInForm extends StatefulWidget {
  const LogInForm({Key key}) : super(key: key);

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;

  void _logIn() async {
    print(_emailController.text);
    print(_passwordController.text);
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ))
          .user;
      if (user != null) {
        print('success');
        var c = new userController();
        c.addUser(user.displayName);
        setState(() {
          _success = true;
          _userEmail = user.email;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully signed in ' + user.displayName),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: user
              ),
            ),
          );
        });
      } else {
        setState(() {
          print('no');
          _success = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid email or password')));
        });
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
                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                _logIn();
              }
            },
            text: 'LOGIN',
            size: size,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}

class LogInTextField extends StatelessWidget {
  const LogInTextField({
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
