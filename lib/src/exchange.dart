import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

@immutable
class Exchange {
  const Exchange({
    this.rates,
    this.base,
    this.date,
  });

  final Map<String, double> rates;
  final String base;
  final DateTime date;

  Exchange copyWith({
    Map<String, double> rates,
    String base,
    DateTime date,
  }) {
    return Exchange(
      rates: rates ?? this.rates,
      base: base ?? this.base,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rates': rates,
      'base': base,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  static Exchange fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return Exchange(
      rates: Map<String, double>.from(map['rates']),
      base: map['base'],
      date: map['date'] == null ? null : DateFormat('yyyy-MM-dd').parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  static Exchange fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Exchange(rates: $rates, base: $base, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    final mapEquals = const DeepCollectionEquality().equals;

    return other is Exchange && mapEquals(other.rates, rates) && other.base == base && other.date == date;
  }

  @override
  int get hashCode => rates.hashCode ^ base.hashCode ^ date.hashCode;
}
