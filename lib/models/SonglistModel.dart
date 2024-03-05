import 'dart:io';

class SongListModel {
  final String SongImg;
  final String SongName;
  final String artistName;

  SongListModel(
      {required this.SongImg,
      required this.SongName,
      required this.artistName});
}

class Songs {
  final String SongName;
  final File audioUrl;

  Songs({
    required this.SongName,
    required this.audioUrl,
  });
}
