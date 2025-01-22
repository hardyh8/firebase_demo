import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/car_data.dart';
import '../../../domain/car_bloc/car_bloc.dart';

class CarDetails extends StatelessWidget {
  const CarDetails({super.key, required this.car});
  final CarData car;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<CarBloc, CarState>(
          builder: (context, state) {
            if (car.imgUrl.isNotEmpty) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  car.imgUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          car.modelName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Model Number: ${car.modelNo}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${car.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          car.hasPurchased ? 'Status: Purchased' : 'Status: Not Purchased',
          style: TextStyle(
            fontSize: 18,
            color: car.hasPurchased ? Colors.blue : Colors.red,
          ),
        ),
      ],
    );
  }
}
