import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../providers/playlist_provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/song_tile.dart';
import '../services/playlist_service.dart';
import '../utils/constants.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<SongModel> _playlistSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final playlistService = PlaylistService();
    final allSongs = await playlistService.getAllSongs();
    
    if (mounted) {
      setState(() {
        _playlistSongs = allSongs.where((song) => widget.playlist.songIds.contains(song.id)).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.playlist.name, style: TextStyle(color: AppColors.textPrimary(context))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PlaylistProvider>(
        builder: (context, provider, child) {

          final currentPlaylist = provider.playlists.firstWhere((p) => p.id == widget.playlist.id, orElse: () => widget.playlist);

          _updateSongsList(currentPlaylist.songIds);

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (_playlistSongs.isEmpty) {
            return Center(
              child: Text(
                'No songs in this playlist',
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
            );
          }

          return ListView.builder(
            itemCount: _playlistSongs.length,
            itemBuilder: (context, index) {
              final song = _playlistSongs[index];
              return SongTile(
                song: song,
                playlistId: currentPlaylist.id,
                onTap: () {
                  context.read<AudioProvider>().setPlaylist(_playlistSongs, index);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _updateSongsList(List<String> songIds) async {

     if (_playlistSongs.length != songIds.length) {
       _loadSongs();
     }
  }
}
