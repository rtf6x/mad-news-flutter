import 'dart:convert';
import 'dart:io';

import 'package:mad_news_flutter/src/generator_data.dart';

void main() {
  final data = <String, dynamic>{
    'russianLocales': russianLocales,
    'predictRu': globalPredict,
    'predictEn': globalPredictEn,
    'setsRu': globalSets,
    'setsEn': globalSetsEn,
    'actionRu': globalAction,
    'actionEn': globalActionEn,
    'conclusionRu': globalConclusion,
    'conclusionEn': globalConclusionEn,
  };

  const jsonPath = 'assets/generator_data.json';
  final encoded = const JsonEncoder.withIndent('  ').convert(data);
  File(jsonPath).writeAsStringSync('$encoded\n');
  stdout.writeln('Wrote $jsonPath');
}
