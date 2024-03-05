import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart' as offline;
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:just_audio_background/just_audio_background.dart' as just_audio;
import 'package:musiclify/constants/strings.dart';
import 'package:musiclify/models/LyricsModel.dart';
import 'package:musiclify/models/SonglistModel.dart';
import 'package:musiclify/models/TrackInfo.dart';
import 'package:musiclify/models/music.dart';
import 'package:musiclify/screens/PlayerScreen/PlayingScreen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class GetTrackInfoEventProvider extends ChangeNotifier {
  String QuerySearch = '';

  List<TrackInfo> TrackInfolist = [];
  List<MusicModel> MusicModelList = [];
  List<LyricsModel>? lyrics = [];
  List<Songs> songNam = [];
  final player = AudioPlayer();
  final OfflinePlayer = offline.AudioPlayer();
  var audioUrl;
  double downloadProgress = 0;
  Color? secColor;
  String? _downloadPath;
  bool isSongStarted = false;
  bool showBuffer = false;
  bool isDashboardChange = false;
  bool isOfflineSongStarted = false;

  String? songNameoffline;

  String? get downloadPath => _downloadPath;

  double? get DownloadDownloadProgress => downloadProgress;
  Duration _audioProgress = Duration.zero;

  Duration get audioProgress => _audioProgress;

  bool isPlaying = false;
  bool isofflinePlaying = false;
  bool isUiChanged = false;
  bool get _isPlaying => isPlaying;
  void updateAudioProgress(Duration progress) {
    _audioProgress = progress;
    notifyListeners();
  }

  void GetSearchQuery(String MyQuery) {
    QuerySearch = MyQuery;
    print('Searched for ${QuerySearch}');
    if (QuerySearch != '') {
      fetchData(QuerySearch);
      notifyListeners();
    } else {
      print('No Query to Search');
    }
    notifyListeners();
  }

  void ChangeUi() {
    isUiChanged = !isUiChanged;
    notifyListeners();
  }

  void isAudioPlaying() {
    if (player.playing) {
      isPlaying = false;
      player.pause();
    } else {
      isPlaying = true;
      player.play();
    }
  }

  void isofflineAudioPlaying() {
    if (OfflinePlayer.state == offline.PlayerState.playing) {
      isofflinePlaying = false;

      OfflinePlayer.pause();
    } else {
      isofflinePlaying = true;

      OfflinePlayer.resume();
    }
    notifyListeners();
  }

  Future<void> fetchData(String QuerySear) async {
    try {
      final credential = SpotifyApiCredentials(
          Mycredentials.clientID, Mycredentials.clientSecret);

      final spotify = SpotifyApi(credential);
      final bundledPages =
          await spotify.search.get(QuerySear, types: [SearchType.track]);

      final items = await bundledPages.getPage(10, 0);
      List<TrackInfo> NewTrackInfolist = [];

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

          TrackInfo trackInfo = TrackInfo(
              trackId: trackId,
              trackName: trackName,
              artistName: artistName,
              imgUrl: imageUrl,
              artistImage: artistUri);
          NewTrackInfolist.add(trackInfo);
        }
      }
      TrackInfolist = NewTrackInfolist;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void PrepareSong(BuildContext context, TrackInfo? trackInfo) async {
    print('preparing to play songs');
    List<MusicModel> NewMusicModelList = [];

    try {
      showBuffer = true;
      notifyListeners();
      if (trackInfo != null) {
        MusicModel musicModel = MusicModel(trackId: trackInfo.trackId);
        if (trackInfo.imgUrl != null) {
          musicModel.coverImage = trackInfo.imgUrl;
          PaletteGenerator paletteGenerator =
              await PaletteGenerator.fromImageProvider(
                  NetworkImage(trackInfo.imgUrl));
          if (paletteGenerator != null &&
              paletteGenerator.dominantColor != null) {
            // Extract the dominant color from the palette and assign it to songColorm
            Color dominantColor = paletteGenerator.dominantColor!.color;
            musicModel.songColorm = dominantColor;
          }
          musicModel.songName = trackInfo.trackName;
          String songName = trackInfo.trackName;
          musicModel.artistName = trackInfo.artistName;
          String artistName = trackInfo.artistName;
          if (songName != null) {
            final yt = YoutubeExplode();
            // final vid = await yt.search(songName);
            // print('Searchhhhhh ${vid}');
            final video =
                (await yt.search(songName + artistName + ' lyrics')).first;
            print('video details ${video}');
            final videoId = video.id.value;
            musicModel.duration = video.duration;
            NewMusicModelList.add(musicModel);

            MusicModelList = NewMusicModelList;
            final manifest = await yt.videos.streamsClient.getManifest(videoId);
            audioUrl = manifest.audioOnly.first.url;

            if (player.playing) {
              player.stop();
            }

            // Set the audio source
            await player
                .setAudioSource(
                  AudioSource.uri(
                    Uri.parse(audioUrl.toString()),
                    tag: just_audio.MediaItem(
                      id: trackInfo.trackId,
                      album: trackInfo.artistName ?? "Album name",
                      title: trackInfo.trackName ?? "Song name",
                      artUri: Uri.parse(trackInfo.imgUrl ??
                          'https://i1.sndcdn.com/artworks-000219264931-9s1lto-t500x500.jpg'),
                    ),
                  ),
                )
                .then((value) => {
                      player.play(),
                      isPlaying = true,
                      isSongStarted = true,
                      player.positionStream.listen((position) {
                        Duration progress = position;
                        updateAudioProgress(progress);
                      }),
                      showBuffer = false,
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayingScreen()),
                      ),
                    });
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void GoToOffline() async {
    if (player.playing) {
      player.stop();
    }
    if (OfflinePlayer.state == offline.PlayerState.playing) {
      OfflinePlayer.stop();
    }
    isOfflineSongStarted = false;
    Directory? downloadDir = await getDownloadsDirectory();
    if (downloadDir != null) {
      print('My path is ${downloadDir.path} !!!!!!!');
      songNam.clear();
      List<FileSystemEntity> fileList = downloadDir.listSync();

      // List to store the names of the songs

      // Iterate through the files and extract the names of the songs
      for (var file in fileList) {
        // Check if the file is an MP3 file
        if (file is File && file.path.endsWith('.mp3')) {
          // Extract the file name without the extension
          String fileName = file.path.split('/').last.split('.mp3').first;
          songNam.add(Songs(SongName: fileName, audioUrl: file));
        }
      }

      // Print the names of the songs
      print('Songs in directory:');
      songNam.forEach((songName) => print(songName));
    } else {
      print('No path found:(');
    }
    isSongStarted = !isSongStarted;
    isDashboardChange = !isDashboardChange;
    notifyListeners();
  }

  // Future PlayOfflineSongs(Songs songs) async {
  //   print('Starting offline song');
  //   try {
  //     if (player.playing) {
  //       await player.stop();
  //     }
  //     print('File path: ${songs.audioUrl.path}');
  //     await player.setFilePath(songs.audioUrl.path);
  //     await player.play();
  //     print('playing the offline songs1111111111111');
  //     notifyListeners();
  //   } catch (e) {
  //     print('Here is the error $e');
  //   }
  // }

  Future<void> PlayOfflineSongs(Songs songs) async {
    try {
      if (OfflinePlayer.state == offline.PlayerState.playing) {
        // If audio is currently playing, stop it first
        await OfflinePlayer.stop();
      }
      // Play the specified audio path

      await OfflinePlayer.play(offline.UrlSource(songs.audioUrl.path))
          .then((value) {
        isOfflineSongStarted = true;
        isofflinePlaying = true;
        songNameoffline = songs.SongName;
      });
      notifyListeners();
    } catch (e) {
      print('Error playing the offline song: $e');
    }
  }

  Future<void> SeekthePosition(Duration seekedPos) async {
    await player.seek(seekedPos);
    notifyListeners();
  }

  Future<void> LyricsLoader(String? songName, String? artistName) async {
    try {
      final response = await get(Uri.parse(
          'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${songName} ${artistName}&type=default'));
      String data = response.body;
      lyrics = data
          .split('\n')
          .map((e) => LyricsModel(e.split(' ').sublist(1).join(' '),
              DateFormat("[mm:ss.SS]").parse(e.split(' ')[0])))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading lyrics: $e');
    }
  }

  void setDownloadPath(String path) {
    _downloadPath = path;
    notifyListeners();
  }

  Future<void> pickDownloadPath(BuildContext context) async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      print('Here is the path !!!!!!!  ${result}');
      // setDownloadPath(result);
    }
  }

  Future<void> downloadAudio(String audioUrl, String? SongName) async {
    // Request permission to write to external storage
    var status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      print('Permission denied for storage');
      return;
    }

    Directory? downloadDir = await getDownloadsDirectory();
    if (downloadDir == null) {
      print('Error getting downloads directory');
      return;
    }

    print('Here is the downloadable path ${downloadDir.path}');

    String downloadPath = '${downloadDir.path}/$SongName.mp3';

    // Use Dio to download the audio
    try {
      var dio = Dio();
      var response = await dio.download(
        audioUrl,
        downloadPath, // Replace with your desired download path
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress = (received / total * 100);
            DownloadAudioProgress();
            print(
                'Download progress: ${(received / total * 100).toStringAsFixed(2)}%');
          }
        },
      );

      print('Download complete: ${response.statusCode}');
      print('File path: ${downloadPath}');
      downloadProgress = 0;
      notifyListeners();
    } catch (e) {
      await Future.delayed(Duration(seconds: 1));
      await downloadAudio(audioUrl, SongName);
      print('Error downloading audio: $e');
    }
  }

  double DownloadAudioProgress() {
    if (downloadProgress != 0 || downloadProgress != 100) {
      notifyListeners();
      return downloadProgress;
    } else {
      return 0;
    }
  }

  void SetAllParamBack() {
    print('Setting all param to initial value!!!');
    downloadProgress = 0;
    audioUrl = '';
    notifyListeners();
  }
}
