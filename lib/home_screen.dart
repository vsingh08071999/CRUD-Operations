import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations/bloc.dart';
import 'package:crud_operations/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _taskController = TextEditingController();
  List<bool> _checkList = [];
  bool _isLoad = false;
  List<String> localList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init called");
    getData();
  }

  getData() async {
    localList = await context.read<CrudBloc>().getTitleList();
    _checkList = List<bool>.filled(localList.length, false, growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD OPERATIONS")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: "Task Name",
              ),
              onSubmitted: (value) async {
                if (value != "") {
                  setState(() {
                    _isLoad = true;
                  });
                  await context.read<CrudBloc>().updateTitleList(value);
                  _checkList.add(false);
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
                              return CheckboxListTile(
                                title: Text(
                                    state.titleList!.reversed.toList()[index]),
                                value: _checkList[index],
                                selectedTileColor: _checkList[index]
                                    ? Colors.grey
                                    : Colors.transparent,
                                selected: true,
                                onChanged: (val) {
                                  _checkList[index] = val!;
                                  setState(() {});
                                },
                              );
                            });

                //  Column(
                //     children: state.titleList!.map((e) {
                //       return CheckboxListTile(
                //         title: Text(e.toString()),
                //         value: _isChecked,
                //         onChanged: (val) {
                //           print("index value is ${_isChecked.toString()}");
                //           // _isChecked[index] = val!;
                //           print("after value is ${_isChecked.toString()}");
                //           setState(() {});
                //         },
                //       );
                //     }).toList(),
                //   );
              })),
            )
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.9,
            //   child: StreamBuilder(
            //     stream:
            //         FirebaseFirestore.instance.collection("daat").snapshots(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<QuerySnapshot> snapshot) {
            //       // print("stream data is ${snapshot.data!.docs.length}");
            //       // _isChecked =
            //       //     List<bool>.filled(snapshot.data!.docs.length, false);
            //       if (snapshot.hasError) {
            //         return const Text('Something went wrong');
            //       }

            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Center(child: const Text("Loading"));
            //       }
            //       return ListView.builder(
            //         itemCount: snapshot.data!.docs.length,
            //         itemBuilder: (context, index) {
            //           Map<String, dynamic> data = snapshot.data!.docs[index]
            //               .data() as Map<String, dynamic>;

            //           // print("data   ${data}");
            //           return CheckboxListTile(
            //             title: Text(data['data'].toString()),
            //             value: _isChecked,
            //             onChanged: (val) {
            //               print("index value is ${_isChecked.toString()}");
            //               // _isChecked[index] = val!;
            //               print("after value is ${_isChecked.toString()}");
            //               setState(() {});
            //             },
            //           );

            //           //  RaisedButton(
            //           //   onPressed: () async {
            //           //     await deleteProduct(snapshot.data!.docs[index]);
            //           //   },
            //           //   child: Text("Task is ${data['data']}"),
            //           // );
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
