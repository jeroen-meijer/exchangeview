import 'dart:async';
import 'dart:io' as io;

import 'package:exchangeview/src/cli_app.dart';
import 'package:exchangeview/src/colors.dart';
import 'package:exchangeview/src/logging.dart';

Future<void> main(List<String> args) async {
  try {
    await CliApp.processAndRun(args);
  } on ArgError catch (e) {
    log(red('Error: ${e.message}\n'));
    CliApp.printUsage(showWelcome: false);
    io.exit(1);
  } catch (e, st) {
    log(red(bold('Unexpected error: $e')));
    log(red(st));
    io.exit(1);
  }
}
