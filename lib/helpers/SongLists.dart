import 'package:flutter/material.dart';
import 'package:musiclify/models/SonglistModel.dart';
import 'package:musiclify/models/TrackInfo.dart';
import 'package:musiclify/provider/GetTrackInfoEventProvider.dart';
import 'package:provider/provider.dart';

class SongList extends StatelessWidget {
  SongList({super.key, this.songListModel, this.trackInfo});
  SongListModel? songListModel;
  TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.width * 0.04),
      child: Container(
        decoration: BoxDecoration(
          // color: Color(0xff333333),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(
            size.height * 0.03,
          ),
        ),
        height: size.height * 0.1,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: size.height * 0.0015,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.height * 0.02),
                child: Image.network(
                  songListModel?.SongImg ?? trackInfo!.imgUrl,
                  fit: BoxFit.cover,
                  height: size.height * 0.094,
                  width: size.height * 0.085,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.015, left: size.height * 0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      songListModel?.SongName ?? trackInfo!.trackName,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: size.height * 0.04, color: Colors.white),
                    ),
                    Text(
                      songListModel?.artistName ?? trackInfo!.artistName,
                      style: TextStyle(
                          fontSize: size.height * 0.015, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.12,
            ),
            IconButton(
                onPressed: () {
                  Provider.of<GetTrackInfoEventProvider>(context, listen: false)
                      .PrepareSong(context, trackInfo);
                },
                icon: Icon(
                  Icons.play_circle_fill,
                  size: size.height * 0.045,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
