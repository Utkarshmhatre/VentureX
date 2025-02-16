import 'package:flutter/material.dart';
import '../widgets/canvas_item.dart';
import '../services/db_service.dart';
import '../models/canvas_item_model.dart';
import '../widgets/edit_canvas_item_dialog.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data' show Uint8List;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BusinessCanvasScreen extends StatefulWidget {
  const BusinessCanvasScreen({Key? key}) : super(key: key);

  @override
  _BusinessCanvasScreenState createState() => _BusinessCanvasScreenState();
}

class _BusinessCanvasScreenState extends State<BusinessCanvasScreen>
    with TickerProviderStateMixin {
  List<CanvasItemModel> items = [];
  final DbService dbService = DbService();
  final TransformationController _transformationController =
      TransformationController();
  double _scale = 1.0;
  final GlobalKey _canvasKey = GlobalKey();
  Offset _lastPanOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadCanvasItems();
  }

  Future<void> _loadCanvasItems() async {
    final loadedItems = await dbService.getCanvasItems();
    setState(() {
      items = loadedItems;
    });
  }

  Future<void> _saveCanvasItem(CanvasItemModel item) async {
    await dbService.insertCanvasItem(item);
  }

  Future<void> _deleteCanvasItem(int id) async {
    await dbService.deleteCanvasItem(id);
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  Future<void> _saveCanvasItemsToDb(BuildContext context) async {
    String canvasData = jsonEncode(items.map((item) => item.toMap()).toList());

    try {
      // Request storage permission
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }

      // Use external storage
      final directory = await getExternalStorageDirectory();
      if (directory == null)
        throw Exception('Unable to access external storage');

      final file = io.File('${directory.path}/business_canvas.json');
      await file.writeAsString(canvasData);

      await Share.shareFiles([file.path], text: 'Business Canvas Data');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Canvas data ready to share!')),
      );
    } catch (e) {
      print('Error saving file: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error saving canvas data')));
    }
  }

  void _addCanvasItem(String type) {
    final newItem = CanvasItemModel(
      id: DateTime.now().millisecondsSinceEpoch,
      type: type,
      content: 'Define your $type here...',
      x: 0.0,
      y: 0.0,
      width: 200.0,
      height: 150.0,
    );

    setState(() {
      items.add(newItem);
    });
    _saveCanvasItem(newItem);
  }

  void _updateCanvasItem(CanvasItemModel updatedItem) {
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      setState(() {
        items[index] = updatedItem;
      });
    }
  }

  void _handleTapDown(TapDownDetails details, BoxConstraints constraints) {
    final RenderBox box =
        _canvasKey.currentContext?.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final Matrix4 transform = _transformationController.value.clone();
    final double scale = transform.getMaxScaleOnAxis();

    final newX = (localPosition.dx - transform.getTranslation().x) / scale;
    final newY = (localPosition.dy - transform.getTranslation().y) / scale;

    _lastPanOffset = Offset(newX, newY);
  }

  Widget _buildGridBackground() {
    return CustomPaint(painter: GridPainter(), child: Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Model Canvas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveCanvasItemsToDb(context),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () async {
              bool? confirmClear = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Clear Canvas'),
                    content: const Text(
                      'Are you sure you want to clear the entire canvas? This action cannot be undone.',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Clear'),
                      ),
                    ],
                  );
                },
              );

              if (confirmClear == true) {
                await dbService.clearCanvasItems();
                setState(() {
                  items.clear();
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildGridBackground(),
          LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTapDown: (details) => _handleTapDown(details, constraints),
                child: InteractiveViewer(
                  key: _canvasKey,
                  transformationController: _transformationController,
                  minScale: 0.5,
                  maxScale: 2.0,
                  constrained:
                      false, // Allow content to be larger than viewport
                  boundaryMargin: EdgeInsets.all(double.infinity),
                  child: SizedBox(
                    // Make the canvas area larger than the screen
                    width: constraints.maxWidth * 2,
                    height: constraints.maxHeight * 2,
                    child: Stack(
                      children:
                          items.map((item) {
                            return Positioned(
                              left: item.x,
                              top: item.y,
                              child: Draggable<CanvasItemModel>(
                                data: item,
                                feedback: Material(
                                  child: CanvasItem(item: item),
                                ),
                                childWhenDragging: Container(
                                  width: item.width,
                                  height: item.height,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onDragEnd: (details) {
                                  final RenderBox box =
                                      _canvasKey.currentContext
                                              ?.findRenderObject()
                                          as RenderBox;
                                  final Offset localPosition = box
                                      .globalToLocal(details.offset);
                                  final Matrix4 transform =
                                      _transformationController.value.clone();
                                  final double scale =
                                      transform.getMaxScaleOnAxis();

                                  setState(() {
                                    item.x =
                                        (localPosition.dx -
                                            transform.getTranslation().x) /
                                        scale;
                                    item.y =
                                        (localPosition.dy -
                                            transform.getTranslation().y) /
                                        scale;
                                    _updateCanvasItem(item);
                                    _saveCanvasItem(item); // Save after drag
                                  });
                                },
                                child: InkWell(
                                  onTap: () async {
                                    final updatedItem =
                                        await showDialog<CanvasItemModel>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return EditCanvasItemDialog(
                                              item: item,
                                            );
                                          },
                                        );
                                    if (updatedItem != null) {
                                      setState(() {
                                        item.content = updatedItem.content;
                                      });
                                      _updateCanvasItem(item);
                                      _saveCanvasItem(item); // Save after edit
                                    }
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Delete Canvas Item',
                                          ),
                                          content: const Text(
                                            'Are you sure you want to delete this item?',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        context,
                                                      ).pop(),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _deleteCanvasItem(item.id);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: CanvasItem(item: item),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.zoom_in),
                  onPressed: () {
                    setState(() {
                      _scale += 0.1;
                      _transformationController.value = Matrix4.diagonal3Values(
                        _scale,
                        _scale,
                        1.0,
                      ); // Update the matrix
                    });
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.zoom_out),
                  onPressed: () {
                    setState(() {
                      _scale -= 0.1;
                      if (_scale < 0.5) _scale = 0.5;
                      _transformationController.value = Matrix4.diagonal3Values(
                        _scale,
                        _scale,
                        1.0,
                      ); // Update the matrix
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Value Prop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Customer Seg',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Revenue',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.money_off), label: 'Cost'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Key Act'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Key Res'),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Key Part',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Channels'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Cust Rel'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              _addCanvasItem('Value Proposition');
              break;
            case 1:
              _addCanvasItem('Customer Segment');
              break;
            case 2:
              _addCanvasItem('Revenue Stream');
              break;
            case 3:
              _addCanvasItem('Cost Structure');
              break;
            case 4:
              _addCanvasItem('Key Activities');
              break;
            case 5:
              _addCanvasItem('Key Resources');
              break;
            case 6:
              _addCanvasItem('Key Partners');
              break;
            case 7:
              _addCanvasItem('Channels');
              break;
            case 8:
              _addCanvasItem('Customer Relationships');
              break;
          }
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
