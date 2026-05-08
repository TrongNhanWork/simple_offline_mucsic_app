import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/playlist_service.dart';
import '../services/permission_service.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../widgets/mini_player.dart';
import '../utils/constants.dart';
import 'all_songs_screen.dart';
import 'playlist_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final PlaylistService _playlistService = PlaylistService();
  final PermissionService _permissionService = PermissionService();

  List<SongModel> _songs = [];
  bool _isLoading = true;
  bool _hasPermission = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    _hasPermission = await _permissionService.requestPermission();

    if (_hasPermission) {
      await _loadSongs();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSongs() async {
    try {
      final songs = await _playlistService.getAllSongs();
      if (mounted) {
        setState(() {
          _songs = songs;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading songs: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),

            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
                  : !_hasPermission
                  ? _buildPermissionDenied(context)
                  : _buildSelectedScreen(),
            ),

            Consumer<AudioProvider>(
              builder: (context, provider, child) {
                if (provider.currentSong == null) {
                  return const SizedBox.shrink();
                }
                return const MiniPlayer();
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.cardBackground(context),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary(context),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Playlists'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return AllSongsScreen(songs: _songs);
      case 1:
        return const PlaylistScreen();
      case 2:
        return const SettingsScreen();
      default:
        return AllSongsScreen(songs: _songs);
    }
  }

  Widget _buildAppBar(BuildContext context) {
    String title = 'My Music';
    if (_selectedIndex == 1) title = 'Playlists';
    if (_selectedIndex == 2) title = 'Settings';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_selectedIndex == 0)
            IconButton(
              icon: Icon(
                Icons.search,
                color: AppColors.textPrimary(context),
              ),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            size: 80,
            color: AppColors.textSecondary(context),
          ),
          const SizedBox(height: 20),
          Text(
            'Storage Permission Required',
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please grant storage permission to access music',
            style: TextStyle(
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () async {
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}