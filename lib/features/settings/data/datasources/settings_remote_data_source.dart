import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/shop_settings_entity.dart';
import '../models/shop_settings_model.dart';

abstract class SettingsRemoteDataSource {
  Future<ShopSettingsModel> load();
  Future<void> save(ShopSettingsEntity settings);
  Future<void> signOut();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl(this._db, this._auth);
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  DocumentReference<Map<String, dynamic>> _user() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw FirebaseAuthException(code: 'requires-recent-login');
    return _db.collection('users').doc(uid);
  }

  @override
  Future<ShopSettingsModel> load() async {
    final user = _user();
    final profile = await user.get(const GetOptions(source: Source.server));
    final settings = await user
        .collection('settings')
        .doc('shop')
        .get(const GetOptions(source: Source.server));
    return ShopSettingsModel.fromJson({
      ...?settings.data(),
      'phone': settings.data()?['phone'] ?? profile.data()?['phone'] ?? '',
      'email': _auth.currentUser?.email ?? '',
    });
  }

  @override
  Future<void> save(ShopSettingsEntity s) =>
      _user().collection('settings').doc('shop').set({
        'shopName': s.shopName.trim(),
        'phone': s.phone.trim(),
        'minimumPaymentPercent': s.minimumPaymentPercent,
        'warningDays': s.warningDays,
        'updatedAt': FieldValue.serverTimestamp(),
      });
  @override
  Future<void> signOut() => _auth.signOut();
}
