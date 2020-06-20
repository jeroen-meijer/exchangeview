import 'dart:async';
import 'dart:io' as io;

import 'package:exchangeview/exchangeview.dart';
import 'package:exchangeview/src/cli_app.dart';
import 'package:exchangeview/src/colors.dart';
import 'package:exchangeview/src/config.dart';
import 'package:exchangeview/src/logging.dart';
import 'package:exchangeview/src/version.dart';

Future<void> main(List<String> args) async {
  Config config;

  try {
    config = Config.fromArgs(args);
  } on ArgError catch (e) {
    log(red('Error: ${e.message}\n'));
    printUsage(showWelcome: false);
    io.exit(1);
  } catch (e, st) {
    log(red(bold('Unexpected error: $e')));
    log(red(st));
    io.exit(1);
  }

  logger = LoggerUtils.fromConfig(config);

  // Only shows up when verbose mode is enabled.
  trace(blue('$appName version $packageVersion'));
  trace(magenta('Verbose logging enabled.'));
  trace(noColor('Generated config from args: ${none(config)}'));
  trace('------------------------------------------');

  if (config.version) {
    return printVersion();
  }

  if (config.help) {
    return printUsage();
  }

  final app = CliApp(config);

  try {
    return await app.run();
  } on ExchangeError catch (e) {
    trace('Exception occurred while deserializing exchange data.');
    log(red('Error while fetching exchange data: ${bold(e.message)}'));
    io.exit(1);
  }
}

void printUsage({bool showWelcome = true}) {
  if (showWelcome) {
    log('''
${blue(appName)} is a tool to help with currency conversion 
and other calculations related to invoicing.\n''');
  }
  log('''
usage: ${bold(executableName)}
${Config.usage}''');
}

void printVersion() {
  log('${blue(appName)} version $packageVersion');
}
