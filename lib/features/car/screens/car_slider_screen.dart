import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routing/router_helper.dart';
import '../../../routing/routes.dart';
import '../../../utils/observer/lifecycle_event_handler.dart';
import '../data/models/car_data.dart';
import '../domain/car_bloc/car_bloc.dart';

class CarSliderScreen extends StatefulWidget {
  const CarSliderScreen({super.key});

  @override
  State<CarSliderScreen> createState() => _CarSliderScreenState();
}

class _CarSliderScreenState extends State<CarSliderScreen> {
  List<CarData> carList = List.empty(growable: true);
  late LifecycleEventHandler lifecycleEventHandler;

  @override
  void initState() {
    super.initState();
    context.read<CarBloc>().add(GetCarData());
    lifecycleEventHandler = LifecycleEventHandler(
      resumeCallBack: () async => setState(() {
        var state = context.read<CarBloc>().state;
        if (state is OperationSuccess) {
          setState(() {
            carList.clear();
            carList.addAll(state.carList);
          });
        }
      }),
    );
    WidgetsBinding.instance.addObserver(lifecycleEventHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Showcase'),
      ),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state is OperationSuccess) {
            carList.clear();
            carList.addAll(state.carList);
            return Column(
              children: [
                const SizedBox(height: 20),
                CarouselSlider.builder(
                  itemCount: carList.length + 1,
                  itemBuilder: (context, index, realIndex) {
                    bool hasCar = index < carList.length;
                    final car = hasCar ? carList[index] : null;
                    return GestureDetector(
                      onTap: () {
                        RouterHelper.push(
                          context,
                          AppRoutes.carDetails.name,
                          extra: {
                            'isEdit': hasCar,
                            'data': car?.toJson(),
                          },
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: hasCar &&
                                        car?.imgUrl != null &&
                                        car!.imgUrl.isNotEmpty
                                    ? Image.network(
                                        car.imgUrl,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car?.modelName ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hasCar
                                        ? '\$${car!.price.toStringAsFixed(2)}'
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 400,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                  ),
                ),
              ],
            );
          } else if (state is OperationInProgress) {
            return const CircularProgressIndicator();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => RouterHelper.push(
          context,
          AppRoutes.carDetails.name,
          extra: {
            'isEdit': false,
            'data': null,
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
