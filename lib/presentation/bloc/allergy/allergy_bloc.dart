import 'package:bloc/bloc.dart';
import 'package:nutrichild/domain/usecases/allergy/init_allergy.dart';
import 'package:nutrichild/domain/usecases/allergy/get_allergy.dart';
import 'package:nutrichild/presentation/bloc/allergy/allergy_event.dart';
import 'package:nutrichild/presentation/bloc/allergy/allergy_state.dart';

class AllergyBloc extends Bloc<AllergyEvent, AllergyState> {
  final InitAllergy _initAllergy;
  final GetAllergy _getAllergy;

  AllergyBloc({
    required InitAllergy initAllergy,
    required GetAllergy getAllergy,
  })  : _initAllergy = initAllergy,
        _getAllergy = getAllergy,
        super(InitialAllergyState()) {
    on<InitAllergyEvent>(_onInitAllergy);
    on<GetAllergyEvent>(_onGetAllergy);
  }

  Future<void> _onInitAllergy(event, emit) async {
    emit(LoadingAllergyState());
    final result = await _initAllergy.call();
    result.fold((failure) => emit(ErrorAllergyState(failure.toString())),
        (_) => emit(InitialAllergyState()));
  }

  Future<void> _onGetAllergy(event, emit) async {
    emit(LoadingAllergyState());
    final result = await _getAllergy.call(event.id);
    result.fold((failure) => emit(ErrorAllergyState(failure.toString())),
        (_) => emit(GetAllergyState()));
  }
}
