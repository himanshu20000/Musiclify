import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:extract_colors_from_image/extract_colors_from_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiclify/provider/GetTrackInfoEventProvider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:musiclify/constants/strings.dart';
import 'package:musiclify/models/music.dart';
import 'package:musiclify/screens/LyricsScreen/lyrics_page.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingSongState();
}

class _PlayingSongState extends State<PlayingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  // AudioPlayer? player;

  // bool isUiChanged = false;
  void loadAudioSource() {
    // AudioPlayer player = Provider.of<GetTrackInfoEventProvider>(context).player;
    // var audioUrl =
    //     Provider.of<GetTrackInfoEventProvider>(context, listen: false).audioUrl;
  }

  @override
  void initState() {
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();
    // Future.delayed(Duration.zero, () {
    //   loadAudioSource();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // player?.dispose();
    _rotationController
        .dispose(); // Dispose the AudioPlayer to release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Sizes = MediaQuery.of(context).size;

    final provider =
        Provider.of<GetTrackInfoEventProvider>(context, listen: false);
    if (provider.isPlaying) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }
    final MusicModelList =
        Provider.of<GetTrackInfoEventProvider>(context).MusicModelList;
    double DownloadProgress =
        Provider.of<GetTrackInfoEventProvider>(context).DownloadAudioProgress();
    void ShowLyricsModal(BuildContext context) {
      showModalBottomSheet(
        showDragHandle: true,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        backgroundColor: MusicModelList[0].songColorm,
        builder: (context) => Container(
          height: Sizes.height * 0.8,
          child: LyricsPage(
            player: AudioPlayer(),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: MusicModelList[0].songColorm,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  !provider.isUiChanged
                      ? Padding(
                          padding: EdgeInsets.only(top: Sizes.height * 0.11),
                          child: Stack(
                            children: [
                              RotationTransition(
                                turns: _rotationController,
                                child: CircleAvatar(
                                  radius: Sizes.height * 0.22,
                                  backgroundImage: img.Image.network(
                                    // 'assets/ophela.jpg',
                                    MusicModelList[0].coverImage ??
                                        'https://i1.sndcdn.com/artworks-000219264931-9s1lto-t500x500.jpg',
                                    fit: BoxFit.cover,
                                  ).image,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: Sizes.width,
                          height: Sizes.height - 300,
                          // https://www.designformusic.com/wp-content/uploads/2019/05/ophelia-movie-soundtrack-album-cover-design.jpg'
                          child: img.Image.network(
                            // 'assets/ophela.jpg',
                            MusicModelList[0].coverImage ??
                                'https://i1.sndcdn.com/artworks-000219264931-9s1lto-t500x500.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                          // provider.SetAllParamBack();
                          // player.stop();
                          // player.dispose();

                          // Reset the rotation controller
                          _rotationController.stop();
                        },
                        icon: Icon(Icons.arrow_back)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              MusicModelList[0].songName ?? "",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              MusicModelList[0].artistName ?? 'Maroon 5 ft.Future',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Sizes.width * 0.055,
                right: Sizes.width * 0.055,
              ),
              child: ProgressBar(
                thumbGlowColor: Colors.grey,
                progressBarColor: Colors.blueAccent,
                bufferedBarColor: Colors.white,
                thumbColor: Colors.white24,
                baseBarColor: Color.fromARGB(255, 3, 32, 65),
                progress: provider.audioProgress,
                total: MusicModelList[0].duration ??
                    Duration(minutes: 0, seconds: 32),
                onSeek: (duration) {
                  provider.SeekthePosition(duration);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    provider.ChangeUi();
                  },
                  icon: const Icon(
                    Icons.lyrics_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.skip_previous,
                    size: Sizes.width * 0.1,
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        provider.isAudioPlaying();
                      },
                      icon: provider.isPlaying == true
                          ? Icon(
                              Icons.pause_circle,
                              size: Sizes.width * 0.22,
                            )
                          : Icon(
                              Icons.play_circle,
                              size: Sizes.width * 0.22,
                            ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.skip_next,
                    size: Sizes.width * 0.1,
                  ),
                ),
                Stack(
                  children: [
                    Visibility(
                      visible: DownloadProgress > 0 && DownloadProgress < 100,
                      child: Positioned(
                        right: Sizes.height * 0.008,
                        top: Sizes.height * 0.007,
                        child: CircularProgressIndicator(
                          value: DownloadProgress / 100,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.green),
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        provider.downloadAudio(
                            Provider.of<GetTrackInfoEventProvider>(context,
                                    listen: false)
                                .audioUrl
                                .toString(),
                            MusicModelList[0].songName);
                      },
                      icon: DownloadProgress != 100
                          ? const Icon(
                              Icons.download,
                            )
                          : const Icon(Icons.check_outlined),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () async {
                      await provider.LyricsLoader(MusicModelList[0].songName,
                              MusicModelList[0].artistName)
                          .then((value) => ShowLyricsModal(context));
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_up,
                      size: Sizes.width * 0.08,
                    ))
              ],
            )
          ],
        ));
  }
}
