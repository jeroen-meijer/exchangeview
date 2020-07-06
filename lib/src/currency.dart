import 'package:exchangeview/src/colors.dart';
import 'package:meta/meta.dart';

@immutable
class Currency {
  Currency._(
    this.code, {
    ColorWrapper color,
    int fractionDigits,
    int baseAmount,
  })  : color = color ?? green,
        fractionDigits = fractionDigits ?? FractionDigits.standard,
        baseAmount = baseAmount ?? 1;

  final String code;
  final ColorWrapper color;
  final int fractionDigits;
  final int baseAmount;

  static final usd = Currency._(
    'USD',
    color: green,
  );

  static final eur = Currency._(
    'EUR',
    color: blue,
  );

  static final gbp = Currency._(
    'GBP',
    color: blue,
  );

  static final jpy = Currency._(
    'JPY',
    color: red,
    fractionDigits: FractionDigits.none,
    baseAmount: 100,
  );

  static final all = {usd, eur, gbp, jpy};

  static Map<String, Currency> asMap() {
    return Map.fromEntries(all.map((c) => MapEntry(c.code, c)));
  }

  static Currency fromCodeOrDefault(String code) {
    final value = asMap()[code.toUpperCase()];

    if (value != null) {
      return value;
    }

    return Currency._(code);
  }

  String format([num amount]) {
    return (amount ?? baseAmount).toStringAsFixed(fractionDigits);
  }

  @override
  String toString() {
    return 'Currency(code: $code, color: $color, fractionDigits: $fractionDigits, baseAmount: $baseAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Currency &&
        other.code == code &&
        other.color == color &&
        other.fractionDigits == fractionDigits &&
        other.baseAmount == baseAmount;
  }

  @override
  int get hashCode {
    return code.hashCode ^ color.hashCode ^ fractionDigits.hashCode ^ baseAmount.hashCode;
  }
}

abstract class FractionDigits {
  static const standard = 2;
  static const none = 0;
}
