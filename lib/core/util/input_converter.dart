import 'package:clear_structure/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {

  }
}

class InvalidInputFailure extends Failure {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}