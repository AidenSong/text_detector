import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';





class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
  ImagePicker _imagePicker = ImagePicker() ;
  final _cameraLensDirection = CameraLensDirection.back;
  var _script = TextRecognitionScript.korean;

  File? _image;
  bool _canProcess = true;
  bool _isBusy = false;
  String _text = "";
  CustomPaint? _customPaint;




  @override
  void dispose() {
    _canProcess = false;
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    TextRecognitionScript.values.map((e) => log("$e\n"));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: buildGalleryView(),
    );
  }

  Widget buildGalleryView() => Column(
    children: [
      DropdownButton(
        value: _script,
        items: TextRecognitionScript.values
            .map((e) {
              log("e.name = ${e.name}");
              return DropdownMenuItem(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
        onChanged: (script) {
          log("script = $script");
          setState(() {
            if (script != null) {
              _script = script;
              textRecognizer.close();
              textRecognizer = TextRecognizer(script: _script);
            }
          });
        },
      ),

      _image != null
          ? SizedBox(
              height: 320,
              width: 320,
        child: Image.file(_image!),
            )
          : Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
            ),

      ElevatedButton(
        onPressed: () =>_getImage(ImageSource.gallery),
        child: Text("갤러리 이미지 가져오기"),
      )
    ],
  );

  Future _getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    setState(() {_image = null;});

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }

  }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });

    final inputImage = InputImage.fromFilePath(path);
    _processImage(inputImage);
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = "";
    });

    final RecognizedText = await textRecognizer.processImage(inputImage);

    if (inputImage.metadata?.size != null
    && inputImage.metadata?.rotation != null) {

    } else {
      // 갤러리에서 가져온 값 처리
      _text = "Recognized Text : ${RecognizedText.text}\n\n";
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

}
