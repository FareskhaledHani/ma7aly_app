import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/home_identity_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeIdentityModel> getIdentity();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._db, this._auth);
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  @override
  Future<HomeIdentityModel> getIdentity() async {
    final user = _auth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'unauthenticated');
    final ref = _db.collection('users').doc(user.uid);
    final profile = await ref.get(const GetOptions(source: Source.server));
    final settings = await ref
        .collection('settings')
        .doc('shop')
        .get(const GetOptions(source: Source.server));
    final name = profile.data()?['name'];
    final shop = settings.data()?['shopName'];
    return HomeIdentityModel.fromJson({
      'ownerName': name is String ? name : user.displayName ?? '',
      'shopName': shop is String ? shop : '',
    });
  }
}
