import 'package:crud_operations/firebase_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrudBloc extends Bloc<CrudBlocEvent, CrudBlocState> {
  CrudBloc() : super(CrudBlocState.initial());
  List<String> _titleList = [];

  @override
  Stream<CrudBlocState> mapEventToState(CrudBlocEvent event) async* {
    switch (event) {
      case CrudBlocEvent.setUpdate:
        yield state.copyWith(titleList: _titleList);
        break;
    }
  }

  updateTitleList(String item) async {
    _titleList.add(item);
    await FirebaseServices().uploadingData(item);
    add(CrudBlocEvent.setUpdate);
  }

  Future<List<String>> getTitleList() async {
    _titleList = await FirebaseServices().getData();
    add(CrudBlocEvent.setUpdate);
    return _titleList;
  }
}

class CrudBlocState {
  List<String>? titleList = [];
  CrudBlocState({this.titleList});
  factory CrudBlocState.initial() {
    return CrudBlocState(titleList: []);
  }
  CrudBlocState copyWith({List<String>? titleList}) {
    return CrudBlocState(titleList: titleList ?? this.titleList);
  }
}

enum CrudBlocEvent { setUpdate }
