import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test_app/cubit/auth/auth_cubit.dart';

class SignInPage extends StatefulWidget {

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
  TextEditingController();

  String? _email;
  String? _password;
  String? _passwordConfirmation;
  bool showLogin = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _cubit = AuthCubit();
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _cubit?.close();
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: replace with BaseActivityWidget
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<AuthCubit>(
          create: (context) => AuthCubit()..initial(),
          child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
            if (state is AuthRegistrationError || state is AuthSignInError) {
              final message = state.getProps.last;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  message.toString(),
                ),
              ));
            }
            if (state is AuthSignIn) {
              Navigator.pushNamed(context, '\home_page');
            }
          }, builder: (context, state) {
            return Column(
              children: [
                if (state is AuthRegistration)
                  _registration("REGISTRATION", context),
                if (state is AuthInitial) _signInPage('SIGN IN', context),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _registration(String textButton, BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Image.asset(
            'assets/img_login.png',
            height: MediaQuery.of(context).size.height * 0.40,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, left: 20),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          _form(textButton, context),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already registered?',
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _emailController.clear();
                      _passwordController.clear();
                      _passwordConfirmationController.clear();
                      context.read<AuthCubit>().emit(const AuthInitial());
                      showLogin = false;
                    });
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signInPage(String textButton, BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Image.asset(
            'assets/img_login.png',
            height: MediaQuery.of(context).size.height * 0.40,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, left: 20),
            child: Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          _form(textButton, context),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not registered yet?',
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      context.read<AuthCubit>().emit(const AuthRegistration());
                      _emailController.clear();
                      _passwordController.clear();
                      showLogin = true;
                    });
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _button(String text, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'SIGN IN') {
          _signInButtonAction(context);
        } else
          _registrationButtonAction(context);
      },
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _form(String label, BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: _input(
              icon: Icon(Icons.email_outlined),
              controller: _emailController,
              hint: 'EMAIL',
              obscure: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: _input(
              icon: Icon(Icons.lock),
              controller: _passwordController,
              hint: 'PASSWORD',
              obscure: true,
            ),
          ),
          if (showLogin)
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: _input(
                icon: Icon(Icons.lock),
                controller: _passwordConfirmationController,
                hint: 'PASSWORD CONFIRMATION',
                obscure: true,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.055,
              width: MediaQuery.of(context).size.width,
              child: _button(label, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
      {Icon? icon,
        String? hint,
        TextEditingController? controller,
        bool? obscure}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure!,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).primaryColor,
          ),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon!,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _registrationButtonAction(BuildContext context) {
    _email = _emailController.text;
    _password = _passwordController.text;
    _passwordConfirmation = _passwordConfirmationController.text;

    context.read<AuthCubit>().registration(
        email: _email!,
        password: _password!,
        passwordConfirmation: _passwordConfirmation!);

    if (_passwordController.text != _passwordConfirmationController.text) {
      _passwordConfirmationController.clear();
    }
  }

  void _signInButtonAction(BuildContext context) {
    _password = _passwordController.text;
    _email = _emailController.text;
    context.read<AuthCubit>().signIn(email: _email!, password: _password!);
    _emailController.clear();
    _passwordController.clear();
  }

}
