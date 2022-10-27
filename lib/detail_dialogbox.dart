import 'dart:io';

import 'package:crud_operations/bloc.dart';
import 'package:crud_operations/firebase_services.dart';
import 'package:crud_operations/model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailDialogBox extends StatefulWidget {
  TaskModel? model;
  DetailDialogBox({this.model});

  @override
  State<DetailDialogBox> createState() => _DetailDialogBoxState();
}

class _DetailDialogBoxState extends State<DetailDialogBox> {
  TextEditingController _descriptionController = TextEditingController();
  File? imageFile;
  String? url;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model!.description != "") {
      _descriptionController.text = widget.model!.description!;
    }
    if (widget.model!.imageUrl != "") {
      url = widget.model!.imageUrl!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.model!.title.toString()),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close))
      ]),
      titlePadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
      children: [
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "Description...",
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                            ),
                          ),
                        ),
                        url != null
                            ? SizedBox()
                            : Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        getImage(ImageSource.camera);
                                      },
                                      icon: Icon(Icons.camera_alt)),
                                  IconButton(
                                      onPressed: () {
                                        getImage(ImageSource.gallery);
                                      },
                                      icon: Icon(Icons.image))
                                ],
                              )
                      ],
                    ),
                    url != null
                        ? Container(
                            padding: EdgeInsets.all(5),
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Image.network(
                              url!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : imageFile == null
                            ? SizedBox()
                            : Container(
                                padding: EdgeInsets.all(5),
                                height: 80,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    url != null
                        ? SizedBox()
                        : Container(
                            child: RaisedButton(
                            onPressed: () async {
                              await submitFuntion();
                            },
                            child: const Text("Submit",
                                style: TextStyle(color: Colors.white)),
                            color: Colors.blue,
                          ))
                  ],
                ),
              ),
      ],
    );
  }

  getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    PickedFile? pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
    }
  }

  submitFuntion() async {
    setState(() {
      isLoading = true;
    });
    widget.model!.description = _descriptionController.text;
    if (imageFile != null) {
      String url = await FirebaseServices()
          .uploadingImageDataToFirebaseStorage(imageFile, widget.model!.title!);
      widget.model!.imageUrl = url;
    }
    await context.read<CrudBloc>().updateTitleList(widget.model!);
    Fluttertoast.showToast(msg: "Sumit Successfully");
    setState(() {
      isLoading = false;
    });
  }
}
