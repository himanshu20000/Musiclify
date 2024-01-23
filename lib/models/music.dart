import 'package:flutter/material.dart';

class MusicModel {
  Duration? duration;
  String trackId;
  String? artistName;
  String? songName;
  String? coverImage;
  Color? songColorm;

  MusicModel(
      {this.duration,
      required this.trackId,
      this.artistName,
      this.songName,
      this.coverImage,
      this.songColorm});
}
