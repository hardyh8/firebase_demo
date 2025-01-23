import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../routing/router_helper.dart';
import '../../../routing/routes.dart';
import '../data/models/car_data.dart';
import '../domain/car_bloc/car_bloc.dart';

class CarSliderPage extends StatefulWidget {
  const CarSliderPage({super.key});

  @override
  State<CarSliderPage> createState() => _CarSliderPageState();
}

class _CarSliderPageState extends State<CarSliderPage> {
  List<CarData> carList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    context.read<CarBloc>().add(GetCarData());
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
                      child: _buildCard(
                          hasCar &&
                              car?.imgUrl != null &&
                              car!.imgUrl.isNotEmpty,
                          car?.imgUrl ?? '',
                          car?.modelName ?? '',
                          hasCar ? '\$${car!.price.toStringAsFixed(2)}' : ''),
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
            return Skeletonizer(
              effect: const ShimmerEffect(
                baseColor: Color.fromRGBO(224, 224, 224, 1),
                highlightColor: Color.fromRGBO(245, 245, 245, 1),
                duration: Duration(seconds: 1),
              ),
              enabled: true,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 400,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                    ),
                    itemCount: 1,
                    itemBuilder: (context, index, realIndex) {
                      return _buildCard(false, '', '', '');
                    }),
              ),
            );
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

  Card _buildCard(
    bool showNetworkImg,
    String imgUrl,
    String header,
    String text,
  ) {
    return Card(
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
              child: showNetworkImg
                  ? Image.network(
                      imgUrl,
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
                  header,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
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
    );
  }
}
