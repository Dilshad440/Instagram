import 'dart:io';

import 'package:crop_image/cropper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStorgePermission();
  }

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 8;
    var width = MediaQuery.of(context).size.height / 8;
    return Scaffold(
      backgroundColor: Colors.accents[1].shade100,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.accents[1].shade100,
        leading: Icon(Icons.share),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () {
                  imageOption(context);
                },
                child: gridRow(height, width, "Grid Maker",
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiTKwz1crfnN02bdanB0LnOiYKPS08k6yah01PfnTwP5OkhyzbH93D456tCmWnWUX1AtQ&usqp=CAU')),
            InkWell(
                child: gridRow(height, width, 'Profile Viewer',
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_xap6GbjH3v7-lDkmv_bOAsrryGTIW25blQ&usqp=CAU')),
            InkWell(
                child: gridRow(height, width, "Download Reels",
                    'https://icon-library.com/images/crop-icon/crop-icon-4.jpg'))
          ],
        ),
      ),
    );
  }

  ///Storage Permission
  Future<void> getStorgePermission() async {
    final serviceStatus = await Permission.storage.isGranted;
    bool isStorage = serviceStatus == ServiceStatus.enabled;
    final storageStatus = await Permission.storage.request();
    if (storageStatus == PermissionStatus.granted) {
      print("Storage permission granted");
    } else if (storageStatus == PermissionStatus.denied) {
      print("Storage permission denied");
      showToast("Storage Permission is required");
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      showToast("Storage Permission is required");
      print("Storage permission permanently denied");
    }
  }
  Future<void> reqCameraPermision() async {
    final serviceStatus = await Permission.camera.isGranted;
    bool isCameraOn = serviceStatus == ServiceStatus.enabled;
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      imageOption(context);
      print("permission granted");
    } else if (status == PermissionStatus.denied) {
      showToast("Camera Permission is required");
      print("permission denied");
    } else if (status == PermissionStatus.permanentlyDenied) {
      showToast("Camera Permission is required");
      print('permanent denied');
      await openAppSettings();
    }
  }

  Widget gridRow(double height, double width, String text, final img) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red, Colors.grey, Colors.blue],
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            img,
            height: 50,
            width: 80,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 16.0,
      backgroundColor: Colors.transparent,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
    );
  }

  Future<dynamic> imageOption(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            children: [
              ListTile(
                title: Text("Browse from Gallery"),
                trailing: Icon(Icons.photo_album),
                onTap: () {
                  _pickGalleryImage();
                  Navigator.pop(context, true);
                },
              ),
              ListTile(
                title: Text("Take a Picture"),
                trailing: Icon(Icons.photo_camera),
                onTap: () {
                  _pickCameraImage();
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickGalleryImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    setState(() {});
    if (imageFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropSample(imageFile),
          ));
    }
  }

  Future<void> _pickCameraImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    setState(() {});
    if (imageFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropSample(imageFile),
          ));
    }
  }
}
