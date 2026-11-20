import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../models/account_model.dart';

abstract class AuthRemoteDataSource {
  Future<AccountModel> signIn(SignInParams params);
  Future<AccountModel> register(RegisterParams params);
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._auth, this._firestore, this._storage);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AccountModel _account(User? user) {
    if (user == null || user.email == null) {
      throw FirebaseAuthException(code: 'invalid-credential');
    }
    return AccountModel(uid: user.uid, email: user.email!);
  }

  @override
  Future<AccountModel> signIn(SignInParams params) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    return _account(result.user);
  }

  @override
  Future<AccountModel> register(RegisterParams params) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    final user = credential.user;
    if (user == null) throw FirebaseAuthException(code: 'internal-error');
    Reference? uploadedPhoto;
    final document = _firestore.collection('users').doc(user.uid);
    bool profileSaved = false;
    try {
      String? photoPath;
      final photo = params.photo;
      if (photo != null) {
        uploadedPhoto = _storage.ref(
          'users/${user.uid}/profile.${photo.extension}',
        );
        await uploadedPhoto.putData(
          photo.bytes,
          SettableMetadata(contentType: photo.contentType),
        );
        photoPath = uploadedPhoto.fullPath;
      }
      await document.set({
        'name': params.name,
        'phone': params.phone,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'photoPath': ?photoPath,
      });
      profileSaved = true;
      await user.updateDisplayName(params.name);
      return _account(user);
    } catch (_) {
      // Firebase services do not share a transaction. Roll back only this newly
      // created account, never a pre-existing account.
      if (uploadedPhoto != null) {
        try {
          await uploadedPhoto.delete();
        } catch (_) {
          /* Best-effort cleanup. */
        }
      }
      if (profileSaved) {
        try {
          await document.delete();
        } catch (_) {
          /* Best-effort cleanup. */
        }
      }
      try {
        await user.delete();
      } catch (_) {
        await _auth.signOut();
        throw FirebaseAuthException(code: 'registration-cleanup-failed');
      }
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);
}
