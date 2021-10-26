class ZeroAuthResponse {
  ZeroAuthResponse({
    required this.valid,
    required this.returnCode,
    required this.returnMessage,
    required this.issuerTransactionId,
  });

  String valid;
  String returnCode;
  String returnMessage;
  String issuerTransactionId;

  factory ZeroAuthResponse.fromJson(Map<String, dynamic> json) => ZeroAuthResponse(
    valid: json["Valid"].toString(),
    returnCode: json["ReturnCode"],
    returnMessage: json["ReturnMessage"],
    issuerTransactionId: json["IssuerTransactionId"],
  );
}

