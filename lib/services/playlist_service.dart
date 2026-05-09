import 'dart:io';
import 'package:on_audio_query/on_audio_query.dart' as audio_query;
import '../models/song_model.dart';

class PlaylistService {
  final audio_query.OnAudioQuery _audioQuery = audio_query.OnAudioQuery();

  Future<List<SongModel>> getAllSongs() async {
    final Map<String, SongModel> songsMap = {};

    try {
      // 1. Query from MediaStore (indexed by system)
      final List<audio_query.SongModel> audioList =
      await _audioQuery.querySongs(
        sortType: audio_query.SongSortType.TITLE,
        orderType: audio_query.OrderType.ASC_OR_SMALLER,
        uriType: audio_query.UriType.EXTERNAL,
        ignoreCase: true,
      );

      for (var audio in audioList) {
        final song = SongModel(
          id: audio.id.toString(),
          title: audio.title,
          artist: audio.artist ?? 'Unknown Artist',
          album: audio.album,
          filePath: audio.data,
          duration: Duration(milliseconds: audio.duration ?? 0),
          albumArt: null,
          fileSize: audio.size,
        );
        songsMap[song.filePath] = song;
      }
    } catch (_) {}

    // 2. Manual scan common folders (to catch newly added files not yet indexed)
    final foldersToScan = [
      '/storage/emulated/0/Music',
      '/storage/emulated/0/Download',
      '/sdcard/Music',
      '/sdcard/Download',
    ];

    for (var path in foldersToScan) {
      final dir = Directory(path);
      if (await dir.exists()) {
        try {
          final files = dir.listSync(recursive: true).whereType<File>().where((file) {
            final ext = file.path.toLowerCase();
            return ext.endsWith('.mp3') || ext.endsWith('.m4a') || ext.endsWith('.wav');
          });

          for (var file in files) {
            if (!songsMap.containsKey(file.path)) {
              final name = file.path.split('/').last.split('.').first;
              songsMap[file.path] = SongModel(
                id: file.path,
                title: name,
                artist: 'Unknown Artist',
                album: 'Local',
                filePath: file.path,
                duration: Duration.zero,
                albumArt: null,
                fileSize: await file.length(),
              );
            }
          }
        } catch (_) {}
      }
    }

    return songsMap.values.toList();
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
