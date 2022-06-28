import 'package:comuse/Provider/Auth_provider.dart';
import 'MemberScreen.dart/MemberScreen_Release.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../Widgets/LoadingWidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: TextButton(
            onPressed: () async {
              bool isSuccess = await authProvider.handleSignIn();
              if (isSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberScreen(),
                  ),
                );
              }
            },
            child: const Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color(0xffdd4b39).withOpacity(0.8);
                  }
                  return const Color(0xffdd4b39);
                },
              ),
              splashFactory: NoSplash.splashFactory,
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.fromLTRB(30, 15, 30, 15),
              ),
            ),
          ),
        ),
        // Loading
        Positioned(
          child: authProvider.status == Status.authenticating
              ? LoadingView()
              : SizedBox.shrink(),
        ),
      ],
    ));
  }
}
