class ErrorResponse {
  final String error;
  final String errorDescription;

  ErrorResponse({
    required this.error,
    required this.errorDescription,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        error: json['error'],
        errorDescription: json['error_description'],
      );
}
