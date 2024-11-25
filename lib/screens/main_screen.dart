import 'package:flutter/material.dart';
import 'package:randomizer/utils/lighten.dart';
import 'dart:async';
import 'dart:math';
import '../widgets/fortune_wheel_widget.dart';
import '../widgets/item_input_widget.dart';
import '../widgets/item_list_widget.dart';
import '../utils/color_palette.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];
  final StreamController<int> _selectedStreamController =
      StreamController<int>.broadcast();
  int? _cheatCount;
  bool _isSpinning = false;

  @override
  void dispose() {
    _controller.dispose();
    _selectedStreamController.close();
    super.dispose();
  }

  void _addItem(String item) {
    if (item.trim().isNotEmpty) {
      setState(() {
        _items.add(item.trim());
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _spinWheel() {
    if (_items.length < 2) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Add at least two items to spin the wheel!')),
      );
      return;
    }

    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
    });

    final randomIndex = _cheatCount ?? Random().nextInt(_items.length);
    setState(() {
      _cheatCount = null;
    });
    _selectedStreamController.add(randomIndex);
  }

  List<String> _getWheelItems() {
    if (_items.isEmpty) return ["", ""];
    if (_items.length == 1) {
      return [_items[0], ""];
    }
    return _items;
  }

  List<Color> _getWheelColors() {
    if (_items.isEmpty) {
      return [Colors.grey, Colors.grey];
    }
    if (_items.length == 1) {
      return [ColorPalette.customColors[0], Colors.grey];
    }
    return ColorPalette.customColors;
  }

  Color _getWheelBorderColor() {
    if (_items.isEmpty) {
      return Colors.grey;
    }
    if (_items.length == 1) return Colors.grey;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Wheel of Fortune')),
        ),
        body: Column(
          children: [
            ItemInputWidget(
              controller: _controller,
              onAddItem: _addItem,
            ),
            Expanded(
              flex: 2,
              child: ItemListWidget(
                items: _items,
                onRemoveItem: _removeItem,
                scrollController: ScrollController(),
              ),
            ),
            Expanded(
              flex: 3,
              child: FortuneWheelWidget(
                items: _getWheelItems(),
                colors: _getWheelColors(),
                borderColor: _getWheelBorderColor(),
                streamController: _selectedStreamController,
                onSpin: _spinWheel,
                onAnimationEnd: () {
                  setState(() {
                    _isSpinning = false;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
        // cheating button
        floatingActionButton: GestureDetector(
          onTap: () {
            if (_items.isEmpty) return;
            int? newCheatCount;
            newCheatCount = _cheatCount == null ? 0 : _cheatCount! + 1;
            if (newCheatCount >= _items.length) newCheatCount = null;
            setState(() {
              _cheatCount = newCheatCount;
            });
          },
          onLongPress: () {
            setState(() {
              _cheatCount = null;
            });
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors
                  .transparent, //Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              // '${_cheatCount == null ? '' : _items[_cheatCount!].substring(0, _items[_cheatCount!].length < 5 ? _items[_cheatCount!].length : 5)}',
              '${_cheatCount == null ? "" : _cheatCount! + 1}',
              style: TextStyle(
                fontSize: 15,
                color: lighten(Theme.of(context).scaffoldBackgroundColor, 0.03),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
