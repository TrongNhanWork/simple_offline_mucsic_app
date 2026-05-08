import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../models/song_model.dart';
import '../providers/playlist_provider.dart';
import '../utils/constants.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      /// Album Art
      leading: _buildAlbumArt(context),

      /// Title
      title: Text(
        song.title,
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      /// Artist
      subtitle: Text(
        song.artist,
        style: TextStyle(
          color: AppColors.textSecondary(context),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      /// Menu
      trailing: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: AppColors.textSecondary(context),
        ),
        onPressed: () {
          _showOptionsMenu(context);
        },
      ),

      onTap: onTap,
    );
  }

  Widget _buildAlbumArt(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.cardBackground(context),
      ),
      child: song.albumArt != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(song.albumArt!),
          fit: BoxFit.cover,
        ),
      )
          : Icon(
        Icons.music_note,
        color: AppColors.textSecondary(context),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground(context),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.playlist_add,
                color: AppColors.textPrimary(context),
              ),
              title: Text(
                'Add to playlist',
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showPlaylistPicker(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: AppColors.textPrimary(context),
              ),
              title: Text(
                'Song info',
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showSongInfo(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showPlaylistPicker(BuildContext context) {
    final playlists = context.read<PlaylistProvider>().playlists;

    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa tạo playlist nào')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground(context),
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];

            return ListTile(
              leading: Icon(
                Icons.queue_music,
                color: AppColors.textPrimary(context),
              ),
              title: Text(
                playlist.name,
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                ),
              ),
              subtitle: Text(
                '${playlist.songIds.length} songs',
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                ),
              ),
              onTap: () async {
                await context
                    .read<PlaylistProvider>()
                    .addSongToPlaylist(playlist.id, song.id);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('Đã thêm "${song.title}" vào playlist'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showSongInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground(context),
          title: Text(
            'Song info',
            style: TextStyle(
              color: AppColors.textPrimary(context),
            ),
          ),
          content: Text(
            'Title: ${song.title}\n'
                'Artist: ${song.artist}\n'
                'Album: ${song.album ?? "Unknown"}',
            style: TextStyle(
              color: AppColors.textPrimary(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

