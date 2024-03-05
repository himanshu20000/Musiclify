import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musiclify/Animations/FadeAnimat.dart';
import 'package:musiclify/Animations/FadeImg.dart';
import 'package:musiclify/Animations/ListAnimation.dart';
import 'package:musiclify/helpers/DashCard.dart';
import 'package:musiclify/helpers/SongLists.dart';
import 'package:musiclify/helpers/TabsSong.dart';
import 'package:musiclify/models/DashCardModel.dart';
import 'package:musiclify/models/SonglistModel.dart';
import 'package:musiclify/provider/GetTrackInfoEventProvider.dart';
import 'package:musiclify/screens/dashboard/Onlinedashboard.dart';
import 'package:musiclify/screens/dashboard/offlinedash.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetTrackInfoEventProvider>(context);
    final size = MediaQuery.of(context).size;
    return provider.isDashboardChange ? OfflineDashboard() : OnlineDashboard();
  }
}
