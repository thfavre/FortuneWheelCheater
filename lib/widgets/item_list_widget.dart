import 'package:flutter/material.dart';

class ItemListWidget extends StatelessWidget {
  final List<String> items;
  final ValueChanged<int> onRemoveItem;
  final ScrollController scrollController;

  ItemListWidget({
    required this.items,
    required this.onRemoveItem,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final reverseIndex = items.length - 1 - index;
            return ListTile(
              title: Text("${reverseIndex+1}. ${items[reverseIndex]}"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onRemoveItem(reverseIndex),
              ),
            );
          },
        ),
        // Gradient fade at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    backgroundColor.withOpacity(0),
                    backgroundColor.withOpacity(0.6),
                    backgroundColor.withOpacity(0.9),
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
