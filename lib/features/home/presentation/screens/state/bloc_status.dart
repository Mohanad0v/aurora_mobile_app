import 'dart:core';

enum _Status { initial, loading, success, fail, none }

class BlocStatus<T> {
  final _Status status;

  const  BlocStatus({this.status = _Status.initial})
      : error = null,
        model = null;
  final String? error;
  final T? model;

  BlocStatus.loading()
      : status = _Status.loading,
        error = null,
        model = null;

  BlocStatus.success({this.model})
      : status = _Status.success,
        error = null;

  BlocStatus.fail({required this.error})
      : status = _Status.fail,
        model = null;

  BlocStatus.initial()
      : status = _Status.initial,
        error = null,
        model = null;

  bool isLoading() => status == _Status.loading;

  bool isInitial() => status == _Status.initial;

  bool isFail() => status == _Status.fail;

  bool isSuccess() => status == _Status.success;

  @override
  String toString() {
    return status.name;
  }
}
