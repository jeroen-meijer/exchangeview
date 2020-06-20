import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:http/http.dart' as http;
import 'package:exchangeview/src/colors.dart';
import 'package:exchangeview/src/logging.dart';
import 'package:exchangeview/src/exchange.dart';
import 'package:meta/meta.dart';

const appName = 'exchangeview';

@immutable
class CliApp {
  const CliApp({
    @required this.rate,
    @required this.sourceCurrency,
    @required this.targetCurrency,
  });

  final double rate;
  final String sourceCurrency;
  final String targetCurrency;

  bool get shouldCalculateRate => rate != null;

  static final _argParser = ArgParser()
    ..addOption(
      'rate',
      abbr: 'r',
      help: 'The billable hourly rate in the source currency.\n'
          'If provided, the hourly rate will be converted\n'
          'from the source to the target currency.',
      valueHelp: 'HOURLY RATE',
      callback: (String value) {
        if (value != null && double.tryParse(value) == null) {
          throw FormatException('Hourly rate must be a number', value);
        }
      },
    )
    ..addOption(
      'from',
      abbr: 'f',
      help: 'The source currency.',
      valueHelp: 'CURRENCY CODE',
      defaultsTo: 'USD',
      callback: (String value) {
        if (value.length != 3) {
          throw FormatException('Source currency must have exactly 3 characters.', value);
        }
      },
    )
    ..addOption(
      'to',
      abbr: 't',
      help: 'The target currency.',
      valueHelp: 'CURRENCY CODE',
      defaultsTo: 'EUR',
      callback: (String value) {
        if (value.length != 3) {
          throw FormatException('Target currency must have exactly 3 characters.', value);
        }
      },
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Display this help menu.',
      negatable: false,
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      help: 'Enable verbose logging.',
      negatable: false,
    )
    ..addFlag(
      'ansi',
      abbr: 'a',
      help: 'Enable or disable ANSI logging.',
      negatable: true,
      defaultsTo: true,
    );

  static Future<void> processAndRun(final List<String> args) async {
    ArgResults options;

    try {
      options = _argParser.parse(args);
    } on FormatException catch (e) {
      throw ArgError(e.message);
    }

    final ansi = Ansi(options['ansi'] == true);

    if (options.wasParsed('verbose')) {
      logger = Logger.verbose(ansi: ansi);
    } else {
      logger = Logger.standard(ansi: ansi);
    }

    if (options['help']) {
      printUsage();
      return;
    }

    final rawRate = options['rate'];

    final app = CliApp(
      rate: rawRate == null ? null : double.parse(options['rate']),
      sourceCurrency: options['from'],
      targetCurrency: options['to'],
    );

    return app._run();
  }

  Future<void> _run() async {
    log(subtle('Date: ${DateTime.now()}'));

    final sourceCurrencyColor = getColorForCurrencyCode(sourceCurrency);
    final targetCurrencyColor = getColorForCurrencyCode(targetCurrency);

    final fetchProgress = logger.progress(
      'Fetching current exchange rate for ${sourceCurrencyColor(sourceCurrency)} and ${targetCurrencyColor(targetCurrency)}',
    );

    final url = 'https://api.exchangeratesapi.io/latest?'
        'base=$sourceCurrency&'
        'symbols=$targetCurrency';
    trace('Fetching from url $url');

    final response = await http.get(url);
    trace('Response received from url $url');
    trace('Response body: ${response.body}');

    fetchProgress.finish(
      showTiming: true,
    );
    log('');

    final exchange = Exchange.fromJson(response.body);
    trace('Deerialization complete.');

    final exchangeRate = exchange.rates[targetCurrency];

    log('${1.toStringAsFixed(2)} ${sourceCurrencyColor(sourceCurrency)} = ${bold(exchangeRate)} ${targetCurrencyColor(bold(targetCurrency))}');

    if (shouldCalculateRate) {
      final hourlyRateAfterExchange = rate * exchangeRate;
      log(
        'An hourly rate of ${rate.toStringAsFixed(2)} ${sourceCurrencyColor(sourceCurrency)} is equal to about ${bold(hourlyRateAfterExchange.toStringAsFixed(2))} ${targetCurrencyColor(bold(targetCurrency))}',
      );
    }
  }

  static void printUsage({bool showWelcome = true}) {
    assert(showWelcome != null);
    if (showWelcome) {
      log(
        '${blue('ExchangeView')} is a tool to help with currency conversion '
        'and other calculations related to invoicing.\n',
      );
    }

    log(
      'usage: ${bold(appName)}\n'
      '${_argParser.usage}',
    );
  }

  @override
  String toString() => 'CliApp(rate: $rate, sourceCurrency: $sourceCurrency, targetCurrency: $targetCurrency)';
}

class ArgError implements Exception {
  final String message;
  ArgError(this.message);

  @override
  String toString() => message;
}
