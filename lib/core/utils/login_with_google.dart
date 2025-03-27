import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<String?> signInWithGoogle() async {
  String? idToken;
  String? accessToken;
  final googleSignIn = GoogleSignIn(
    forceCodeForRefreshToken: true,
  );
  googleSignIn.signOut();
  await googleSignIn.currentUser?.clearAuthCache();
  await googleSignIn.signIn().then((result) async {
    await result?.authentication.then((googleKey) async {
      GoogleSignInAuthentication? x =
          await googleSignIn.currentUser?.authentication;
      idToken = x!.idToken;
      accessToken = x.accessToken;
    }).catchError((err) {
      debugPrint('inner error$err');
    });
  }).catchError((err) {
    debugPrint('error occured$err');
  });

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: accessToken,
    idToken: idToken,
  );
  UserCredential? userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  String? apiIdToken = await userCredential.user?.getIdToken();
  log(apiIdToken ?? '');
  return apiIdToken;
}

// Future signInFacebook() async {
//   // try {
//   //   final facebookLogin = FacebookLogin();
//   //
//   //   // bool isLoggedIn = await facebookLogin.isLoggedIn;
//   //
//   //   final FacebookLoginResult result = await facebookLogin.logIn(
//   //     permissions: [
//   //       FacebookPermission.publicProfile,
//   //       FacebookPermission.email,
//   //     ],
//   //   );
//   //
//   //   switch (result.status) {
//   //     case FacebookLoginStatus.Success:
//   //
//   //       String token = result.accessToken.token;
//   //
//   //       final AuthCredential credential =
//   //       FacebookAuthProvider.getCredential(accessToken: token);
//   //
//   //       await _auth.signInWithCredential(credential);
//   //
//   //       break;
//   //     case FacebookLoginStatus.Cancel:
//   //       break;
//   //     case FacebookLoginStatus.Error:
//   //       print(result.error);
//   //       break;
//   //   }
//   //
//   //   return true;
//   // } catch (error) {
//   //   return false;
//   // }
// }
//
// Future<String?> signInWithApple() async{
//   String? apiIdToken;
//   try {
//     final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ]);
//
//     // Create a Firebase credential from the Apple credential
//     final OAuthCredential credential = OAuthProvider('apple.com').credential(
//       idToken: appleCredential.identityToken,
//       accessToken: appleCredential.authorizationCode,
//     );
//
//     // Sign in with the Firebase credential
//     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//
//     // User signed in with Apple successfully
//     print('User signed in with Apple: ${userCredential.user!.displayName}');
//     apiIdToken = await userCredential.user?.getIdToken();
//     print('apiIdToken');
//
//     print(credential);
//
//     print(userCredential.user?.email);
//     print(userCredential.user?.phoneNumber);
//     print(userCredential.user?.displayName);
//     print(apiIdToken);
//   } catch (error) {
//     print('Error signing in with Apple: $error');
//   }
//
//
//     return apiIdToken;
// }
