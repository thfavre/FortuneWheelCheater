import 'package:flutter/material.dart';

class ItemInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onAddItem;
  final FocusNode focusNode = FocusNode(); // Add a FocusNode

  ItemInputWidget({required this.controller, required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode, // Attach the FocusNode to the TextField
            decoration: InputDecoration(
              labelText: 'Enter an item',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              onAddItem(value);
              controller.clear();
              // Keep the focus on the TextField
              focusNode.requestFocus();
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              onAddItem(controller.text);
              controller.clear();
              // Keep the focus on the TextField
              focusNode.requestFocus();
            },
            child: Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
