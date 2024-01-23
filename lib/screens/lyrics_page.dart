// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:musiclify/models/LyricsModel.dart';
// import 'package:musiclify/models/music.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// class LyricsPage extends StatefulWidget {
//   final MusicModel musicModel;
//   LyricsPage({
//     Key? key,
//     required this.musicModel,
//   }) : super(key: key);

//   @override
//   State<LyricsPage> createState() => _LyricsPageState();
// }

// class _LyricsPageState extends State<LyricsPage> {
//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ScrollOffsetController scrollOffsetController =
//       ScrollOffsetController();
//   final ItemPositionsListener itemPositionsListener =
//       ItemPositionsListener.create();
//   final ScrollOffsetListener scrollOffsetListener =
//       ScrollOffsetListener.create();

//   List<LyricsModel>? lyrics;

//   @override
//   void initState() {
//     get(Uri.parse(
//             'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${widget.musicModel.songName} ${widget.musicModel.artistName}&type=default'))
//         .then((response) {
//       String data = response.body;
//       if (data.isNotEmpty) {
//         lyrics = data
//             .split('\n')
//             .map((e) {
//               final timestampEndIndex = e.indexOf(']');
//               if (timestampEndIndex != -1 && e.length > timestampEndIndex + 1) {
//                 final timestamp = e.substring(1, timestampEndIndex);
//                 final words = e.substring(timestampEndIndex + 1).trim();
//                 try {
//                   final minutes = int.parse(timestamp.substring(0, 2));
//                   final seconds = int.parse(timestamp.substring(3, 5));
//                   final milliseconds = int.parse(timestamp.substring(
//                       6, 8)); // Adjust for 2 digits milliseconds
//                   final timeStamp = Duration(
//                     minutes: minutes,
//                     seconds: seconds,
//                     milliseconds: milliseconds,
//                   );
//                   return LyricsModel(words: words);
//                 } catch (e) {
//                   print('Failed to parse timestamp: $e');
//                 }
//               }
//               return null;
//             })
//             .where((model) => model != null)
//             .cast<LyricsModel>()
//             .toList();
//         setState(() {});
//         print('${response.body}');
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.musicModel.songColorm,
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             width:
//                 MediaQuery.of(context).size.width, // Adjust the width as needed
//             height: MediaQuery.of(context)
//                 .size
//                 .height, // Adjust the height as needed
//             child: lyrics != null && lyrics!.isNotEmpty
//                 ? ScrollablePositionedList.builder(
//                     itemCount: lyrics!.length,
//                     itemBuilder: (context, index) => ListTile(
//                       title: Text(
//                         lyrics![index].words ?? '',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     itemScrollController: itemScrollController,
//                     scrollOffsetController: scrollOffsetController,
//                     itemPositionsListener: itemPositionsListener,
//                     scrollOffsetListener: scrollOffsetListener,
//                   )
//                 : const Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:musiclify/models/LyricsModel.dart';
import 'package:musiclify/models/music.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricsPage extends StatefulWidget {
  final MusicModel music;
  final AudioPlayer player;

  const LyricsPage({super.key, required this.music, required this.player});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  List<LyricsModel>? lyrics;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    streamSubscription = widget.player.onPositionChanged.listen((duration) {
      DateTime dt = DateTime(1970, 1, 1).copyWith(
          hour: duration.inHours,
          minute: duration.inMinutes.remainder(60),
          second: duration.inSeconds.remainder(60));
      if (lyrics != null) {
        for (int index = 0; index < lyrics!.length; index++) {
          if (index > 4 && lyrics![index].timeStamp!.isAfter(dt)) {
            itemScrollController.scrollTo(
                index: index - 3, duration: const Duration(milliseconds: 600));
            break;
          }
        }
      }
    });
    get(Uri.parse(
            'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${widget.music.songName} ${widget.music.artistName}&type=default'))
        .then((response) {
      String data = response.body;
      lyrics = data
          .split('\n')
          .map((e) => LyricsModel(e.split(' ').sublist(1).join(' '),
              DateFormat("[mm:ss.SS]").parse(e.split(' ')[0])))
          .toList();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return lyrics != null
        ? SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0)
                  .copyWith(top: 20),
              child: StreamBuilder<Duration>(
                  stream: widget.player.onPositionChanged,
                  builder: (context, snapshot) {
                    return ScrollablePositionedList.builder(
                      itemCount: lyrics!.length,
                      itemBuilder: (context, index) {
                        Duration duration =
                            snapshot.data ?? const Duration(seconds: 0);
                        DateTime dt = DateTime(1970, 1, 1).copyWith(
                            hour: duration.inHours,
                            minute: duration.inMinutes.remainder(60),
                            second: duration.inSeconds.remainder(60));
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            lyrics![index].words ?? '',
                            style: TextStyle(
                              color: lyrics![index].timeStamp!.isAfter(dt)
                                  ? Colors.white38
                                  : Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      itemScrollController: itemScrollController,
                      scrollOffsetController: scrollOffsetController,
                      itemPositionsListener: itemPositionsListener,
                      scrollOffsetListener: scrollOffsetListener,
                    );
                  }),
            ),
          )
        : const SizedBox(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
  }
}
