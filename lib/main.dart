import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_filters/widget/filtered_image_widget.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:image/image.dart' as img;
import 'package:photofilters/filters/preset_filters.dart';

import 'filter_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  img.Image? image;
  Filter filter = presetFiltersList.first;
  int i = 0 ;
  String name = "name";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${name}"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: pickImage,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                filter = presetFiltersList[3];
              });
            },
          ),
        ],
      ),
      body: buildImage(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            if(i==43) i=0;
            filter = presetFiltersList[i++];
            name = filter.name;
          });
        },
        child: Text("${i}"),
      ),
    );
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imageBytes = File(image?.path??"").readAsBytesSync();

    final newImage = img.decodeImage(imageBytes);
    FilterUtils.clearCache();

    setState(() {
      this.image = newImage;
    });
  }

  Widget buildImage() {
    const double height = 450;
    if (image == null) return Container();

    return FilteredImageWidget(
      filter: filter,
      image: image!,
      successBuilder: (imageBytes) =>
          Image.memory(imageBytes as Uint8List, height: height, fit: BoxFit.fitHeight),
      errorBuilder: () => Container(),
    );
  }
}

