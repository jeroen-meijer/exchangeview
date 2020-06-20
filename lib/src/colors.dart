import 'package:exchangeview/src/logging.dart';

typedef ColorWrapper = String Function(Object value);

final subtle = _wrap(logger.ansi.gray);
final green = _wrap(logger.ansi.green);
final red = _wrap(logger.ansi.red);
final blue = _wrap(logger.ansi.blue);

final bold = _wrap(logger.ansi.bold);

ColorWrapper _wrap(String ansiModifier) => (value) => '$ansiModifier$value${logger.ansi.none}';

ColorWrapper getColorForCurrencyCode(String code) {
  final colorsByCurrencyCode = {
    'EUR': blue,
    'USD': green,
    'JPY': red,
  };

  final result = colorsByCurrencyCode[code];

  return colorsByCurrencyCode[code] ?? green;
}