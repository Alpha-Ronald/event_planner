import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Method to verify if a username already exists
  Future<bool> checkUsernameExists(String username) async {
    final usernameExists = await _fireStore
        .collection('users')
        .doc(username)
        .get()
        .then((doc) => doc.exists);
    return usernameExists;
  }

  // Method to send OTP for phone number verification
  Future<void> signUpWithPhoneNumber({
    required String phoneNumber,
    required String username,
    required String fullName,
    required String gender,
    required Function(String) codeSentCallback, // Function to handle OTP
  }) async {
    try {
      log("Sign up process started");
      log("Phone Number: $phoneNumber, Username: $username");
      // Check if username already exists
      final usernameExists = await checkUsernameExists(username);
      if (usernameExists) {
        throw Exception('Username already taken.');
      }
      log("Sending OTP to: $phoneNumber");

      // Send OTP to the phone number
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log("OTP auto-resolved. Signing in...");
          // Auto-resolve the SMS verification code (if applicable)
          await _auth.signInWithCredential(credential);
          // Additional logic (if needed)
        },
        verificationFailed: (FirebaseAuthException e) {
          log("Phone number verification failed: ${e.message}");
          throw Exception('Phone number verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          log("OTP sent successfully. Verification ID: $verificationId");
          // Save verificationId for later and handle OTP input
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto retrieval timeout. Verification ID: $verificationId");
          // Handle timeout (optional)
        },
      );
    } catch (e) {
      log("Failed to send OTP: ${e.toString()}");
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  // Method to verify the OTP and create an account
  Future<User?> verifyOTPAndCreateAccount({
    required String verificationId,
    required String smsCode,
    required String username,
    required String fullName,
    required String gender,
  }) async {
    try {
      // Create a PhoneAuthCredential with the provided OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with the credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Storing additional user data in Firestore
      if (user != null) {
        await _fireStore.collection('users').doc(username).set({
          'uid': user.uid,
          'username': username,
          'phoneNumber': user.phoneNumber,
          'fullName': fullName,
          'gender': gender,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      throw Exception(
          'Failed to verify OTP and create account: ${e.toString()}');
    }
  }

  //Sign up with Email and Password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String gender,
  }) async {
    try {
      //check if userName exists
      final usernameExists = await _fireStore
          .collection('users')
          .doc(username)
          .get()
          .then((doc) => doc.exists);

      if (usernameExists) {
        throw Exception('Username already taken.');
      }

      //Create User with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      //Storing additional data in firestore
      if (user != null) {
        await _fireStore.collection('users').doc(username).set({
          'uid': user.uid,
          'username': username,
          'email': email,
          'fullName': fullName,
          'gender': gender,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Send verification email
        await user.sendEmailVerification();
      }
      return user;
    } catch (e) {
      // throw Exception('Failed to sign up: $e');
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already in use.';
            break;
          case 'weak-password':
            errorMessage = 'Password must be at least 6 characters.';
            break;
          case 'invalid-email':
            errorMessage = 'Please enter a valid email address.';
            break;
          default:
            errorMessage = 'Failed to create an account. Please try again.';
        }
      } else if (e.toString().contains('Username already taken')) {
        errorMessage = 'Username is already taken. Please choose another one.';
      } else {
        errorMessage = e.toString();
      }

      throw errorMessage;
    }
  }

  //Sign In with Email and Password
  Future<User?> signInWithUsernameOrEmail(String input, String password) async {
    try {
      String? email = input;

      // Check if input is an email
      if (!_isValidEmail(input)) {
        // If it's not an email, assume it's a username and query Firestore for the associated email
        email = await _getEmailFromUsername(input);
        if (email == null) {
          throw Exception('No user found with this username.');
        }
      }

      // Now sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        throw Exception('Please verify your email before logging in.');
      }

      return user;
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email or username.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          default:
            errorMessage = 'Failed to sign in. Please try again.';
        }
      } else {
        errorMessage = e.toString();
      }

      throw errorMessage;
    }
  }

  // Helper function to check if input is a valid email
  bool _isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(input);
  }

  // Helper function to get the email associated with a username
  Future<String?> _getEmailFromUsername(String username) async {
    try {
      final snapshot = await _fireStore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['email'];
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching email for username: $e');
    }
  }

  //send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } catch (error) {
      print("Error sending password reset email: $error");
      throw error;
    }
  }

  //Send verification email
  Future<void> resendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print("Verification email sent.");
      } catch (error) {
        print("Error resending verification email: $error");
        throw error;
      }
    } else {
      print("User is either not logged in or already verified.");
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// Future<User?> signInWithEmailAndPassword(
//     String email, String password) async {
//   try {
//     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     User? user = userCredential.user;
//
//     if (user != null) {
//       // Check if email is verified
//       if (!user.emailVerified) {
//         throw Exception('Please verify your email before logging in.');
//       }
//     }
//     return user;
//   } catch (e) {
//     // throw Exception('Failed to sign in $e');
//     String errorMessage;
//
//     if (e is FirebaseAuthException) {
//       switch (e.code) {
//         case 'user-not-found':
//           errorMessage = 'No user found with this email.';
//           break;
//         case 'wrong-password':
//           errorMessage = 'Incorrect password.';
//           break;
//         default:
//           errorMessage = 'Failed to sign in. Please try again.';
//       }
//     } else {
//       errorMessage = e.toString();
//     }
//
//     throw errorMessage;
//   }
// }
