import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class FortuneWheelWidget extends StatefulWidget {
  final List<String> items;
  final List<Color> colors;
  final Color borderColor;
  final StreamController<int> streamController;
  final VoidCallback onSpin;

  FortuneWheelWidget({
    required this.items,
    required this.colors,
    required this.borderColor,
    required this.streamController,
    required this.onSpin,
  });

  @override
  _FortuneWheelWidgetState createState() => _FortuneWheelWidgetState();
}
class _FortuneWheelWidgetState extends State<FortuneWheelWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int? previousIndex;

  @override
  void dispose() {
    _audioPlayer.dispose(); // Release resources when the widget is destroyed
    super.dispose();
  }

  Future<void> _playClickSound() async {
    try {
      // Load and play the sound
      await _audioPlayer.play(AssetSource('sounds/click_wheel.wav'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  Future<void> _playEndSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/end_wheel.wav'));
    } catch (e) {
      debugPrint("Error playing end spin sound: $e");
    }
  }

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent, // Capture taps but pass them to children too
    onTap: () {
      FocusScope.of(context).unfocus(); // Remove keyboard focus
      // FocusManager.instance.primaryFocus?.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      widget.onSpin(); // Trigger spin
    },
    child: FortuneWheel(
      animateFirst: false,
      items: [
        for (int i = 0; i < widget.items.length; i++)
          FortuneItem(
            child: Text(
              widget.items[i],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 20, 20, 20),
              ),
            ),
            style: FortuneItemStyle(
              color: widget.colors[i % widget.colors.length],
              borderColor: widget.borderColor,
              textAlign: TextAlign.center,
            ),
          ),
      ],
      selected: widget.streamController.stream,
      onFocusItemChanged: (index) {
        if (previousIndex != index) {
          previousIndex = index;
          _playClickSound();
        }
      },
       onAnimationEnd: () {
          _playEndSound(); // Play sound when the wheel stops spinning
        },
    ),
  );
}

}