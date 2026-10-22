import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app.dart';

void main() {
  usePathUrlStrategy(); // removes the "#" from web URLs
  runApp(const DliApp());
}
