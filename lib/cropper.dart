import 'dart:io';
import 'dart:typed_data';

import 'package:crop_image/grid%20screen.dart';
import 'package:crop_image/grid_screen_Demo.dart';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropSample extends StatefulWidget {
  CropSample(this.imageFile, {Key? key}) : super(key: key);
  File? imageFile;

  @override
  _CropSampleState createState() => _CropSampleState();
}

class _CropSampleState extends State<CropSample> {
  final _cropController = CropController();

  var square;
  final _loadingImage = false;
  var _isCropping = false;
  var _isCircleUi = false;
  Uint8List? _croppedData;
  final _statusText = '';

  @override
  void initState() {
    // _loadAllImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Visibility(
                visible: !_loadingImage && !_isCropping,
                child: Column(
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: _croppedData == null,
                        child: Stack(
                          children: [
                            if (widget.imageFile != null)
                              Crop(
                                controller: _cropController,
                                image: widget.imageFile!.readAsBytesSync(),
                                onCropped: (croppedData) {
                                  setState(() {
                                    _croppedData = croppedData;
                                    _isCropping = false;
                                  });
                                },
                                initialSize: 0.8,
                              ),
                            // Positioned(
                            //   right: 16,
                            //   bottom: 16,
                            //   child: GestureDetector(
                            //     onTapDown: (_) =>
                            //         setState(() => _isSumbnail = true),
                            //     onTapUp: (_) => setState(() => _isSumbnail = false),
                            //     child: CircleAvatar(
                            //       backgroundColor: _isSumbnail
                            //           ? Colors.blue.shade50
                            //           : Colors.blue,
                            //       child: const Center(
                            //         child: Icon(Icons.crop_free_rounded),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        replacement: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: _croppedData == null
                                      ? SizedBox.shrink()
                                      : Image.memory(_croppedData!),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          _clearImage();
                                        },
                                        child: Text("Crop Again")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GridMaker(
                                                        _croppedData!, square),
                                              ));
                                        },
                                        child: Text("Make Grid"))
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    if (_croppedData == null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController.aspectRatio = 3 / 5;
                                    square = 3 / 5;
                                  },
                                  child: const Text("3:5"),
                                ),
                                TextButton(
                                  child: const Text("3:4"),
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController.aspectRatio = 3 / 4;
                                    square = 3 / 4;
                                  },
                                ),
                                TextButton(
                                  child: const Text('3:2'),
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController.aspectRatio = 3 / 2;
                                    square = 3 / 2;
                                  },
                                ),
                                TextButton(
                                  child: const Text("3:3"),
                                  onPressed: () {
                                    _isCircleUi = false;
                                    _cropController
                                      ..withCircleUi = false
                                      ..aspectRatio = 3 / 3;
                                    square = 3 / 3;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isCropping = true;
                                  });
                                  _isCircleUi
                                      ? _cropController.cropCircle()
                                      : _cropController.crop();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Text('CROP IT!'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                  ],
                ),
                replacement: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearImage() {
    _croppedData = null;
    setState(() {});
  }
}
