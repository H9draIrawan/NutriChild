import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/exceptions.dart';
import '../../models/child_model.dart';
import '../../../domain/entities/child.dart';

abstract class ChildRemoteDataSource {
  Future<void> add(Child child);
  Future<void> update(Child child);
  Future<void> delete(Child child);
}

class ChildRemoteDataSourceImpl implements ChildRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChildRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<void> add(Child child) async {
    try {
      await _firestore
          .collection('children')
          .doc(child.id)
          .set((child as ChildModel).toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> update(Child child) async {
    try {
      await _firestore
          .collection('children')
          .doc(child.id)
          .update((child as ChildModel).toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> delete(Child child) async {
    try {
      await _firestore.collection('children').doc(child.id).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
