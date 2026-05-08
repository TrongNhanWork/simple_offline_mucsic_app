import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class PlayerControls extends StatelessWidget {
  final AudioProvider provider;

  const PlayerControls({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.shuffle,
                color: provider.isShuffleEnabled
                    ? AppColors.primary
                    : AppColors.textSecondary(context),
              ),
              onPressed: () => provider.toggleShuffle(),
            ),
            const SizedBox(width: 40),
            _buildRepeatButton(context),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.skip_previous,
                color: AppColors.textPrimary(context),
                size: 40,
              ),
              onPressed: () => provider.previous(),
            ),

            StreamBuilder<bool>(
              stream: provider.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;

                return Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () => provider.playPause(),
                  ),
                );
              },
            ),

            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: AppColors.textPrimary(context),
                size: 40,
              ),
              onPressed: () => provider.next(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRepeatButton(BuildContext context) {
    IconData icon;
    Color color;

    switch (provider.loopMode) {
      case LoopMode.off:
        icon = Icons.repeat;
        color = AppColors.textSecondary(context);
        break;
      case LoopMode.all:
        icon = Icons.repeat;
        color = AppColors.primary;
        break;
      case LoopMode.one:
        icon = Icons.repeat_one;
        color = AppColors.primary;
        break;
    }

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () => provider.toggleRepeat(),
    );
  }
}