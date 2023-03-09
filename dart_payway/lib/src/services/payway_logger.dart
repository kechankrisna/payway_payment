import 'package:logger/logger.dart';

class PaywayLogger {
  static Logger get logger => Logger();
}

debugPrint(dynamic message) {
  PaywayLogger.logger.d(message);
}
