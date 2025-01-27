import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/domain/usecases/child/add_child.dart';
import 'package:nutrichild/domain/usecases/child/update_child.dart';
import 'package:nutrichild/domain/usecases/child/delete_child.dart';
import 'package:nutrichild/domain/usecases/child/get_child.dart';
import 'package:nutrichild/presentation/bloc/child/child_event.dart';
import 'package:nutrichild/presentation/bloc/child/child_state.dart';

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final GetChild _getChild;
  final AddChild _addChild;
  final UpdateChild _updateChild;
  final DeleteChild _deleteChild;

  ChildBloc({
    required GetChild getChild,
    required AddChild addChild,
    required UpdateChild updateChild,
    required DeleteChild deleteChild,
  })  : _getChild = getChild,
        _addChild = addChild,
        _updateChild = updateChild,
        _deleteChild = deleteChild,
        super(InitialChildState()) {
    on<GetChildEvent>(_onGetChild);
    on<AddChildEvent>(_onAddChild);
    on<UpdateChildEvent>(_onUpdateChild);
    on<DeleteChildEvent>(_onDeleteChild);
  }

  void _onGetChild(event, emit) async {
    emit(LoadingChildState());
    final result = await _getChild.call(event.id);
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (children) => emit(GetChildState(children: children)));
  }

  void _onAddChild(event, emit) async {
    emit(LoadingChildState());
    final result = await _addChild.call(event.child);
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (_) => emit(AddChildState()));
  }

  void _onUpdateChild(event, emit) async {
    emit(LoadingChildState());
    final result = await _updateChild.call(event.child);
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (_) => emit(UpdateChildState()));
  }

  void _onDeleteChild(event, emit) async {
    emit(LoadingChildState());
    final result = await _deleteChild.call(event.child);
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (_) => emit(DeleteChildState()));
  }
}
