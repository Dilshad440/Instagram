import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class GridMaker extends StatefulWidget {
  GridMaker(this._croppedData, this.square, {Key? key}) : super(key: key);
  Uint8List? _croppedData;
  var square;

  @override
  _GridMakerState createState() => _GridMakerState();
}

class _GridMakerState extends State<GridMaker> {
  File? filepath;
  bool isChecked = true;
  var img;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   splitedGrid();
    // savingFile(img);
  }

  void splitedGrid(){
    (widget.square == 3 / 3)
        ? splitImage(widget._croppedData!, 3, 3)
        : (widget.square == 3 / 2)
        ? splitImage(widget._croppedData!, 3, 2)
        : (widget.square == 3 / 4)
        ? splitImage(widget._croppedData!, 3, 4)
        : splitImage(widget._croppedData!, 3, 5);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GridView.builder(
                itemCount: output.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        shareImage();
                        // savingFile();
                      },
                      child: Stack(
                        children: [
                          Image.memory(output[index]),
                          Center(
                            child: Container(
                                height: 25,
                                width: 25,
                                color: Colors.white38,
                                child: Center(child: Text(index.toString()))),
                          )
                        ],
                      ));
                },
              ),
            ],
          ),
        ));
  }

  List<Uint8List> output = <Uint8List>[];
  List<Uint8List> splitImage(List<int> input, int column, int row) {
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
    for (img in parts) {
      output.add(Uint8List.fromList(imglib.encodeJpg(img)));
    }
    savingFile();
    return output;
  }
  ///Saving file locally
  Future<void> savingFile() async {
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
