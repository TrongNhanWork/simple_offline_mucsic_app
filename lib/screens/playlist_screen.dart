import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/playlist_provider.dart';
import '../widgets/playlist_card.dart';
import '../utils/constants.dart';
import 'playlist_detail_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Consumer<PlaylistProvider>(
        builder: (context, provider, child) {
          final playlists = provider.playlists;

          if (playlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.queue_music,
                    size: 80,
                    color: AppColors.textSecondary(context),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Playlists Found',
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];

              return PlaylistCard(
                playlist: playlist,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistDetailScreen(playlist: playlist),
                    ),
                  );
                },
                onDelete: () {
                  provider.deletePlaylist(playlist.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showCreatePlaylistDialog(context);
        },
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground(context),
          title: Text(
            'New Playlist',
            style: TextStyle(color: AppColors.textPrimary(context)),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: AppColors.textPrimary(context)),
            decoration: InputDecoration(
              hintText: 'Playlist name',
              hintStyle: TextStyle(color: AppColors.textSecondary(context)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.textSecondary(context),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Create',
                style: TextStyle(color: AppColors.primary),
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context
                      .read<PlaylistProvider>()
                      .createPlaylist(controller.text.trim());
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
