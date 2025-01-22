import 'package:json_annotation/json_annotation.dart';

part 'car_data.g.dart';

@JsonSerializable()
class CarData {
  String id;
  String modelName;
  int modelNo;
  double price;
  String imgUrl;
  bool hasPurchased;

  CarData({
    this.id = '',
    this.modelName = '',
    this.modelNo = 0,
    this.price = 0.0,
    this.imgUrl = '',
    this.hasPurchased = false,
  });
  
  factory CarData.fromJson(Map<String, dynamic> json) =>
      _$CarDataFromJson(json);

  Map<String, dynamic> toJson() => _$CarDataToJson(this);


  CarData copyWith({
    String? id,
    String? modelName,
    int? modelNo,
    double? price,
    String? imgUrl,
    bool? hasPurchased,
  }) {
    return CarData(
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      modelNo: modelNo ?? this.modelNo,
      price: price ?? this.price,
      imgUrl: imgUrl ?? this.imgUrl,
      hasPurchased: hasPurchased ?? this.hasPurchased,
    );
  }

  @override
  String toString() {
    return 'CarData(modelName: $modelName, modelNo: $modelNo, price: $price, imgUrl: $imgUrl, hasPurchased: $hasPurchased)';
  }
}
