import 'package:exchangeview/src/currency.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:exchangeview/src/colors.dart';
import 'package:exchangeview/src/config.dart';
import 'package:exchangeview/src/exchange.dart';
import 'package:exchangeview/src/logging.dart';
import 'package:exchangeview/src/utils.dart';

@immutable
class CliApp {
  const CliApp(this.config);

  final Config config;

  Future<void> run() async {
    log(subtle('Date: ${DateTime.now()}'));

    final source = Currency.fromCodeOrDefault(config.sourceCurrency);
    final target = Currency.fromCodeOrDefault(config.targetCurrency);

    final fetchProgress = logger.progress(
      'Fetching current exchange rate for ${source.color(source.code)} and ${target.color(target.code)}',
    );

    final url = 'https://api.exchangeratesapi.io/latest?'
        'base=${source.code}&'
        'symbols=${target.code}';
    trace('Fetching from url $url');

    final response = await http.get(url);
    trace('Response received from url $url');
    trace('Response body: ${response.body}');

    fetchProgress.finish(
      showTiming: true,
    );
    log('');

    Exchange exchange;

    try {
      exchange = Exchange.fromJson(response.body);
      trace('Deserialization complete.');
    } on StateError catch (e) {
      throw ExchangeError(
        rawMessage: e.message,
        currencyCodes: {source, target}.map((c) => c.code).toSet(),
      );
    }

    final exchangeRate = exchange.rates[target.code];
    final baseAmountAfterExchange = source.baseAmount * exchangeRate;

    log('${source.format()} ${source.color(source.code)} = ${bold(baseAmountAfterExchange)} ${target.color(bold(target.code))}');

    if (config.shouldCalculateRate) {
      final hourlyRateAfterExchange = config.rate * exchangeRate;
      log(
        'An hourly rate of ${source.format(config.rate)} ${source.color(source.code)} '
        'is equal to about ${bold(target.format(hourlyRateAfterExchange))} ${target.color(bold(target.code))}',
      );
    }
  }

  @override
  String toString() => 'CliApp(config: $config)';
}

class ExchangeError implements Exception {
  const ExchangeError({
    @required String rawMessage,
    @required Set<String> currencyCodes,
  })  : assert(rawMessage != null),
        _rawMessage = rawMessage,
        _currencyCodes = currencyCodes;

  final String _rawMessage;
  final Set<String> _currencyCodes;

  String get message {
    if (!_rawMessage.containsAny(_currencyCodes)) {
      return _rawMessage;
    }

    final errorCurrencies = _currencyCodes.safeWhere(_rawMessage.contains);

    final clarification = 'It\'s most likely the following currencies are not supported: ${errorCurrencies.join(', ')}';

    return '''
$_rawMessage

${none(yellow(clarification))}''';
  }
}
