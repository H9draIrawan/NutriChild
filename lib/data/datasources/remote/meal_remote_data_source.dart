import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrichild/core/error/exceptions.dart';
import 'package:nutrichild/domain/entities/meal.dart';
import 'package:nutrichild/data/models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<Meal>> getMeals();
  Future<void> addMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(Meal meal);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final FirebaseFirestore _firestore;

  MealRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<List<Meal>> getMeals() async {
    try {
      final snapshot = await _firestore.collection('meals').get();
      return snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addMeal(Meal meal) async {
    try {
      await _firestore.collection('meals').add((meal as MealModel).toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    try {
      await _firestore
          .collection('meals')
          .doc(meal.id)
          .update((meal as MealModel).toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteMeal(Meal meal) async {
    try {
      await _firestore.collection('meals').doc(meal.id).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
