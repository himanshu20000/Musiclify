import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:extract_colors_from_image/extract_colors_from_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:musiclify/constants/strings.dart';
import 'package:musiclify/models/music.dart';
import 'package:musiclify/screens/lyrics_page.dart';

class PlayingSong extends StatefulWidget {
  const PlayingSong({super.key});

  @override
  State<PlayingSong> createState() => _PlayingSongState();
}

class _PlayingSongState extends State<PlayingSong>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  // String? artistName;1vYXt7VSjH9JIM5oRRo7vA
  // String? songnname,https://open.spotify.com/track/6NWgIuDeOr1Xeb4MZ1Bl6L?si=0873afdbc4f445e6,https://open.spotify.com/track/0HqZX76SFLDz2aW8aiqi7G?si=58a3af85145d4370;
  // "6NWgIuDeOr1Xeb4MZ1Bl6L ,'Maroon 5 ft.Future', https://open.spotify.com/track/5ZLkihi6DVsHwDL3B8ym1t?si=850502fbcfa849f7,https://open.spotify.com/track/4MQXkF0FjdlqEHy73IZfoO?si=ac8c1e26dcc94cf2 ,https://open.spotify.com/track/2FpWhUMOPGUVR95DkfKjGH?si=21ecf7a4932840ff,https://open.spotify.com/track/2ZGAWiLZh2aRxp2iTL5yMS?si=3f1a81337c3f4fea"
  String musicTrackId = "4MQXkF0FjdlqEHy73IZfoO";
  MusicModel musicModel = MusicModel(trackId: '0gPgdRfB4jdGrlyXS0Vx78');
  final player = AudioPlayer();
  String? coverImg;
  Duration? duration;
  bool isUiChanged = false;

  @override
  void initState() {
    final credential = SpotifyApiCredentials(
        Mycredentials.clientID, Mycredentials.clientSecret);

    final spotify = SpotifyApi(credential);
    // try {
    //   final sear = spotify.search.get('Saajanwa', types: [SearchType.track]);
    //   print(
    //       'SEARCJJ  ${sear.first().then((value) => value[0].items.toString())}');
    //   // print('SEARCJJ  ${sear.first().then((value) => value[0].toString())}');
    // } catch (e) {
    //   print(e);
    // }
    spotify.tracks.get(musicModel.trackId).then((track) async {
      String? songName = track.name;
      String? coverImg = track.album!.images?[0].url;
      if (coverImg != null) {
        musicModel.coverImage = coverImg;
        PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(NetworkImage(coverImg));

        if (paletteGenerator != null &&
            paletteGenerator.dominantColor != null) {
          // Extract the dominant color from the palette and assign it to songColorm
          Color dominantColor = paletteGenerator.dominantColor!.color;
          musicModel.songColorm = dominantColor;
          // Alternatively, set the color object itself if needed:
          // musicModel.songColorm = dominantColor;
        }
      }
      print('!!!!!!Here is color name = ${musicModel.songColorm}!!!!!!!!!!');
      if (songName != null) {
        musicModel.songName = songName;
        print('Artist NAME :- ${track.artists?[0].name.toString()}');
        musicModel.artistName = track.artists?[0].name.toString() ?? "";

        final yt = YoutubeExplode();
        // final vid = await yt.search(songName);
        // print('Searchhhhhh ${vid}');
        final video = (await yt.search(songName + ' lyrics')).first;
        print('video details ${video}');
        final videoId = video.id.value;
        musicModel.duration = video.duration;
        setState(() {});
        final manifest = await yt.videos.streamsClient.getManifest(videoId);
        var audioUrl = manifest.audioOnly.first.url;
        player
            .play(UrlSource(audioUrl.toString()))
            .then((value) => setState(() {
                  player.state = PlayerState.playing;
                }));

        // result[0].id.value;
      }
    });
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15), // Adjust the duration as needed
    )..repeat();
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    player.dispose();
    _rotationController
        .dispose(); // Dispose the AudioPlayer to release resources
    super.dispose();
  }

  fetchData() async {
    try {
      final credential = SpotifyApiCredentials(
          Mycredentials.clientID, Mycredentials.clientSecret);

      final spotify = SpotifyApi(credential);
      final bundledPages =
          await spotify.search.get('Khuda jaane', types: [SearchType.track]);

      final items = await bundledPages.getPage(10, 0);

      // Check if items is not null and has elements
      if (items.first.items != null && items.first.items!.isNotEmpty) {
        for (var track in items.first.items!) {
          // Extract track information
          String trackId = track.id ?? '';
          String trackName = track.name ?? '';
          var artist = track.artists?.first;
          String artistName = track.artists?.first.name ?? '';
          String artistUri = artist?.uri ?? ''; // Extracting artist URI
          String imageUrl = track.album?.images?.first.url ?? '';

          // Print the extracted information
          print('Track ID: $trackId');
          print('Track Name: $trackName');
          print('Artist Name: $artistName');
          print('Artist Image URL: $artistUri');
          print('Image URL: $imageUrl');
          print('-------------------');
        }
      } else {
        print('No items found.');
      }
    } catch (e) {
      print(e);
    }
  }

  // fetchData() async {
  //   try {
  //     final credential = SpotifyApiCredentials(
  //         Mycredentials.clientID, Mycredentials.clientSecret);

  //     final spotify = SpotifyApi(credential);
  //     final bundledPages =
  //         await spotify.search.get('Saajanwa', types: [SearchType.track]);

  //     final items = bundledPages.getPage(10, 0).then((value) {
  //       // Check if items is not null and has elements
  //       if (value.first.items != null && value.first.items!.isNotEmpty) {
  //         final trackNames = value.first.items!
  //             .map((track) => track
  //                 .name) // Assuming 'name' is a property of the Track class
  //             .toList();

  //         // Check if trackNames is not null before printing
  //         if (trackNames.isNotEmpty) {
  //           print('Track Names: ${trackNames.join(',')}');
  //         } else {
  //           print('No track names found.');
  //         }
  //       } else {
  //         print('No items found.');
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Sizes = MediaQuery.of(context).size;
    void ShowLyricsModal(BuildContext context) {
      showModalBottomSheet(
        showDragHandle: true,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        backgroundColor: musicModel.songColorm,
        builder: (context) => Container(
          height: Sizes.height * 0.8,
          child: LyricsPage(
            music: musicModel,
            player: AudioPlayer(),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: musicModel.songColorm,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  isUiChanged
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
                                    musicModel.coverImage ??
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
                            musicModel.coverImage ??
                                'https://i1.sndcdn.com/artworks-000219264931-9s1lto-t500x500.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0),
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.arrow_back)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              musicModel.songName ?? "",
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
              musicModel.artistName ?? 'Maroon 5 ft.Future',
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
              child: StreamBuilder(
                stream: player.onPositionChanged,
                builder: (context, data) {
                  return ProgressBar(
                    thumbGlowColor: Colors.grey,
                    progressBarColor: Color.fromARGB(255, 9, 86, 149),
                    bufferedBarColor: Colors.white,
                    thumbColor: Colors.white24,
                    baseBarColor: Color.fromARGB(255, 3, 32, 65),
                    progress: data.data ?? const Duration(seconds: 0),
                    total: musicModel.duration ??
                        Duration(minutes: 4, seconds: 32),
                    onSeek: (duration) {
                      player.seek(duration);
                    },
                  );
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
                    setState(() {
                      isUiChanged = !isUiChanged;
                    });
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
                IconButton(
                  onPressed: () async {
                    if (player.state == PlayerState.playing) {
                      await player.pause();
                    } else {
                      await player.resume();
                    }
                    setState(() {});
                  },
                  icon: player.state == PlayerState.playing
                      ? Icon(
                          Icons.pause_circle,
                          size: Sizes.width * 0.22,
                        )
                      : Icon(
                          Icons.play_circle,
                          size: Sizes.width * 0.22,
                        ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.skip_next,
                    size: Sizes.width * 0.1,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.loop,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      ShowLyricsModal(context);
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
