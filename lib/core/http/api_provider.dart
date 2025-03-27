import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:finder/core/constant/end_points/api_url.dart';

import 'dio_error_handle.dart';
import 'http_method.dart';

class ApiProvider {
  static var options = BaseOptions(
      baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10));
  static final Dio dio = Dio(options);

  static Future<Either<String, T>> sendObjectRequest<T>({
    required HttpMethod method,
    required String url,
    bool isImageResponse = false,
    Map<String, dynamic>? data,
    required Function(Map<String, dynamic>) converter,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    File? file,
    File? secondFile,
    List<File>? imageFiles,
    List<File>? videoFiles,
    String? fileVideoKey,
    String? fileKey,
    String? secondFileKey,
    required String strString,
  }) async {
    final Map<String, dynamic> dataMap = {};
    Response? response;
    try {
      if (data != null) {
        dataMap.addAll(data);
      }
      if (file != null) {
        if (fileKey != null && fileKey != '') {
          String fileName = file.path.split("/").last;
          debugPrint('fileNamexxxx in file');
          debugPrint(fileName);
          late MultipartFile multipartFile;
          multipartFile =
              await MultipartFile.fromFile(file.path, filename: fileName);
          dataMap.addAll({fileKey: multipartFile});
        }
      }
      if (secondFile != null) {
        if (secondFileKey != null && secondFileKey != '') {
          String fileName = secondFile.path.split("/").last;
          debugPrint('fileNamexxxx in secondFile');
          debugPrint(fileName);
          late MultipartFile multipartFile;
          multipartFile =
              await MultipartFile.fromFile(secondFile.path, filename: fileName);
          dataMap.addAll({secondFileKey: multipartFile});
        }
      }
      if (imageFiles != null && imageFiles.isNotEmpty) {
        List<MultipartFile> multipartFiles = [];
        for (var element in imageFiles) {
          String fileName = element.path.split("/").last;
          debugPrint('fileNamexxxx in imageFiles');
          debugPrint(fileName);
          multipartFiles.add(
              await MultipartFile.fromFile(element.path, filename: fileName));
        }
        dataMap.addAll({
          fileKey!: multipartFiles,
        });
      }
      if (videoFiles != null && videoFiles.isNotEmpty) {
        debugPrint('fileNamexxxx in videoooos');
        List<MultipartFile> multipartFiles = [];
        for (var element in videoFiles) {
          String fileName = element.path.split("/").last;
          debugPrint('fileNamexxxxvideoooos');
          debugPrint(videoFiles.first.path);
          multipartFiles.add(
              await MultipartFile.fromFile(element.path, filename: fileName));
        }
        dataMap.addAll({
          fileVideoKey!: multipartFiles,
        });
      }
      debugPrint('[$method: $url] data : [$data]');
      debugPrint('queryParameters : [$queryParameters]');

      dio.options.headers = headers;
      switch (method) {
        case HttpMethod.GET:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.POST:
          response = await dio.post(
            url,
            data: file == null ? dataMap : FormData.fromMap(dataMap),
            queryParameters: queryParameters ?? {},
            onSendProgress: (int sent, int total) {
              debugPrint(
                  'progress: ${(sent / total * 100).toStringAsFixed(0)}% ($sent/$total)');
            },
          );
          break;
        case HttpMethod.PUT:
          response = await dio.put(
            url,
            data: FormData.fromMap(dataMap),
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.DELETE:
          response = await dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }
      dio.interceptors.add(PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));

      var decodedJson =
          response.data is String ? json.decode(response.data) : response.data;
      // if (isImageResponse) {
      //   return Right(response.data);
      // }
      if (decodedJson == null) {
        return const Left('An unexpected error occurred.');
      }
      if (kDebugMode) {
        printWrapped(decodedJson.toString());
      }
      debugPrint('Response data: $decodedJson');

      if (response.statusCode == 200) {
        return Right(converter(decodedJson ?? {}));
      } else if (response.statusCode == 401) {
        final errorMessage = decodedJson['detail'] ??
            decodedJson['description'] ??
            'Something went wrong';
        return Left(errorMessage);
      } else if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        final errorMessage = decodedJson['message'] ??
            'An error occurred. Please check your input.';
        return Left(errorMessage);
      } else if (response.statusCode != null && response.statusCode! >= 500) {
        return const Left('Something went wrong');
      } else {
        return const Left('Unexpected error occurred. Please try again later.');
      }
    } on DioException catch (e) {
      // Map to hold error details
      // Map dioError = DioErrorsHandler.onError(e);

      if (kDebugMode) {
        print(e);
      }

      List<dynamic> errors = [];

      // Check for specific DioException types
      if (e.type == DioExceptionType.connectionTimeout) {
        errors = ['Connection timeout. Please try again later.'];
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errors = ['Server took too long to respond.'];
      } else if (e.type == DioExceptionType.sendTimeout) {
        errors = ['Request took too long to send.'];
      } else if (e.type == DioExceptionType.cancel) {
        errors = ['Request was cancelled.'];
      } else if (e.type == DioExceptionType.badResponse) {
        // Handle HTTP errors
        if (e.response?.statusCode == 500) {
          errors = ['Something went wrong , try again later.'];
        } else {
          var responseData = e.response?.data;

          if (responseData is Map) {
            var message = responseData['description'];
            if (message is String) {
              errors = [message];
            } else if (message is List && message.isNotEmpty) {
              errors = [message.first ?? 'Unknown error occurred.'];
            } else if (message is Map && message.isNotEmpty) {
              var firstKey = message.keys.first;
              var firstValue = message[firstKey];
              if (firstValue is List && firstValue.isNotEmpty) {
                errors = [firstValue.first ?? 'Unknown error occurred.'];
              } else {
                errors = [firstValue.toString()];
              }
            } else {
              errors = ['An unexpected error occurred'];
            }
          } else if (responseData is String) {
            errors = [responseData]; // Directly assign the string error message
          } else {
            errors = ['An unexpected error occurred'];
          }
        }
      } else if (e.type == DioExceptionType.unknown) {
        errors = ['An unknown error occurred.'];
      }

      // Default to a generic error message if no specific errors found
      if (errors.isEmpty) {
        errors = ['An unexpected error occurred.'];
      }

      // Return the first error message
      return Left(errors.first);
    } on SocketException catch (e, stacktrace) {
      if (kDebugMode) {
        debugPrint('SocketException');
        print(e);
        print(stacktrace);
      }
      return const Left('Please check your connection');
    }
  }

  static Future<Either<String, String>> sendObjectWithOutResponseRequest<T>({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      debugPrint('[$method: $url] data : $data');
      debugPrint('queryParameters : [$queryParameters]');
      debugPrint(jsonEncode(data));
      dio.options.headers = headers;
      Response response;
      switch (method) {
        case HttpMethod.GET:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.POST:
          response = await dio.post(
            url,
            data: data,
            queryParameters: queryParameters ?? {},
          );
          break;
        case HttpMethod.PUT:
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.DELETE:
          response = await dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }

      var decodedJson;

      if (response.data is String) {
        decodedJson = json.decode(response.data);
      } else {
        decodedJson = response.data;
      }

      if (decodedJson['data'] == false || decodedJson['data'] == true) {
        decodedJson['data'] = {'': ''};
      }
      if (kDebugMode) {
        printWrapped(decodedJson.toString());
      }

      if ((response.statusCode)! > 199 && (response.statusCode)! < 300) {
        if (decodedJson['success'] == true) {
          return Right(decodedJson['message']);
        } else {
          return Left(response.data['message']);
        }
      } else if ((response.statusCode) == 500) {
        return const Left('Something went wrong');
      } else {
        return Left(response.data['message']);
      }
    } on DioException catch (e) {
      Map dioError = DioErrorsHandler.onError(e);
      if (kDebugMode) {
        print(e);
      }
      return Left(e.response?.data['message'] ?? dioError['message']);
    } on SocketException catch (e, stacktrace) {
      if (kDebugMode) {
        debugPrint('SocketException');
        print(e);
        print(stacktrace);
      }
      return const Left('please check your connection');
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }
}
