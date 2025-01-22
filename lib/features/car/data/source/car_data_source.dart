import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../utils/logger.dart';
import '../models/car_data.dart';

class CarDataSource {
  final String collectionPath = 'cars';

  Future<void> addCar(CarData car) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          await firestore.collection(collectionPath).add(car.toJson());
      String generatedId = docRef.id;
      car.id = generatedId;
      await docRef.update({'id': generatedId});
    } catch (e) {
      throw Exception('Error adding car: $e');
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<CarData>> getCars() async {
    try {
      QuerySnapshot snapshot = await firestore.collection(collectionPath).get();
      return snapshot.docs.map((doc) {
        var carData = CarData.fromJson(doc.data() as Map<String, dynamic>);
        carData.id = doc.id;
        return carData;
      }).toList();
    } catch (e) {
      logger.d('error $e');
      throw Exception('Error fetching cars: $e');
    }
  }

  Future<void> updateCar(CarData car) async {
    try {
      await firestore.collection(collectionPath).doc(car.id).update({
        'modelName': car.modelName,
        'modelNo': car.modelNo,
        'price': car.price,
        'imgUrl': car.imgUrl,
        'hasPurchased': car.hasPurchased,
      });
    } catch (e) {
      throw Exception('Error updating car: $e');
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await firestore.collection(collectionPath).doc(carId).delete();
    } catch (e) {
      throw Exception('Error deleting car: $e');
    }
  }

  StreamController<double> progressController = StreamController<double>();

  Future<String> uploadImage(File imageFile) async {
    try {
      progressController = StreamController<double>();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('car_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        logger.d('upload progress $progress');
        progressController.add(progress);
      });

      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      progressController.close();

      return downloadURL;
    } on FirebaseException catch (e) {
      logger.d('FirebaseException: ${e.message}');
      if (e.code == 'object-not-found') {
        logger.d('Object does not exist.');
      } else if (e.code == 'unauthorized') {
        logger.d('Unauthorized request. Check App Check.');
      }
      return '';
    } catch (e) {
      progressController.close();
      throw Exception('Error uploading image: $e');
    }
  }
}
