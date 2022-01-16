import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class GridMakerDemo extends StatefulWidget {
  GridMakerDemo(this._croppedData, this.square, {Key? key}) : super(key: key);
  Uint8List? _croppedData;
  var square;

  @override
  _GridMakerDemoState createState() => _GridMakerDemoState();
}

class _GridMakerDemoState extends State<GridMakerDemo> {
  bool gridCount = false;
  File? filepath;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            children: (widget.square == 3 / 3)
                ? splitImage(widget._croppedData!, 3, 3)
                : (widget.square == 3 / 2)
                    ? splitImage(widget._croppedData!, 3, 2)
                    : (widget.square == 3 / 4)
                        ? splitImage(widget._croppedData!, 3, 4)
                        : splitImage(widget._croppedData!, 3, 5),
          ),
          Container(
            height: 30,
            width: 30,
            color: Colors.red,
            child: Text('1'),
          )
        ],
      ),
    ));
  }

  List<Widget> splitImage(List<int> input, int column, int row) {
    imglib.Image? image = imglib.decodeImage(widget._croppedData!);
    int x = 1, y = 0;

    int width = (image!.width / column).round();
    int height = (image.height / row).round();

    List<imglib.Image> parts = <imglib.Image>[];
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }
    List<Widget> output = <Widget>[];

    for (var img in parts) {
      output.add(GestureDetector(
          onTap: () {
            savingFile(img);
            shareImage();
            gridCount = true;
            setState(() {});
          },
          child: Image.memory(Uint8List.fromList(imglib.encodeJpg(img)))));
    }
    return output;
  }

  List gridCountList = ['1,', '2', '3', '4', '5'];

  ///Saving file locally
  Future<void> savingFile(imglib.Image img) async {
    var imagePath = imglib.encodeJpg(img);
    final external = (await getApplicationDocumentsDirectory()).path +
        '/${TimeOfDay.now().toString()}.png';
    try {
      final file = File(external);
      filepath = await file.writeAsBytes(imagePath);
    } catch (error) {
      print('///// ERROR: $error');
    }
  }

  ///Share image
  Future<void> shareImage() async {
    final RenderObject? box = context.findRenderObject();
    Share.shareFiles(
      [filepath!.path],
      subject: "this is subject",
      // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
    );
  }
}