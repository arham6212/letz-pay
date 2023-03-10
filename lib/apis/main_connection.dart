import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letzpay/core/utils.dart';

enum HttpMethod { get, post, put, delete }

final dioProvider = Provider((ref) => Dio(
      BaseOptions(
        baseUrl: 'http://13.232.184.210:8080/epos/',
        connectTimeout: 10000,
        receiveTimeout: 10000,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ));

class Connection {
  final Dio _dio;

  Connection(this._dio);

  Future<Result<T>> callApi<T>(String path, HttpMethod method,
      {var data, Map<String, dynamic>? queryParameters}) async {
    try {
      data = jsonEncode(data).encrypt();
      log(data);
      var response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get<T>(path, queryParameters: queryParameters);
          break;
        case HttpMethod.post:
          response = await _dio.post<T>(path, data: data);
          break;
        case HttpMethod.put:
          response = await _dio.put<T>(path, data: data);
          break;
        case HttpMethod.delete:
          response = await _dio.delete<T>(path);
          break;
      }

      if (response.statusCode == 200) {
        if (response.data['RESPONSE_MESSAGE'].toString().toUpperCase() !=
            'SUCCESS') {
          return Result.failure(response.data['RESPONSE_MESSAGE']);
        }
        return Result.success(response.data as T);
      } else {
        return Result.failure(
            "API call failed with status code: ${response.statusCode}");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return Result.failure(
            "API call failed with status code: ${e.response!.statusCode}");
      } else {
        return Result.failure("API call failed: ${e.message}");
      }
    } catch (e) {
      return Result.failure("API call failed: ${e.toString()}");
    }
  }
}

class Result<T> {
  final T? data;
  final String? error;

  Result({this.data, this.error});

  factory Result.success(T data) => Result(data: data);

  factory Result.failure(String error) => Result(error: error);
}
