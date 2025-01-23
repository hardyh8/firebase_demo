import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../config/app_colors.dart';
import '../../../../../utils/widgets/buttons/primary_btn.dart';
import '../../../../../utils/widgets/inputs/input_field_1.dart';
import '../../../../../utils/widgets/progress_bar.dart';
import '../../../data/models/car_data.dart';
import '../../../domain/car_bloc/car_bloc.dart';
import 'network_image_sheet.dart';

class CarForm extends StatefulWidget {
  const CarForm({
    super.key,
    this.onSave,
    this.initialData,
  });
  final CarData? initialData;

  final void Function({
    required String? id,
    required String? imageUrl,
    required String modelName,
    required int modelNo,
    required double price,
    required File? image,
    required bool hasPurchased,
  })? onSave;

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController modelController = TextEditingController();
  final TextEditingController modelNoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? _pickedImage;
  bool _hasPurchased = false;

  final ImagePicker _picker = ImagePicker();
  String selectedNetworkUrl = '';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.onSave != null) {
        widget.onSave!(
          imageUrl: _pickedImage != null ? '' : widget.initialData?.imgUrl,
          id: widget.initialData?.id,
          modelName: modelController.text.trim(),
          modelNo: int.tryParse(modelNoController.text.trim()) ?? 0,
          price: double.tryParse(priceController.text.trim()) ?? 0,
          image: _pickedImage,
          hasPurchased: _hasPurchased,
        );
      }
    }
  }

  @override
  void initState() {
    if (widget.initialData != null) {
      modelController.text = widget.initialData!.modelName;
      modelNoController.text = widget.initialData!.modelNo.toString();
      priceController.text = widget.initialData!.price.toString();
      selectedNetworkUrl = widget.initialData!.imgUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add / Update Car'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_pickedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _pickedImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else if (selectedNetworkUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        selectedNetworkUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: showNetworkImages,
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: showNetworkImages,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Tap to pick an image'),
                    ),
                  ),
                ),
              InputField1(
                inputController: modelController,
                label: 'Model Name',
                inputType: TextInputType.text,
              ),
              InputField1(
                inputController: modelNoController,
                label: 'Model Number',
                inputType: TextInputType.number,
              ),
              InputField1(
                inputController: priceController,
                label: 'Price',
                inputType: const TextInputType.numberWithOptions(decimal: true),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _hasPurchased,
                    onChanged: (value) {
                      setState(() {
                        _hasPurchased = value ?? false;
                      });
                    },
                  ),
                  const Text('Has Purchased'),
                ],
              ),
              BlocBuilder<CarBloc, CarState>(
                builder: (context, state) {
                  if (state is OperationInProgress) {
                    return ProgressBar(progress: state.progress);
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: PrimaryBtn(
                          onPressed: _saveForm,
                          text: 'Save',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNetworkImages() {
    showModalBottomSheet<NetworkImageSheet>(
      barrierColor: AppColors.grey1.withAlpha(200),
      context: context,
      builder: (context) {
        return NetworkImageSheet(
          onSelectImage: (p0) {
            if (p0.isEmpty) {
              _pickImage();
            } else {
              setState(() {
                selectedNetworkUrl = p0;
              });
            }
          },
        );
      },
    );
  }
}
