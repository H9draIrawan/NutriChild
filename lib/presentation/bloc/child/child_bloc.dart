import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/domain/usecases/child/add_child.dart';
import 'package:nutrichild/domain/usecases/child/update_child.dart';
import 'package:nutrichild/domain/usecases/child/delete_child.dart';
import 'package:nutrichild/domain/usecases/child/get_child.dart';
import 'package:nutrichild/presentation/bloc/child/child_event.dart';
import 'package:nutrichild/presentation/bloc/child/child_state.dart';

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final AddChild _addChild;
  final UpdateChild _updateChild;
  final DeleteChild _deleteChild;
  final GetChild _getChild;

  ChildBloc({
    required AddChild addChild,
    required UpdateChild updateChild,
    required DeleteChild deleteChild,
    required GetChild getChild,
  })  : _addChild = addChild,
        _updateChild = updateChild,
        _deleteChild = deleteChild,
        _getChild = getChild,
        super(InitialChildState()) {
    on<AddChildEvent>(_onAddChild);
    on<UpdateChildEvent>(_onUpdateChild);
    on<DeleteChildEvent>(_onDeleteChild);
    on<GetChildEvent>(_onGetChild);
  }

  void _onGetChild(GetChildEvent event, Emitter<ChildState> emit) async {
    emit(LoadingChildState());
    final result = await _getChild.call();
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (children) => emit(GetChildState(children: children)));
  }

  void _onAddChild(AddChildEvent event, Emitter<ChildState> emit) async {
    emit(LoadingChildState());
    final result = await _addChild.call(event.child);
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (_) => emit(AddChildState()));
  }

  void _onUpdateChild(UpdateChildEvent event, Emitter<ChildState> emit) async {
    emit(LoadingChildState());
    final result = await _updateChild.call(event.child);
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (_) => emit(UpdateChildState()));
  }

  void _onDeleteChild(DeleteChildEvent event, Emitter<ChildState> emit) async {
    emit(LoadingChildState());
    final result = await _deleteChild.call(event.child);
    result.fold((failure) => emit(ErrorChildState(message: failure.toString())),
        (_) => emit(DeleteChildState()));
  }
}
