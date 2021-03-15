import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier({
    @required this.dio,
    @required this.connectivity,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity.onConnectivityChanged.listen(
      (connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription.cancel();
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              // Something is wrong with this line. Request not retrying.
              options: Options(method: requestOptions.method),
            ),

            // return _dio.request(options.path,
            //   options: Options(
            //     method: options.method,
            //     sendTimeout: options.sendTimeout,
            //     receiveTimeout: options.receiveTimeout,
            //     extra: options.extra,
            //     headers: options.headers,
            //     responseType: options.responseType,
            //     contentType: options.contentType,
            //     validateStatus: options.validateStatus,
            //     receiveDataWhenStatusError: options.receiveDataWhenStatusError,
            //     followRedirects: options.followRedirects,
            //     maxRedirects: options.maxRedirects,
            //     requestEncoder: options.requestEncoder,
            //     responseDecoder: options.responseDecoder,
            //     listFormat: options.listFormat,
            //   ));
          );
        }
      },
    );

    return responseCompleter.future;
  }
}
