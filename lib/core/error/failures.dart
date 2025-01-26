import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [properties];
}

// General Failures
class ServerFailure extends Failure {
  final String message;
  
  const ServerFailure({this.message = 'Terjadi kesalahan pada server'});
  
  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  final String message;
  
  const CacheFailure({this.message = 'Terjadi kesalahan pada cache'});
  
  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;
  
  const NetworkFailure({this.message = 'Tidak ada koneksi internet'});
  
  @override
  List<Object?> get props => [message];
}

class UnexpectedFailure extends Failure {
  final String message;
  
  const UnexpectedFailure({this.message = 'Terjadi kesalahan yang tidak terduga'});
  
  @override
  List<Object?> get props => [message];
}
