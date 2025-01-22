// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarData _$CarDataFromJson(Map<String, dynamic> json) => CarData(
      id: json['id'] as String? ?? '',
      modelName: json['modelName'] as String? ?? '',
      modelNo: (json['modelNo'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imgUrl: json['imgUrl'] as String? ?? '',
      hasPurchased: json['hasPurchased'] as bool? ?? false,
    );

Map<String, dynamic> _$CarDataToJson(CarData instance) => <String, dynamic>{
      'id': instance.id,
      'modelName': instance.modelName,
      'modelNo': instance.modelNo,
      'price': instance.price,
      'imgUrl': instance.imgUrl,
      'hasPurchased': instance.hasPurchased,
    };
