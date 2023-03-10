import 'dart:convert';
import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../core/providers.dart';
import '../core/type_defs.dart';
import '../features/auth_new/models/login_model.dart';
import 'main_connection.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final connection = ref.watch(connectionProvider);
  return AuthAPI(account: account, connection: connection);
});

abstract class IAuthAPI {
  FutureEither<model.Account> signUp({
    required String email,
    required String password,
  });

  FutureEither<LoginResponseModel> login({
    required String mobile,
    required String pin,
  });

  FutureEither<model.Session> forgotPin({
    required String email,
    required String password,
  });

  Future<model.Account?> currentUserAccount();

  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final Connection _connection;
  final Account _account;

  AuthAPI({required Connection connection, required Account account})
      : _connection = connection,
        _account = account;

  @override
  Future<model.Account?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.Account> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<LoginResponseModel> login({
    required String mobile,
    required String pin,
  }) async {
    try {
      final session = await _connection.callApi('login', HttpMethod.post,
          data: {"MOBILE_NUMBER": mobile, "LOGIN_TYPE": "PIN", "PIN": pin});
      return right(LoginResponseModel.fromJson(session.data));
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<model.Session> forgotPin(
      {required String email, required String password}) {
    // TODO: implement forgotPin
    throw UnimplementedError();
  }
}
