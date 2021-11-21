import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_test_app/cubit/forecast_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
 late FirebaseAuth auth;

  List<User> userList = [];

  AuthCubit() : super(const AuthLoadingState());

  Future<void> initial() async {
    try {
      final firebaseInit = await Firebase.initializeApp();
      log(firebaseInit.toString());
      auth = FirebaseAuth.instance;
      auth.userChanges().listen((user) {
          if(user != null) {
            emit(const AuthSignIn());
          } else {
            emit(const AuthInitial());
          }
      });
    } catch (e) {
      log('error: $e');
      emit(const AuthLoadingState());
    }
  }

  Future<void> signIn(
      {required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthSignInError(message: 'All fields must be filled out'));
      emit(const AuthInitial());
      return;
    }

    try {
      final UserCredential userCredential =
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(const AuthSignIn());
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'invalid-email') {
        emit(const AuthSignInError(message: 'Invalid email'));
        emit(const AuthInitial());
      } else if (e.code == 'wrong-password') {
        emit(const AuthSignInError(message: 'Wrong password'));
        emit(const AuthInitial());
      } else {
        emit(AuthSignInError(message: e.code));
        emit(const AuthInitial());
      }
    } catch (e) {
      log(e.toString());
      emit(const AuthRegistrationError(message: 'Something went wrong.'));
      emit(const AuthInitial());
    }
  }

  Future<void> registration(
      {required String email,
        required String password,
        required String passwordConfirmation}) async {
    if (password.isEmpty || email.isEmpty) {
      emit(const AuthRegistrationError(
          message: "All fields must be filled out"));
      emit(const AuthRegistration());
      return;
    } else if (password != passwordConfirmation) {
      emit(const AuthRegistrationError(message: "Passwords do not match"));
      emit(const AuthRegistration());
      return;
    }

    try {
      final UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userList.add(userCredential.user!);
      log('userList: $userList');
    } on FirebaseAuthException catch (e) {
      log(e.code);
      emit(const AuthRegistration());
      if (e.code == 'email-already-in-use') {
        emit(const AuthRegistrationError(message: 'Email already in use'));
        emit(const AuthRegistration());
      } else if (e.code == 'weak-password') {
        emit(const AuthRegistrationError(message: 'Weak password'));
        emit(const AuthRegistration());
      } else {
        emit(AuthRegistrationError(message: e.code));
        emit(const AuthRegistration());
      }
    } catch (e) {
      log(e.toString());
      emit(const AuthRegistrationError(message: 'Something went wrong.'));
      emit(const AuthRegistration());
    }
  }

  Future<void> logOut() async{
    await auth.signOut();
    emit(AuthLogOutState());
  }

}
