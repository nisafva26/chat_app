import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

  class Imagepicker extends StatefulWidget {

    Imagepicker(this.imagepickfn);

    final void Function(File pickedimage) imagepickfn;
    @override
    _ImagepickerState createState() => _ImagepickerState();
  }

  class _ImagepickerState extends State<Imagepicker> {

    File _image;
    final picker = ImagePicker();

    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 150);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
      widget.imagepickfn(_image);
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage:_image!=null? FileImage(_image) : null,
            radius: 40,
          ),
          FlatButton.icon(onPressed: getImage,
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.image),
              label: Text('add image')),
        ],
      );
    }
  }
