part of 'car_bloc.dart';

abstract class CarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCarData extends CarEvent {}

class AddNewCarData extends CarEvent {
  final CarData carData;
  final File? imgFile;

  AddNewCarData(this.carData, this.imgFile);

  @override
  List<Object?> get props => [carData, imgFile];
}

class UpdateCarData extends CarEvent {
  final CarData carData;
  final File? imgFile;

  UpdateCarData(this.carData, this.imgFile);

  @override
  List<Object?> get props => [carData, imgFile];
}

class DeleteCarData extends CarEvent {
  final String carId;

  DeleteCarData(this.carId);

  @override
  List<Object?> get props => [carId];
}

class OnPickFile extends CarEvent {
  OnPickFile();

  @override
  List<Object?> get props => [];
}
