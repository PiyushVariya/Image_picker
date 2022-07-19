
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({Key? key}) : super(key: key);

  @override
  State<ImagePickerDemo> createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker Example"),
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
                color: Colors.blue,
                child: const Text("Pick Images from Gallery",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold)),
                onPressed: () {
                  selectImages();
                }),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: imageFileList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(File(imageFileList![index].path),
                        fit: BoxFit.cover);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImageVideoPickerDemo extends StatefulWidget {
  const ImageVideoPickerDemo({Key? key}) : super(key: key);

  @override
  _ImageVideoPickerDemoState createState() => _ImageVideoPickerDemoState();
}

class _ImageVideoPickerDemoState extends State<ImageVideoPickerDemo> {
  File? _image;
  File? _cameraImage;
  File? _video;
  File? _cameraVideo;

  ImagePicker picker = ImagePicker();

  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? _cameraVideoPlayerController;

  /// This function will helps you to pick and Image from Gallery
  _pickImageFromGallery() async {
    PickedFile? pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    File image = File(pickedFile!.path);

    setState(() {
      _image = image;
    });
  }

  /// This function will helps you to pick and Image from Camera
  _pickImageFromCamera() async {
    PickedFile? pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    File image = File(pickedFile!.path);

    setState(() {
      _cameraImage = image;
    });
  }

  /// This function will helps you to pick a Video File
  _pickVideo() async {
    PickedFile? pickedFile = await picker.getVideo(source: ImageSource.gallery);

    _video = File(pickedFile!.path);

    _videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController?.play();
      });
  }

  /// This function will helps you to pick a Video File from Camera
  _pickVideoFromCamera() async {
    PickedFile? pickedFile = await picker.getVideo(source: ImageSource.camera);

    _cameraVideo = File(pickedFile!.path);

    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo!)
      ..initialize().then((_) {
        setState(() {});
        _cameraVideoPlayerController!.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image / Video Picker"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                if (_image != null)
                  Image.file(_image!)
                else
                  const Text(
                    "Click on Pick Image to select an Image",
                    style: TextStyle(fontSize: 18.0),
                  ),
                OutlinedButton(
                  onPressed: () {
                    _pickImageFromGallery();
                  },
                  child: const Text("Pick Image From Gallery"),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                if (_cameraImage != null)
                  Image.file(_cameraImage!)
                else
                  const Text(
                    "Click on Pick Image to select an Image",
                    style: TextStyle(fontSize: 18.0),
                  ),
                OutlinedButton(
                  onPressed: () {
                    _pickImageFromCamera();
                  },
                  child: const Text("Pick Image From Camera"),
                ),
                if (_video != null)
                  _videoPlayerController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController!),
                        )
                      : Container()
                else
                  const Text(
                    "Click on Pick Video to select video",
                    style: TextStyle(fontSize: 18.0),
                  ),
                OutlinedButton(
                  onPressed: () {
                    _pickVideo();
                  },
                  child: const Text("Pick Video From Gallery"),
                ),
                if (_cameraVideo != null)
                  _cameraVideoPlayerController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio:
                              _cameraVideoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_cameraVideoPlayerController!),
                        )
                      : Container()
                else
                  const Text(
                    "Click on Pick Video to select video",
                    style: TextStyle(fontSize: 18.0),
                  ),
                OutlinedButton(
                  onPressed: () {
                    _pickVideoFromCamera();
                  },
                  child: const Text("Pick Video From Camera"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
