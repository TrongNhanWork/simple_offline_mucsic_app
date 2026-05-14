import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/duration_formatter.dart';

class ProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Function(Duration) onSeek;

  const ProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double? _dragValue; // Lưu giá trị khi đang kéo

  @override
  Widget build(BuildContext context) {
    final max = widget.duration.inMilliseconds > 0
        ? widget.duration.inMilliseconds.toDouble()
        : 1.0;

    // Nếu đang kéo thì dùng giá trị kéo, không thì dùng vị trí thực tế của bài hát
    final value = _dragValue ?? widget.position.inMilliseconds
        .toDouble()
        .clamp(0.0, max);

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.textSecondary(context).withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: AppColors.primary.withOpacity(0.3),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: max,
            onChanged: (v) {
              setState(() {
                _dragValue = v; // Cập nhật vị trí hiển thị khi đang kéo
              });
            },
            onChangeEnd: (v) {
              widget.onSeek(Duration(milliseconds: v.toInt()));
              setState(() {
                _dragValue = null; // Thả tay ra thì xóa giá trị tạm thời
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // Hiển thị thời gian theo vị trí đang kéo hoặc vị trí thực tế
                DurationFormatter.format(_dragValue != null 
                    ? Duration(milliseconds: _dragValue!.toInt()) 
                    : widget.position),
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 12,
                ),
              ),
              Text(
                DurationFormatter.format(widget.duration),
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
