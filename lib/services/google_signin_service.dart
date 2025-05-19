

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService{

  // final List<String> scopes = <String>[
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ];

    static final GoogleSignIn _googleSignIn = GoogleSignIn(
        // Optional clientId
        // clientId: 'your-client_id.apps.googleusercontent.com',
        scopes: [
            'email',
          ]
      );

    static Future signInWithGoogle() async {

      try{

        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        // googleUser.getAuthResponse().id_token;
        final googleKey = await account?.authentication;


        if(account !=null){
          print(account);

          final GoogleSignInAuthentication auth = await account.authentication;
          final String? idToken = auth.idToken;
          final String? accessToken = auth.accessToken;

          final signInWithGoogleEndpoint = Uri(
            scheme: 'https',
            host:'ser-inv-test-a0e4cf32afc0.herokuapp.com',
            path: '/api/login/google'
          );

          final session = await http.post(signInWithGoogleEndpoint,
          body: {
            'token': accessToken
          });

          print('========= ID TOKEN ===========');
          print(accessToken);
          print(accessToken);

          return session.body;
        }else{
          throw Exception("Google Sign-In failed or cancelled");
        }

      }catch(e){
        print('Error en google sign in');
        print(e);
        return false;
        // throw Exception("Error during Google Sign-In");
      }
    }


    static Future signOut() async{
      await _googleSignIn.signOut();
    }

}