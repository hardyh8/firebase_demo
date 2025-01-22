part of 'car_bloc.dart';

abstract class CarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState {}

class OperationInProgress extends CarState {
  final double progress;

  OperationInProgress(this.progress);
}

class OperationSuccess extends CarState {
  final List<CarData> carList;

  OperationSuccess(
    this.carList,
  );

  @override
  List<Object?> get props => [
        carList,
      ];
}

class OperationFailure extends CarState {
  final String error;

  OperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
