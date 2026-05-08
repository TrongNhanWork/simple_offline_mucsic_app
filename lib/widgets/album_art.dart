import 'package:flutter/material.dart';
import 'dart:io';

import '../models/song_model.dart';
import '../utils/constants.dart';

class AlbumArt extends StatelessWidget {
  final SongModel song;

  const AlbumArt({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: song.albumArt != null
            ? Image.file(
          File(song.albumArt!),
          fit: BoxFit.cover,
        )
            : Container(
          color: AppColors.cardBackground(context),
          child: Icon(
            Icons.music_note,
            size: 100,
            color: AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }
}