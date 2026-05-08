import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background(context),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Playback'),

          Consumer<AudioProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Shuffle',
                      style: TextStyle(color: AppColors.textPrimary(context)),
                    ),
                    subtitle: Text(
                      'Play songs in random order',
                      style: TextStyle(color: AppColors.textSecondary(context)),
                    ),
                    value: provider.isShuffleEnabled,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) {
                      provider.toggleShuffle();
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Volume',
                      style: TextStyle(color: AppColors.textPrimary(context)),
                    ),
                    subtitle: Slider(
                      value: 1.0,
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.grey,
                      onChanged: (val) {
                        provider.setVolume(val);
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          const Divider(color: Colors.grey),

          _buildSectionHeader('Appearance'),

          Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(color: AppColors.textPrimary(context)),
                ),
                subtitle: Text(
                  provider.isDarkMode
                      ? 'Current mode: Dark'
                      : 'Current mode: Light',
                  style: TextStyle(color: AppColors.textSecondary(context)),
                ),
                value: provider.isDarkMode,
                activeThumbColor: AppColors.primary,
                onChanged: (value) {
                  provider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}