import 'package:flutter/material.dart';
import '../models/canvas_item_model.dart';

class EditCanvasItemDialog extends StatefulWidget {
  final CanvasItemModel item;

  const EditCanvasItemDialog({Key? key, required this.item}) : super(key: key);

  @override
  _EditCanvasItemDialogState createState() => _EditCanvasItemDialogState();
}

class _EditCanvasItemDialogState extends State<EditCanvasItemDialog> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.item.content);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.item.type}'),
      content: SingleChildScrollView(
        child: TextField(
          controller: _textController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter your text here...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final updatedItem = CanvasItemModel(
              id: widget.item.id,
              type: widget.item.type,
              content: _textController.text,
              x: widget.item.x,
              y: widget.item.y,
              width: widget.item.width,
              height: widget.item.height,
            );
            Navigator.of(context).pop(updatedItem);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
