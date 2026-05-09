import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../models/song_model.dart';
import '../providers/playlist_provider.dart';
import '../utils/constants.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final String? playlistId; // Thêm biến này để biết bài hát đang thuộc playlist nào

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: _buildAlbumArt(context),
      title: Text(
        song.title,
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: TextStyle(
          color: AppColors.textSecondary(context),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.playlist_add, color: AppColors.textPrimary(context)),
                title: Text('Thêm vào playlist', style: TextStyle(color: AppColors.textPrimary(context))),
                onTap: () {
                  Navigator.pop(context);
                  _showPlaylistPicker(context);
                },
              ),
              if (playlistId != null) // Hiện nút xóa nếu đang ở trong Playlist
                ListTile(
                  leading: const Icon(Icons.playlist_remove, color: Colors.red),
                  title: const Text('Xóa khỏi playlist này', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    context.read<PlaylistProvider>().removeSongFromPlaylist(playlistId!, song.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xóa "${song.title}" khỏi playlist')),
                    );
                  },
                ),
              ListTile(
                leading: Icon(Icons.info_outline, color: AppColors.textPrimary(context)),
                title: Text('Thông tin bài hát', style: TextStyle(color: AppColors.textPrimary(context))),
                onTap: () {
                  Navigator.pop(context);
                  _showSongInfo(context);
                },
              ),
            ],
          ),
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
              leading: Icon(Icons.queue_music, color: AppColors.textPrimary(context)),
              title: Text(playlist.name, style: TextStyle(color: AppColors.textPrimary(context))),
              onTap: () async {
                await context.read<PlaylistProvider>().addSongToPlaylist(playlist.id, song.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm vào "${playlist.name}"')),
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
          title: Text('Thông tin bài hát', style: TextStyle(color: AppColors.textPrimary(context))),
          content: Text(
            'Tiêu đề: ${song.title}\nCa sĩ: ${song.artist}\nAlbum: ${song.album ?? "Không rõ"}\nĐường dẫn: ${song.filePath}',
            style: TextStyle(color: AppColors.textPrimary(context)),
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
