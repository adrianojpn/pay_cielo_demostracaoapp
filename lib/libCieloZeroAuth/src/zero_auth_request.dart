import 'package:json_annotation/json_annotation.dart';

part 'zero_auth_request.g.dart';

@JsonSerializable(nullable: false, createToJson: true, createFactory: false)
class ZeroAuthRequest {
  ZeroAuthRequest({
    required this.cardToken,
    required this.cardType,
    required this.cardNumber,
    required this.holder,
    required this.expirationDate,
    required this.securityCode,
    required this.saveCard,
    required this.brand,
    required this.cardOnFile,
  });

  String cardToken;
  CardType cardType;
  String cardNumber;
  String holder;
  String expirationDate;
  String securityCode;
  bool saveCard;
  String brand;
  CardOnFile cardOnFile;

  Map<String, dynamic> toJson() => _$ZeroAuthRequestToJson(this);
}

@JsonSerializable(nullable: false, createToJson: true, createFactory: false)
class CardOnFile {
  CardOnFile({
    required this.usage,
    required this.reason,
  });

  Usage usage;
  Reason reason;

  Map<String, dynamic> toJson() => _$CardOnFileToJson(this);
}

enum CardType { CreditCard, DebitCard }

enum Usage { First, Used }

enum Reason { Recurring, Unscheduled, Installments }

