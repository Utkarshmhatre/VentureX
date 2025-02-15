import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/canvas_item.dart';

class BusinessCanvasScreen extends StatefulWidget {
  const BusinessCanvasScreen({super.key});

  @override
  _BusinessCanvasScreenState createState() => _BusinessCanvasScreenState();
}

class _BusinessCanvasScreenState extends State<BusinessCanvasScreen> {
  List<String> items = [
    'Value Proposition',
    'Customer Segment',
    'Revenue Stream',
    'Cost Structure',
    'Key Activities',
    'Key Resources',
    'Key Partners',
    'Channels',
    'Customer Relationships',
  ];

  Widget _buildGridBackground() {
    return CustomPaint(painter: GridPainter(), child: Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Canvas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save to db_service
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildGridBackground(),
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return DragTarget<String>(
                onAccept: (data) {
                  setState(() {
                    final fromIndex = items.indexOf(data);
                    final item = items.removeAt(fromIndex);
                    items.insert(index, item);
                  });
                },
                builder: (context, candidates, rejects) {
                  return Draggable<String>(
                    data: items[index],
                    feedback: Material(
                      elevation: 4,
                      child: CanvasItem(title: items[index]),
                    ),
                    childWhenDragging: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CanvasItem(title: items[index]),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Show dialog to add new canvas item
        },
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 1;

    for (var i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (var i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
