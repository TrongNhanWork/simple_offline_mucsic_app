import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';
import '../models/song_model.dart';
import '../models/playback_state_model.dart';
import '../widgets/album_art.dart';
import '../widgets/progress_bar.dart';
import '../widgets/player_controls.dart';
import '../utils/constants.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          final song = provider.currentSong;

          if (song == null) {
            return Center(
              child: Text(
                'No song playing',
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AlbumArt(song: song),
                        const SizedBox(height: 40),
                        _buildSongInfo(context, song),
                        const SizedBox(height: 40),
                        StreamBuilder<PlaybackState>(
                          stream: provider.playbackStateStream,
                          builder: (context, snapshot) {
                            final state = snapshot.data;
                            return ProgressBar(
                              position: state?.position ?? Duration.zero,
                              duration: state?.duration ?? Duration.zero,
                              onSeek: provider.seek,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        PlayerControls(provider: provider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textPrimary(context),
              size: 32,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Now Playing',
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textPrimary(context),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSongInfo(BuildContext context, SongModel song) {
    return Column(
      children: [
        Text(
          song.title,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          song.artist,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}