import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'http_method.dart';

final guestEndpoints = [
  loginUrl,
  registerUrl,
];

class ApiProvider {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static final BaseOptions _options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  );

  static final Dio _dio = Dio(_options);
  static final Lock _refreshLock = Lock();
  static bool _isRefreshing = false;

  static void init() {
    _dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    _dio.interceptors.add(QueuingInterceptor());

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, _) {
          return error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.receiveTimeout ||
              (error.response?.statusCode != null &&
                  error.response!.statusCode! >= 500);
        },
      ),
    );
  }

  // static Future<bool> _refreshToken() async {
  //   if (_isRefreshing) {
  //     _logger.w('Refresh already in progress, waiting for completion');
  //     return false;
  //   }

  //   _isRefreshing = true;
  //   try {
  //     final refreshToken = CacheHelper.refreshToken;
  //     if (refreshToken == null) {
  //       _logger.w('No refresh token available');
  //       return false;
  //     }
  //     _logger.i('Attempting to refresh token with refreshToken: $refreshToken');
  //     final response = await _dio.post(
  //       '$baseUrl/auth/refresh',
  //       data: {'refreshToken': refreshToken},
  //       options: Options(
  //         headers: {'Authorization': null},
  //         validateStatus: (status) => true,
  //       ),
  //     );

  //     _logger.d('Refresh token response: ${response.data}');

  //     if (response.statusCode == 200 && response.data['success'] == true) {
  //       String newJwt = response.data['data']['jwt'];
  //       final newRefreshToken = response.data['data']['refreshToken'];
  //       CacheHelper.setToken(newJwt);
  //       CacheHelper.setRefreshToken(newRefreshToken);
  //       _logger.i(
  //           'Token refresh successful. New JWT: $newJwt, New Refresh: $newRefreshToken');
  //       return true;
  //     } else {
  //       _logger.w(
  //           'Token refresh failed: Status ${response.statusCode}, Message: ${response.data['message']}');
  //       // await CacheHelper.deleteCertificates();
  //       return false;
  //     }
  //   } catch (e, stackTrace) {
  //     _logger.e('Token refresh error: $e', error: e, stackTrace: stackTrace);
  //     // await CacheHelper.deleteCertificates();
  //     return false;
  //   } finally {
  //     _isRefreshing = false;
  //   }
  // }

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
    _logger.i('Initiating API request: [$method] $url');
    _logger.d('Request data: $data, Query params: $queryParameters');

    final Map<String, dynamic> dataMap = {};
    Response? response;

    try {
      if (data != null) {
        dataMap.addAll(data);
      }

      if (file != null && fileKey != null && fileKey.isNotEmpty) {
        String fileName = file.path.split('/').last;
        _logger.d('Processing file: $fileName');
        dataMap[fileKey] =
            await MultipartFile.fromFile(file.path, filename: fileName);
      }

      if (secondFile != null &&
          secondFileKey != null &&
          secondFileKey.isNotEmpty) {
        String fileName = secondFile.path.split('/').last;
        _logger.d('Processing second file: $fileName');
        dataMap[secondFileKey] =
            await MultipartFile.fromFile(secondFile.path, filename: fileName);
      }

      if (imageFiles != null && imageFiles.isNotEmpty && fileKey != null) {
        List<MultipartFile> multipartFiles = [];
        for (var element in imageFiles) {
          String fileName = element.path.split('/').last;
          _logger.d('Processing image file: $fileName');
          multipartFiles.add(
              await MultipartFile.fromFile(element.path, filename: fileName));
        }
        dataMap[fileKey] = multipartFiles;
      }

      if (videoFiles != null && videoFiles.isNotEmpty && fileVideoKey != null) {
        List<MultipartFile> multipartFiles = [];
        for (var element in videoFiles) {
          String fileName = element.path.split('/').last;
          _logger.d('Processing video file: $fileName');
          multipartFiles.add(
              await MultipartFile.fromFile(element.path, filename: fileName));
        }
        dataMap[fileVideoKey] = multipartFiles;
      }

      _dio.options.headers = {
        ..._dio.options.headers,
        ...?headers,
      };

      response = await _executeRequest(
        method,
        url,
        file == null ? data : FormData.fromMap(dataMap),
        queryParameters,
        cancelToken,
      );

      _logger.i('Request successful, status code: ${response.statusCode}');

      if (isImageResponse) {
        return Right(response.data as T);
      }

      final decodedJson =
          response.data is String ? json.decode(response.data) : response.data;
      _logger.d('Response data: $decodedJson');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(converter(decodedJson ?? {}));
      } else if (response.statusCode == 401) {
        _logger.w('Unauthorized request');
        return Left(_extractErrorMessage(decodedJson, 'Unauthorized access'));
      } else if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 500) {
        _logger.w('Client error: ${response.statusCode}');
        return Left(_extractErrorMessage(decodedJson, 'Client error occurred'));
      } else if (response.statusCode != null && response.statusCode! >= 500) {
        _logger.e('Server error: ${response.statusCode}');
        return const Left('Server error occurred. Please try again later.');
      }
      _logger.w('Unexpected status code: ${response.statusCode}');
      return const Left('Unexpected error occurred. Please try again later.');
    } on DioException catch (e, stackTrace) {
      _logger.e('DioException occurred: ${e.message}',
          error: e, stackTrace: stackTrace);
      return Left(_handleDioException(e));
    } on SocketException catch (e, stackTrace) {
      _logger.e('Network connectivity issue', error: e, stackTrace: stackTrace);
      return const Left('No internet connection. Please check your network.');
    } on FormatException catch (e, stackTrace) {
      _logger.e('Invalid response format', error: e, stackTrace: stackTrace);
      return const Left('Invalid response format from server');
    } catch (e, stackTrace) {
      _logger.e('Unexpected error', error: e, stackTrace: stackTrace);
      return const Left('An unexpected error occurred. Please try again.');
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
    _logger.i('Initiating API request without response: [$method] $url');
    _logger.d('Request data: $data, Query params: $queryParameters');

    try {
      _dio.options.headers = {
        ..._dio.options.headers,
        ...?headers,
      };
      final response = await _executeRequest(
          method, url, data, queryParameters, cancelToken);

      final decodedJson =
          response.data is String ? json.decode(response.data) : response.data;
      _logger.d('Response data: $decodedJson');

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (decodedJson['success'] == true) {
          _logger.i('Request successful: ${decodedJson['message']}');
          return Right(decodedJson['message'] ?? 'Success');
        }
        _logger.w('Request failed: ${decodedJson['message']}');
        return Left(_extractErrorMessage(decodedJson, 'Request failed'));
      }
      _logger.w('Unexpected status code: ${response.statusCode}');
      return Left(
          _extractErrorMessage(decodedJson, 'Unexpected error occurred'));
    } on DioException catch (e, stackTrace) {
      _logger.e('DioException occurred: ${e.message}',
          error: e, stackTrace: stackTrace);
      return Left(_handleDioException(e));
    } on SocketException catch (e, stackTrace) {
      _logger.e('Network connectivity issue', error: e, stackTrace: stackTrace);
      return const Left('No internet connection. Please check your network.');
    } on FormatException catch (e, stackTrace) {
      _logger.e('Invalid response format', error: e, stackTrace: stackTrace);
      return const Left('Invalid response format from server');
    } catch (e, stackTrace) {
      _logger.e('Unexpected error', error: e, stackTrace: stackTrace);
      return const Left('An unexpected error occurred. Please try again.');
    }
  }

  static Future<Response> _executeRequest(
    HttpMethod method,
    String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  ) async {
    switch (method) {
      case HttpMethod.GET:
        return await _dio.get(url,
            queryParameters: queryParameters, cancelToken: cancelToken);
      case HttpMethod.POST:
        return await _dio.post(url,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken);
      case HttpMethod.PUT:
        return await _dio.put(url,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken);
      case HttpMethod.PATCH:
        return await _dio.patch(url,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken);
      case HttpMethod.DELETE:
        return await _dio.delete(url,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken);
    }
  }

  static String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again later.';
      case DioExceptionType.sendTimeout:
        return 'Request took too long to send. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond. Please try again.';
      case DioExceptionType.connectionError:
        return 'Network connection error. Please check your internet.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Invalid SSL certificate.';
      case DioExceptionType.badResponse:
        final responseData = e.response?.data;
        if (responseData is Map) {
          return _extractErrorMessage(responseData, 'Server error occurred');
        }
        return 'Invalid server response: ${e.response?.statusCode}';
      case DioExceptionType.unknown:
        return 'An unexpected network error occurred. Please try again.';
    }
  }

  static String _extractErrorMessage(
      dynamic responseData, String defaultMessage) {
    if (responseData is Map) {
      final message = responseData['message'] ??
          responseData['description'] ??
          responseData['error'];
      if (message is String) return message;
      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      }
      if (message is Map && message.isNotEmpty) {
        final firstValue = message.values.first;
        return firstValue is List
            ? firstValue.first.toString()
            : firstValue.toString();
      }
    }
    return defaultMessage;
  }
}

class QueuingInterceptor extends Interceptor {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _logger.d('Current path: ${options.path}');
    if (CacheHelper.token != null &&
        !guestEndpoints.contains(options.path) &&
        !options.path.endsWith('/auth/refresh')) {
      _logger.d('Not guest URL, adding token: ${CacheHelper.token}');
      options.headers['Authorization'] = 'Bearer ${CacheHelper.token}';
    } else {
      _logger.d('Guest URL or no token, skipping Authorization header');
    }
    return handler.next(options);
  }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) async {
  //   final path = err.requestOptions.path;
  //   if (err.response?.statusCode == 403 &&
  //       !guestEndpoints.contains(path) &&
  //       !path.endsWith('/auth/refresh') &&
  //       err.response?.data['message'] == 'Expired/Invalid token') {
  //     _logger.w('Unauthorized request detected, attempting token refresh');
  //     try {
  //       return await ApiProvider._refreshLock.execute(() async {
  //         final success = await ApiProvider._refreshToken();
  //         if (success) {
  //           final newToken = CacheHelper.token;
  //           _logger.i('Retrying request with new token: $newToken');
  //           // Create new request options to avoid onRequest modifying headers
  //           final newOptions = Options(
  //             method: err.requestOptions.method,
  //             headers: {
  //               ...err.requestOptions.headers,
  //               'Authorization': 'Bearer $newToken',
  //             },
  //             contentType: err.requestOptions.contentType,
  //             responseType: err.requestOptions.responseType,
  //             validateStatus: err.requestOptions.validateStatus,
  //           );
  //           final response = await ApiProvider._dio.request(
  //             path,
  //             data: err.requestOptions.data,
  //             queryParameters: err.requestOptions.queryParameters,
  //             cancelToken: err.requestOptions.cancelToken,
  //             options: newOptions,
  //             onReceiveProgress: err.requestOptions.onReceiveProgress,
  //             onSendProgress: err.requestOptions.onSendProgress,
  //           );
  //           return handler.resolve(response);
  //         } else {
  //           _logger.w('Token refresh failed, rejecting request');
  //           // await CacheHelper.deleteCertificates();
  //           return handler.reject(err);
  //         }
  //       });
  //     } catch (e, stackTrace) {
  //       _logger.e('Error during token refresh: $e',
  //           error: e, stackTrace: stackTrace);
  //       // await CacheHelper.deleteCertificates();
  //       return handler.reject(err);
  //     }
  //   }
  //   return handler.next(err);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}

class Lock {
  bool _locked = false;
  final List<Future Function()> _queue = [];

  Future<T> execute<T>(Future<T> Function() task) async {
    if (_locked) {
      final completer = Completer<T>();
      _queue.add(() async {
        try {
          final result = await task();
          completer.complete(result);
        } catch (e) {
          completer.completeError(e);
        }
      });
      return await completer.future;
    }

    _locked = true;
    try {
      final result = await task();
      _locked = false;
      _processQueue();
      return result;
    } catch (e) {
      _locked = false;
      _processQueue();
      rethrow;
    }
  }

  void _processQueue() {
    if (_queue.isNotEmpty) {
      final task = _queue.removeAt(0);
      task();
    }
  }
}
