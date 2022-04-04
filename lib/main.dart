import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comuse/Constants/AppConstants.dart';
import 'package:comuse/Provider/Auth_provider.dart';
import 'package:comuse/Provider/Member_provider.dart';
import 'package:comuse/Provider/Setting_provider.dart';
import 'package:comuse/Provider/Team_provider.dart';
import 'package:comuse/Screen/SplashScreen.dart';
import 'package:comuse/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(ComuseApp(prefs: prefs));
}

class ComuseApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
   

  ComuseApp({required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(),
            prefs: prefs,
            firebaseFirestore: firebaseFirestore,
          ),
        ),
        Provider<SettingProvider>(
          create: (_) => SettingProvider(
            firebaseFirestore: firebaseFirestore,
            prefs: prefs,
          ),
        ),
        Provider<MemberProvider>(
          create: (_) => MemberProvider(
            firebaseFirestore: firebaseFirestore,
            prefs: prefs
            )
          ),
        Provider<TeamProvider>(
          create: (_) => TeamProvider(
            firebaseFirestore: firebaseFirestore,
            prefs: prefs
            )
          ),
      ],
      child: const MaterialApp(
        home: SplashScreen(),
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

