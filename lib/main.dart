import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiclify/provider/GetTrackInfoEventProvider.dart';
import 'package:musiclify/screens/PlayerScreen/PlayingScreen.dart';
import 'package:musiclify/screens/SearchScreen/searchScreen.dart';
import 'package:musiclify/screens/dashboard/dashboardScreen.dart';
import 'package:musiclify/screens/PlayerScreen/playingSong.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => GetTrackInfoEventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => DashboardScreen(),
          '/search': (context) => SearchScreen(),
          '/player': (context) => PlayingScreen(),
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: SearchScreen(), // Start with HomeScreen as the initial screen
    );
  }
}
