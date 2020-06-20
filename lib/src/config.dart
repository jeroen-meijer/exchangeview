import 'package:args/args.dart';
import 'package:meta/meta.dart';

import 'package:exchangeview/src/args.dart';

@immutable
class Config {
  const Config._({
    @required this.rate,
    @required this.sourceCurrency,
    @required this.targetCurrency,
    @required this.help,
    @required this.version,
    @required this.verbose,
    @required this.ansi,
  });

  static const keyRate = 'rate';
  static const keySourceCurrency = 'from';
  static const keyTargetCurrency = 'to';
  static const keyHelp = 'help';
  static const keyVersion = 'version';
  static const keyVerbose = 'verbose';
  static const keyAnsi = 'ansi';

  final double rate;
  final String sourceCurrency;
  final String targetCurrency;
  final bool help;
  final bool version;
  final bool verbose;
  final bool ansi;

  bool get shouldCalculateRate => rate != null;

  static final _argParser = ArgParser().withAllArgs();

  static String get usage => _argParser.usage;

  static Config fromArgs(List<String> args) {
    ArgResults options;

    try {
      options = _argParser.parse(args);
    } on FormatException catch (e) {
      throw ArgError(e.message);
    }

    return Config._(
      rate: options[keyRate],
      sourceCurrency: options[keySourceCurrency],
      targetCurrency: options[keyTargetCurrency],
      help: options[keyHelp],
      version: options[keyVersion],
      verbose: options[keyVerbose],
      ansi: options[keyAnsi],
    );
  }

  @override
  String toString() {
    return 'Config(rate: $rate, sourceCurrency: $sourceCurrency, targetCurrency: $targetCurrency, help: $help, version: $version, verbose: $verbose, ansi: $ansi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Config &&
        other.rate == rate &&
        other.sourceCurrency == sourceCurrency &&
        other.targetCurrency == targetCurrency &&
        other.help == help &&
        other.version == version &&
        other.verbose == verbose &&
        other.ansi == ansi;
  }

  @override
  int get hashCode {
    return rate.hashCode ^
        sourceCurrency.hashCode ^
        targetCurrency.hashCode ^
        help.hashCode ^
        version.hashCode ^
        verbose.hashCode ^
        ansi.hashCode;
  }
}

class ArgError implements Exception {
  final String message;
  ArgError(this.message);

  @override
  String toString() => message;
}
