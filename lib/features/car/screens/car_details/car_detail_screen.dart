import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../routing/router_helper.dart';
import '../../../../utils/widgets/custom_snackbar.dart';
import '../../data/models/car_data.dart';
import '../../domain/car_bloc/car_bloc.dart';
import 'widgets/car_details.dart';
import 'widgets/car_form.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({
    super.key,
    this.car,
    required this.isEdit,
  });
  final CarData? car;
  final bool isEdit;

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  bool editingForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<CarBloc, CarState>(
          listener: (context, state) {
            if (state is OperationSuccess) {
              RouterHelper.pop<void>(context);
            }
            if (state is OperationFailure) {
              CustomSnackbar.showSnackbar(
                context: context,
                message: 'Failed ${state.error}',
                type: SnackbarType.error,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.isEdit && !editingForm
                ? CarDetails(car: widget.car!)
                : CarForm(
                    initialData: widget.car,
                    onSave: _onSave,
                  ),
          ),
        ),
      ),
      floatingActionButton: editingForm
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  editingForm = !editingForm;
                });
              },
              child: const Icon(Icons.edit),
            ),
    );
  }

  void _onSave({
    required String? id,
    required String? imageUrl,
    required bool hasPurchased,
    required File? image,
    required String modelName,
    required int modelNo,
    required double price,
  }) async {
    CarData data = CarData(
      id: id ?? '',
      modelName: modelName,
      modelNo: modelNo,
      price: price,
      hasPurchased: hasPurchased,
      imgUrl: imageUrl ?? '',
    );
    if (widget.isEdit) {
      context.read<CarBloc>().add(UpdateCarData(data, image));
    } else {
      context.read<CarBloc>().add(AddNewCarData(data, image));
    }
  }
}
