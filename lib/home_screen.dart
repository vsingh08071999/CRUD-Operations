import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations/bloc.dart';
import 'package:crud_operations/detail_dialogbox.dart';
import 'package:crud_operations/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _taskController = TextEditingController();
  List<bool> _checkList = [];
  bool _isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init called");
    getData();
  }

  getData() async {
    await context.read<CrudBloc>().getTitleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD OPERATIONS"), actions: [
        IconButton(
            onPressed: () async {
              getData();
            },
            icon: Icon(Icons.restore))
      ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: "Task Name",
              ),
              onSubmitted: (value) async {
                if (value != "") {
                  setState(() {
                    _isLoad = true;
                  });
                  var rng = new Random();
                  var code = rng.nextInt(900000) + 100000;
                  String docId = value.substring(0, 4).trim() + code.toString();
                  print("random no is ${docId}");
                  await context.read<CrudBloc>().addTitleList(TaskModel(
                      creationDate: DateTime.now().toString(),
                      docID: docId.toString(),
                      title: value,
                      description: "",
                      imageUrl: ""));
                  setState(() {
                    _isLoad = false;
                  });
                }
                _taskController.clear();
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: BlocBuilder<CrudBloc, CrudBlocState>(
                  builder: ((context, state) {
                return state.titleList!.isEmpty
                    ? Center(child: const Text("There is no item"))
                    : _isLoad
                        ? Center(child: const Text("Updating..."))
                        : ListView.builder(
                            itemCount: state.titleList!.reversed.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: ObjectKey(
                                    state.titleList!.reversed.toList()[index]),
                                onDismissed: (DismissDirection direction) {
                                  switch (direction) {
                                    case DismissDirection.endToStart:
                                      Fluttertoast.showToast(
                                          msg: "Swipe right to delete");
                                      break;
                                    case DismissDirection.startToEnd:
                                      Fluttertoast.showToast(
                                          msg: "Swipe left to download");

                                      break;
                                    default:
                                      break;
                                  }
                                },
                                background: Container(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.green,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: const Icon(
                                      Icons.archive_sharp,
                                      color: Colors.white,
                                      size: 25,
                                    )),
                                secondaryBackground: Container(
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.red,
                                    child: const Icon(Icons.delete_forever,
                                        color: Colors.white, size: 25)),
                                child: ListTile(
                                  title: Text(state.titleList!.reversed
                                      .toList()[index]
                                      .title
                                      .toString()),
                                  subtitle: Text(DateFormat("dd-MM-yyyy")
                                          .format(DateTime.parse(state
                                              .titleList!.reversed
                                              .toList()[index]
                                              .creationDate
                                              .toString())) +
                                      "   " +
                                      DateFormat("hh:mm a").format(
                                          DateTime.parse(state
                                              .titleList!.reversed
                                              .toList()[index]
                                              .creationDate
                                              .toString()))),
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) => DetailDialogBox(
                                              model: state.titleList!.reversed
                                                  .toList()[index],
                                            ));
                                  },
                                ),
                              );
                            });
              })),
            )
          ],
        ),
      ),
    );
  }
}
