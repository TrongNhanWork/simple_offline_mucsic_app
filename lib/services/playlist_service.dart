import 'dart:io';
import 'package:on_audio_query/on_audio_query.dart' as audio_query;
import '../models/song_model.dart';

class PlaylistService {
  final audio_query.OnAudioQuery _audioQuery = audio_query.OnAudioQuery();

  Future<List<SongModel>> getAllSongs() async {
    final List<SongModel> result = [];

    try {
      final List<audio_query.SongModel> audioList =
      await _audioQuery.querySongs(
        sortType: audio_query.SongSortType.TITLE,
        orderType: audio_query.OrderType.ASC_OR_SMALLER,
        uriType: audio_query.UriType.EXTERNAL,
        ignoreCase: true,
      );

      result.addAll(
        audioList.map((audio) {
          return SongModel(
            id: audio.id.toString(),
            title: audio.title,
            artist: audio.artist ?? 'Unknown Artist',
            album: audio.album,
            filePath: audio.data,
            duration: Duration(milliseconds: audio.duration ?? 0),
            albumArt: null,
            fileSize: audio.size,
          );
        }),
      );
    } catch (_) {}

    if (result.isEmpty) {
      result.addAll(await _loadSongsFromFolder('/storage/emulated/0/Music'));
      result.addAll(await _loadSongsFromFolder('/sdcard/Music'));
      result.addAll(await _loadSongsFromFolder('/storage/emulated/0/Download'));
      result.addAll(await _loadSongsFromFolder('/sdcard/Download'));
    }

    return result;
  }

  Future<List<SongModel>> _loadSongsFromFolder(String folderPath) async {
    final folder = Directory(folderPath);

    if (!await folder.exists()) {
      return [];
    }

    final files = folder
        .listSync()
        .whereType<File>()
        .where((file) {
      final path = file.path.toLowerCase();
      return path.endsWith('.mp3') ||
          path.endsWith('.m4a') ||
          path.endsWith('.wav') ||
          path.endsWith('.flac') ||
          path.endsWith('.ogg');
    })
        .toList();

    return files.map((file) {
      final name = file.path.split('/').last;

      return SongModel(
        id: file.path,
        title: name.replaceAll('.mp3', ''),
        artist: 'Unknown Artist',
        album: 'Local Music',
        filePath: file.path,
        duration: Duration.zero,
        albumArt: null,
        fileSize: file.lengthSync(),
      );
    }).toList();
  }

  Future<List<SongModel>> getSongsByArtist(String artist) async {
    final allSongs = await getAllSongs();
    return allSongs.where((song) => song.artist == artist).toList();
  }

  Future<List<SongModel>> getSongsByAlbum(String album) async {
    final allSongs = await getAllSongs();
    return allSongs.where((song) => song.album == album).toList();
  }

  Future<List<SongModel>> searchSongs(String query) async {
    final allSongs = await getAllSongs();
    final lowerQuery = query.toLowerCase();

    return allSongs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery) ||
          (song.album?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}