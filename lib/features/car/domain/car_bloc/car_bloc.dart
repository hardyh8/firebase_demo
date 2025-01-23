import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/get_it_instance.dart';
import '../../../../utils/logger.dart';
import '../../data/models/car_data.dart';
import '../../data/source/car_data_source.dart';

part 'car_event.dart';
part 'car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  late CarDataSource carDataSource;

  
  CarBloc() : super(CarInitial()) {
    carDataSource = getIt.get<CarDataSource>();
    on<GetCarData>(_onGetCarData);
    on<AddNewCarData>(_onAddNewCarData);
    on<UpdateCarData>(_onUpdateCarData);
    on<DeleteCarData>(_onDeleteCarData);
    on<OnPickFile>(_onPickFile);
  }

  Future<void> _onPickFile(OnPickFile event, Emitter<CarState> emit) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(FilePicked(File(pickedFile.path)));
    } else {
      emit(FilePicked(null));
    }
  }

  Future<void> _onGetCarData(GetCarData event, Emitter<CarState> emit) async {
    emit(OperationInProgress(0));
    try {
      final carList = await carDataSource.getCars();
      final imageUrls = await carDataSource.getAllCarImageUrls();
      emit(OperationSuccess(carList, imageUrls));
    } catch (e) {
      emit(OperationFailure(e.toString()));
    }
  }

  Future<void> _onAddNewCarData(
    AddNewCarData event,
    Emitter<CarState> emit,
  ) async {
    emit(OperationInProgress(0));
    final progressController = carDataSource.progressController;
    String imageUrl = '';
    try {
      if (event.imgFile != null) {
        final Completer<void> progressCompleter = Completer<void>();
        final subscription = progressController.stream.listen((progress) {
          emit(OperationInProgress(progress));
        }, onDone: () {
          progressCompleter.complete();
        }, onError: (error) {});

        imageUrl = await carDataSource.uploadImage(event.imgFile!);
        await progressCompleter.future;
        await subscription.cancel();
      }
      event.carData.imgUrl = imageUrl;
      await carDataSource.addCar(event.carData);
      final carList = await carDataSource.getCars();
      final imageUrls = await carDataSource.getAllCarImageUrls();
      emit(OperationSuccess(carList, imageUrls));
    } catch (e) {
      emit(OperationFailure(e.toString()));
    }
  }

  Future<void> _onUpdateCarData(
      UpdateCarData event, Emitter<CarState> emit) async {
    emit(OperationInProgress(0));
    try {
      if (event.imgFile != null) {
        String imageUrl = await carDataSource.uploadImage(event.imgFile!);
        emit(OperationInProgress(0.5));
        event.carData.imgUrl = imageUrl;
      }

      await carDataSource.updateCar(event.carData);
      final carList = await carDataSource.getCars();
      final imageUrls = await carDataSource.getAllCarImageUrls();

      emit(OperationSuccess(carList, imageUrls));
    } catch (e) {
      logger.d('updateCar fails : ${e.toString()}');
      emit(OperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteCarData(
      DeleteCarData event, Emitter<CarState> emit) async {
    emit(OperationInProgress(0));
    try {
      await carDataSource.deleteCar(event.carId);
      final carList = await carDataSource.getCars();
      final imageUrls = await carDataSource.getAllCarImageUrls();
      emit(OperationSuccess(carList, imageUrls));
    } catch (e) {
      emit(OperationFailure(e.toString()));
    }
  }
}
