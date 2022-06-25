// T will be the type of the body that was returned from API
class APIResponse<T> {
  // dynamic data;
  T data;
  bool error;
  String? errorMessage;

  APIResponse({
    required this.data,
    this.errorMessage,
    this.error = false, // Assigning a default value
  });
}
