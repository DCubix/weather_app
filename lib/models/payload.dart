class Payload<T> {
  final T? data;
  final String? error;

  Payload._({required this.data, this.error});

  factory Payload.success(T data) {
    return Payload._(data: data);
  }

  factory Payload.error(String error) {
    return Payload._(data: null, error: error);
  }

  bool get isSuccess => data != null;
  bool get isError => error != null;

}
