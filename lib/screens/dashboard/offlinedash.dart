import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musiclify/Animations/FadeAnimat.dart';
import 'package:musiclify/Animations/ListAnimation.dart';
import 'package:musiclify/helpers/SongLists.dart';
import 'package:musiclify/helpers/SongsOffline.dart';
import 'package:musiclify/provider/GetTrackInfoEventProvider.dart';
import 'package:provider/provider.dart';

class OfflineDashboard extends StatelessWidget {
  const OfflineDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetTrackInfoEventProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
          child: Row(
            children: [
              Lottie.asset('assets/musicify.json',
                  height: size.height * 0.08, width: size.height * 0.08),
              Text(
                'Offline',
                style: TextStyle(
                    fontSize: size.height * 0.025, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: size.height * 0.02),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_outlined),
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: size.height * 0.025),
              child: SizedBox(
                height: size.height * 0.04,
                width: size.height * 0.055,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: provider.isDashboardChange,
                    onChanged: (value) {
                      print('Switch is tapped');
                      provider.GoToOffline();
                    },
                  ),
                ),
              ))
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: size.height * 0.028, top: size.height * 0.01),
                  child: FadeAnimation(
                    2,
                    Text(
                      'Songs',
                      style: TextStyle(
                          fontSize: size.height * 0.055,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: size.height * 0.04),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.038),
                      child: FadeAnimation(
                          1, SongsOffline(songs: provider.songNam[index])),
                    );
                  },
                  childCount: provider.songNam.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: size.height * 0.1),
              ),
            ],
          ),
          Visibility(
            visible:
                provider.isOfflineSongStarted && provider.songNam.isNotEmpty,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: size.height * 0.1,

                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          size.height * 0.02,
                        ),
                        topRight: Radius.circular(
                          size.height * 0.02,
                        ),
                      )), // Set your desired height

                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.02),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        if (provider.songNam.isNotEmpty &&
                            provider.songNameoffline != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.005,
                                      left: size.height * 0.015),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          provider.songNameoffline ?? "Hello",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: size.height * 0.03,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  provider.isofflineAudioPlaying();
                                },
                                icon: provider.isofflinePlaying == true
                                    ? Icon(
                                        Icons.pause_circle,
                                        size: size.width * 0.1,
                                      )
                                    : Icon(
                                        Icons.play_circle,
                                        size: size.width * 0.1,
                                      ),
                              ),
                            ],
                          ),
                        // if (provider.audioProgress > Duration.zero)
                        //   Expanded(
                        //     child: ProgressBar(
                        //       thumbGlowColor: Colors.grey,
                        //       progressBarColor: Colors.blueAccent,
                        //       bufferedBarColor: Colors.white,
                        //       thumbColor: Colors.white24,
                        //       baseBarColor: Color.fromARGB(255, 3, 32, 65),
                        //       progress: provider.audioProgress,
                        //       total: provider.MusicModelList[0].duration ??
                        //           Duration(minutes: 0, seconds: 32),
                        //       onSeek: (duration) {
                        //         provider.SeekthePosition(duration);
                        //       },
                        //     ),
                        //   ),
                      ],
                    ),
                  ), // Customize the color
                  // Add your mini player content here...
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
