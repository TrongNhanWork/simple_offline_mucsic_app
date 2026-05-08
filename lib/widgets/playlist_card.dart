import 'package:flutter/material.dart';

import '../models/playlist_model.dart';
import '../utils/constants.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground(context),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),


        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.queue_music,
            color: AppColors.textSecondary(context),
          ),
        ),


        title: Text(
          playlist.name,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),


        subtitle: Text(
          '${playlist.songIds.length} songs',
          style: TextStyle(
            color: AppColors.textSecondary(context),
          ),
        ),


        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete,
        ),

        onTap: onTap,
      ),
    );
  }
}