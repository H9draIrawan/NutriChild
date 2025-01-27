import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/domain/usecases/children/add_child.dart';
import 'package:nutrichild/domain/usecases/children/update_child.dart';
import 'package:nutrichild/domain/usecases/children/delete_child.dart';
import 'package:nutrichild/presentation/bloc/child/child_event.dart';
import 'package:nutrichild/presentation/bloc/child/child_state.dart';

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final AddChild _addChild;
  final UpdateChild _updateChild;
  final DeleteChild _deleteChild;

  ChildBloc({
    required AddChild addChild,
    required UpdateChild updateChild,
    required DeleteChild deleteChild,
  })  : _addChild = addChild,
        _updateChild = updateChild,
        _deleteChild = deleteChild,
        super(InitialChildState()) {
    on<AddChildEvent>(_onAddChild);
    on<UpdateChildEvent>(_onUpdateChild);
    on<DeleteChildEvent>(_onDeleteChild);
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
