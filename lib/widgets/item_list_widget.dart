import 'package:flutter/material.dart';

class ItemListWidget extends StatelessWidget {
  final List<String> items; // Updated from names to items
  final ValueChanged<int> onRemoveItem; // Updated to item
  final ScrollController scrollController;

  ItemListWidget({
    required this.items,
    required this.onRemoveItem,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current theme background color for seamless blending
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        ListView.builder(
          controller: scrollController, // Attach the ScrollController
          shrinkWrap: true, // ListView takes only as much space as needed
          itemCount: items.length, // Updated to items.length
          itemBuilder: (context, index) {
            // Map reversed index to display new items visually at the top
            final reverseIndex = items.length - 1 - index; // Updated to items
            return ListTile(
              title: Text(items[reverseIndex]), // Updated to items[reverseIndex]
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onRemoveItem(reverseIndex), // Updated to item
              ),
            );
          },
        ),
        // Gradient fade at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer( // Ignore touch events on the gradient
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    backgroundColor.withOpacity(0), // Transparent at the top
                    backgroundColor.withOpacity(0.6), // Semi-transparent
                    backgroundColor.withOpacity(0.9), // Fully solid background color
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
