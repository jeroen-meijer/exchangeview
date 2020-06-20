import 'package:args/args.dart';
import 'package:exchangeview/src/config.dart';

extension CustomArgs on ArgParser {
  ArgParser withAllArgs() => withRate().withFrom().withTo().withHelp().withVersion().withVerbose().withAnsi();

  ArgParser withRate() => this
    ..addOption(
      Config.keyRate,
      abbr: 'r',
      help: 'The billable hourly rate in the source currency.\n'
          'If provided, the hourly rate will be converted\n'
          'from the source to the target currency.\n'
          'For example: --rate 50.0',
      valueHelp: 'HOURLY RATE',
      callback: (String value) {
        if (value != null && double.tryParse(value) == null) {
          throw FormatException('Hourly rate must be a number', value);
        }
      },
    );

  ArgParser withFrom() => this
    ..addOption(
      Config.keySourceCurrency,
      abbr: 'f',
      help: 'The source currency.',
      valueHelp: 'CURRENCY CODE',
      defaultsTo: 'USD',
      callback: (String value) {
        if (value.length != 3) {
          throw FormatException('Source currency must have exactly 3 characters.', value);
        }
      },
    );

  ArgParser withTo() => this
    ..addOption(
      Config.keyTargetCurrency,
      abbr: 't',
      help: 'The target currency.',
      valueHelp: 'CURRENCY CODE',
      defaultsTo: 'EUR',
      callback: (String value) {
        if (value.length != 3) {
          throw FormatException('Target currency must have exactly 3 characters.', value);
        }
      },
    );

  ArgParser withHelp() => this
    ..addFlag(
      Config.keyHelp,
      abbr: 'h',
      help: 'Display this help menu.',
      negatable: false,
    );

  ArgParser withVersion() => this
    ..addFlag(
      Config.keyVersion,
      help: 'Display the version for exchangeview.',
      negatable: false,
    );

  ArgParser withVerbose() => this
    ..addFlag(
      Config.keyVerbose,
      abbr: 'v',
      help: 'Enable verbose logging.',
      negatable: false,
    );

  ArgParser withAnsi() => this
    ..addFlag(
      Config.keyAnsi,
      abbr: 'a',
      help: 'Enable or disable ANSI logging.',
      negatable: true,
      defaultsTo: true,
    );
}
