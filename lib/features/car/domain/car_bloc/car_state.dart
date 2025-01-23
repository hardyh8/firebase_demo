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
  final List<String> networkImageUrls;

  OperationSuccess(
    this.carList,
    this.networkImageUrls,
  );

  @override
  List<Object?> get props => [
        carList,
        networkImageUrls,
      ];
}

class OperationFailure extends CarState {
  final String error;

  OperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class FilePicked extends CarState {
  final File? file;

  FilePicked(this.file);

  @override
  List<Object?> get props => [file];
}
