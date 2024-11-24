import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../widgets/fortune_wheel_widget.dart';
import '../widgets/item_input_widget.dart';
import '../widgets/item_list_widget.dart';
import '../utils/color_palette.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];
  final StreamController<int> _selectedStreamController =
      StreamController<int>.broadcast();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add at least two items to spin the wheel!')),
      );
      return;
    }

    final biasIndex = _getBiasIndex();
    final randomIndex =
        biasIndex != -1 ? biasIndex : Random().nextInt(_items.length);

    _selectedStreamController.add(randomIndex);
  }

  int _getBiasIndex() {
    final biases = ['tim', 'mothe', 'tite', 'titus', 'bg', 'tit', 'rexx', '289', 'blon', 'mel'];
    return biases
        .map((bias) =>
            _items.indexWhere((item) => item.toLowerCase().contains(bias)))
        .firstWhere((index) => index != -1, orElse: () => -1);
  }

  List<String> _getWheelItems() {
    if (_items.isEmpty) return ["", ""]; // Default text for empty wheel
    if (_items.length == 1)
      return [_items[0], ""]; // Prompt for adding more items
    return _items; // Use actual items for normal wheel
  }

  List<Color> _getWheelColors() {
    if (_items.isEmpty)
      return [Colors.grey, Colors.grey]; // Default color for empty wheel
    if (_items.length == 1)
      return [ColorPalette.customColors[0], Colors.grey]; // One item + grey
    return ColorPalette.customColors; // Colors for normal wheel
  }

  Color _getWheelBorderColor() {
    if (_items.isEmpty)
      return Colors.grey; // Default border color for empty wheel
    if (_items.length == 1) return Colors.grey; // Default border for one item
    return Colors.white; // Normal border for multiple items
  }
@override
Widget build(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus(); // Remove keyboard focus
    },
    child: Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Wheel of Fortune')),
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
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    ),
  );
}
}
