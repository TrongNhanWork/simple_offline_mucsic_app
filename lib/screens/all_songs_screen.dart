import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../widgets/song_tile.dart';
import '../utils/constants.dart';

class AllSongsScreen extends StatelessWidget {
  final List<SongModel> songs;

  const AllSongsScreen({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              size: 80,
              color: AppColors.textSecondary(context),
            ),
            const SizedBox(height: 20),
            Text(
              'No Music Found',
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add some music files to your device',
              style: TextStyle(
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongTile(
          song: song,
          onTap: () {
            context.read<AudioProvider>().setPlaylist(songs, index);
          },
        );
      },
    );
  }
}