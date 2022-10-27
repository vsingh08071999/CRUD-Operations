import 'package:crud_operations/firebase_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model.dart';

class CrudBloc extends Bloc<CrudBlocEvent, CrudBlocState> {
  CrudBloc() : super(CrudBlocState.initial());
  List<TaskModel> _titleList = [];

  @override
  Stream<CrudBlocState> mapEventToState(CrudBlocEvent event) async* {
    switch (event) {
      case CrudBlocEvent.setUpdate:
        yield state.copyWith(titleList: _titleList);
        break;
    }
  }

  addTitleList(TaskModel item) async {
    _titleList.add(item);
    await FirebaseServices().uploadingData(item);
    add(CrudBlocEvent.setUpdate);
  }

  updateTitleList(TaskModel item) async {
    // _titleList.firstWhere((element) => element.docID == item.docID) = item;
    _titleList[
        _titleList.indexWhere((element) => element.docID == item.docID)] = item;
    print(
        "after update ${_titleList[_titleList.indexWhere((element) => element.docID == item.docID)].toJson()}");
    await FirebaseServices().uploadingData(item);
    add(CrudBlocEvent.setUpdate);
  }

  Future<List<TaskModel>> getTitleList() async {
    _titleList = await FirebaseServices().getData();
    add(CrudBlocEvent.setUpdate);
    return _titleList;
  }
}

class CrudBlocState {
  List<TaskModel>? titleList = [];
  CrudBlocState({this.titleList});
  factory CrudBlocState.initial() {
    return CrudBlocState(titleList: []);
  }
  CrudBlocState copyWith({List<TaskModel>? titleList}) {
    return CrudBlocState(titleList: titleList ?? this.titleList);
  }
}

enum CrudBlocEvent { setUpdate }
