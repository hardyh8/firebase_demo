import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/app_colors.dart';
import '../../../../../routing/router_helper.dart';
import '../../../domain/car_bloc/car_bloc.dart';

class NetworkImageSheet extends StatelessWidget {
  const NetworkImageSheet({super.key, required this.onSelectImage});
  final void Function(String) onSelectImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select from network or Pick from File',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<CarBloc, CarState>(
            builder: (context, state) {
              List<_NetworkImageContainer> list = List.empty(growable: true);
              if (state is OperationSuccess) {
                list = [
                  ...state.networkImageUrls.map(
                    (url) => _NetworkImageContainer(
                      url: url,
                      onSelectImage: onSelectImage,
                    ),
                  ),
                  _NetworkImageContainer(
                    url: '',
                    onSelectImage: onSelectImage,
                  )
                ];
              } else {
                list = [
                  _NetworkImageContainer(
                    url: '',
                    onSelectImage: onSelectImage,
                  )
                ];
              }
              return Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: list,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NetworkImageContainer extends StatelessWidget {
  const _NetworkImageContainer({
    required this.url,
    required this.onSelectImage,
  });
  final String url;
  final void Function(String) onSelectImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        RouterHelper.pop<void>(context);
        onSelectImage(url);
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: url.isNotEmpty
              ? Image.network(
                  url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'asset/image/add.jpg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
