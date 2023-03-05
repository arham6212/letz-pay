import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:letzpay/common_components/logger.dart';
import 'package:letzpay/common_functions/common_error_handler.dart';
import 'package:letzpay/common_components/common_progress_dailoug.dart';
import 'package:letzpay/environment/environment.dart';
import 'package:letzpay/utils/api_constans.dart';
import 'package:letzpay/utils/encrypt.dart';
import 'package:letzpay/utils/strings.dart';

class ApiService {
  Dio _dio = Dio();

  ApiService() {
    _dio = Dio(BaseOptions(baseUrl: Environment.baseUrl,
        // baseUrl: "https://reqres.in",
        // connectTimeout: 5000,
        // receiveTimeout: 3000,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        }))
      ..interceptors.add(Logging());
  }

  //forgetpin
  Future<Response> getForgetPin(
    var context,
    var params,
  ) async {
    Response response;
    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getForgetPin,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getForgetPin));
    }
    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  //submerchant login
  Future<Response> getSuperMerchantList(var params, var context) async {
    Response response;

    // CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getSuperMerchantList,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      // CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getSuperMerchantList));
    }

    // CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  //subMerchant
  Future<Response> getSubMerchantList(var params, var context) async {
    Response response;

    // CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getSubMerchantList,
          // data: jsonEncode(params), options: getOptions());
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
    } on DioError catch (e) {
      // CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getSubMerchantList));
    }

    // CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

//change pin
  Future<Response> getUpdatePin(
    var context,
    var params,
  ) async {
    Response response;
    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getUpdatePin,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      /*  data: jsonEncode(params),
          options: getOptions()); */
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getUpdatePin));
    }
    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

//validate forget pin
  Future<Response> validateOtp(
    var context,
    var params,
  ) async {
    Response response;
    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.validateOtp,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.validateOtp));
    }
    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  //reset pin after forget pin
  Future<Response> getResentPin(
    var context,
    var params,
  ) async {
    Response response;
    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getResentPin,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getResentPin));
    }
    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

//mobile validation
  Future<Response> validatePIN(var context, var params) async {
    Response response;
    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.validatePIN,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      //  data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.validatePIN));
    }
    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

//login api for user type
  Future<Response> getLogin(var context, var params) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getLogin,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: params, options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getLogin));
    }
    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

// transactionDetails
  Future<Response> transactionDetail(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.transactionDetail,
          // data: jsonEncode(params), options: getOptions());
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.transactionDetail));
    }
    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

//validate mobile after login
  Future<Response> validateMobile(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.validateMobile,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.validateMobile));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> generateLoginOtp(
    var context,
    var params,
  ) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.generateLoginOtp,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.generateLoginOtp));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

//profile detail
  Future<Response> getProfileDetail(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getProfileDetail,
          // data: jsonEncode(params), options: getOptions());
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getProfileDetail));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getPymentOption(var params, var context) async {
    assert(context != null);
    Response response;

    // CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getPymentOption,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      //  data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      // CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getPymentOption));
    }

    // CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getEposSale(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getEposSale,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      //  data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getEposSale));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getUpiQrSale(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getUpiQrSale,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getUpiQrSale));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getTransactionHistory(
      var params, var context, var callFrom) async {
    Response response;

    if (callFrom.toString() == "First") {
      CommonProgressDialog(context).showLoadingIndicator(loading);
    }

    try {
      response = await _dio.post(ApiConstants.getTransactionHistory,
          // data: jsonEncode(params), options: getOptions());
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
    } on DioError catch (e) {
      if (callFrom.toString() == "First") {
        CommonProgressDialog(context).hideOpenDialog();
      }
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getTransactionHistory));
    }
    if (callFrom.toString() == "First") {
      CommonProgressDialog(context).hideOpenDialog();
    }
    return response;
  }

  Future<Response> getLoginHistory(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getLoginHistory,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getLoginHistory));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getLogOut(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getLogOut,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      //  data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getLogOut));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getTransactionSummary(var params, var context) async {
    Response response;

    // CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getTransactionSummary,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      // CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getTransactionSummary));
    }

    // CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getReportChart(var params, var context) async {
    Response response;

    // CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getReportChart,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      // CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getTransactionSummary));
    }

    // CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getStaticPgAndUPIQr(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getStaticPgAndUPIQr,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      //    data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.getStaticPgAndUPIQr));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> sendQrImage(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.sendQrImage,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.sendQrImage));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> resendLink(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.resendLink,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.resendLink));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> getStatus(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.getStatus,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      // data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(
          CommonErrorHandler.getDioErrorMessage(e, ApiConstants.getStatus));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  Future<Response> invoiceDetails(var params, var context) async {
    Response response;

    CommonProgressDialog(context).showLoadingIndicator(loading);
    try {
      response = await _dio.post(ApiConstants.invoiceDetails,
          data: await Encrypt().encryptString(jsonEncode(params).toString()),
          options: getOptionsString());
      //  data: jsonEncode(params), options: getOptions());
    } on DioError catch (e) {
      CommonProgressDialog(context).hideOpenDialog();
      throw Exception(CommonErrorHandler.getDioErrorMessage(
          e, ApiConstants.invoiceDetails));
    }

    CommonProgressDialog(context).hideOpenDialog();
    return response;
  }

  getOptions() {
    return Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
    });
  }

  getOptionsString() {
    return Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
    });
  }
}

class Logging extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printLog(
        "onRequest",
        'REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path} PARAMS => ${options.data}',
        "i");

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printLog(
        "onResponse",
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} ResponseData => ${response.data}',
        "d");

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    printLog(
        "onError",
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
        "e");

    return super.onError(err, handler);
  }
}
