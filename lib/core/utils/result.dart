import '../errors/failures.dart';

abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get data => isSuccess ? (this as Success<T>).data : null;
  AppFailure? get failure => isFailure ? (this as Failure<T>).failure : null;
  
  R fold<R>(R Function(AppFailure) onFailure, R Function(T) onSuccess) {
    if (isSuccess) return onSuccess(data!);
    return onFailure(failure!);
    
  }
}