// // ignore: import_of_legacy_library_into_null_safe
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<dynamic> fbLogin() async {
//   try {
//     final LoginResult result = await FacebookAuth.instance
//         .login(); // by default we request the email and the public profile
//     // or FacebookAuth.i.login()
//     if (result.status == LoginStatus.success) {
//       // you are logged
//       final AccessToken accessToken = result.accessToken!;
//       final graphResponse = await http.get(Uri.parse(
//           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));
//       final profile = jsonDecode(graphResponse.body);
//       return profile;
//     } else {
//       return {};
//     }
//   } catch (e) {
//     return {};
//   }
// }
