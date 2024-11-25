import 'package:flutter/material.dart';

class ItemInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onAddItem;
  final FocusNode focusNode = FocusNode();

  ItemInputWidget({required this.controller, required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: const InputDecoration(
              labelText: 'Enter an item',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              onAddItem(value);
              controller.clear();
              focusNode.requestFocus();
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              onAddItem(controller.text);
              controller.clear();
              focusNode.requestFocus();
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
