import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

final redirectUri = Uri.parse('https://google.com');
Future<void> authenticateWithSpotify() async {
  final authorizationUrl = 'https://accounts.spotify.com/authorize?'
      'client_id=1b38a4bdaa0a4f22b22ac357fce5046c'
      '&response_type=code'
      '&redirect_uri=${Uri.encodeComponent(redirectUri.toString())}'
      '&scope=user-read-private%20user-read-email'; // Define your required scopes

  try {
    final result = await FlutterWebAuth.authenticate(
      url: authorizationUrl,
      callbackUrlScheme: redirectUri.scheme,
    );

    // Parse the result (authorization code or access token) and proceed with API requests
    final uri = Uri.parse(result);
    final authCode = uri.queryParameters['code'];
    if (authCode != null) {
      // Authorization code obtained successfully, print it
      print('Authorization Code: $authCode');

      // Navigate to the desired screen or perform operations within your app
      // Example: Navigate back to the home screen
      print('Sucess ~~~~~~~~~~~~~~~~~~');
    } else {
      // Handle missing authorization code
      print('Authorization code not found');
    }
  } catch (e) {
    // Handle authentication errors
    print('Authentication failed: $e');
  }
}

Future<void> initUniLinks() async {
  try {
    final initialUri = await getInitialUri();
    handleIncomingUri(initialUri!);
  } on PlatformException {
    // Handle exceptions
  }

  getUriLinksStream().listen((Uri? uri) {
    if (uri != null && uri.scheme == redirectUri.scheme) {
      // Handle the URI here after authentication callback
      // Extract and process the authorization code or access token

      // Navigate to the desired screen or perform operations within your app
      // Example: Navigate back to the home screen
      print("Sucessss~~~~~~~~");
    }
  }, onError: (err) {
    // Handle errors
  });
}

void handleIncomingUri(Uri uri) {
  if (uri != null && uri.scheme == redirectUri.scheme) {
    // Handle the URI here after authentication callback
    // Extract and process the authorization code or access token

    // Navigate to the desired screen or perform operations within your app
    // Example: Navigate back to the home screen
    print('!!!!!!!Handle Incoming call by uri!!!!!!');
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Authenticated Successfully!'),
      ),
    );
  }
}
