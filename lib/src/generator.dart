import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class GeneratorData {
  GeneratorData._({
    required this.russianLocales,
    required this.predictRu,
    required this.predictEn,
    required this.setsRu,
    required this.setsEn,
    required this.actionRu,
    required this.actionEn,
    required this.conclusionRu,
    required this.conclusionEn,
  });

  final List<String> russianLocales;
  final List<Map<String, dynamic>> predictRu;
  final List<Map<String, dynamic>> predictEn;
  final Map<String, List<dynamic>> setsRu;
  final Map<String, List<dynamic>> setsEn;
  final Map<String, List<dynamic>> actionRu;
  final Map<String, List<dynamic>> actionEn;
  final Map<String, List<dynamic>> conclusionRu;
  final Map<String, List<dynamic>> conclusionEn;

  static GeneratorData? _instance;

  static GeneratorData get instance {
    final data = _instance;
    if (data == null) {
      throw StateError('GeneratorData.load() must be called before using MadNews');
    }
    return data;
  }

  static Future<void> load() async {
    if (_instance != null) {
      return;
    }
    final raw = await rootBundle.loadString('assets/generator_data.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _instance = GeneratorData._(
      russianLocales: List<String>.from(json['russianLocales'] as List),
      predictRu: _castPredict(json['predictRu']),
      predictEn: _castPredict(json['predictEn']),
      setsRu: _castSets(json['setsRu']),
      setsEn: _castSets(json['setsEn']),
      actionRu: _castSets(json['actionRu']),
      actionEn: _castSets(json['actionEn']),
      conclusionRu: _castSets(json['conclusionRu']),
      conclusionEn: _castSets(json['conclusionEn']),
    );
  }

  static List<Map<String, dynamic>> _castPredict(dynamic value) {
    return (value as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static Map<String, List<dynamic>> _castSets(dynamic value) {
    return (value as Map).map(
      (key, list) => MapEntry(key as String, List<dynamic>.from(list as List)),
    );
  }
}

class MadNews {
  MadNews({String? localeOverride}) {
    final data = GeneratorData.instance;
    final locale = (localeOverride ?? Platform.localeName.substring(0, 2))
        .toLowerCase();
    if (kDebugMode) {
      print('Locale: $locale');
    }

    final useRussian = data.russianLocales.contains(locale);
    final predict = useRussian ? data.predictRu : data.predictEn;
    final actions = useRussian ? data.actionRu : data.actionEn;
    final conclusions = useRussian ? data.conclusionRu : data.conclusionEn;
    final sets = useRussian ? data.setsRu : data.setsEn;

    final personObject = predict[Random().nextInt(predict.length)];
    final sex = personObject['sex'] as String;
    personString = _randomizeTemplate(
      personObject['message'] as String,
      sets,
    ).toUpperCase();
    if (kDebugMode) {
      print('getPerson: $personString');
    }

    final actionList = List<String>.from(actions[sex]! as Iterable);
    actionString =
        _randomizeTemplate(actionList[Random().nextInt(actionList.length)], sets)
            .toUpperCase();
    if (kDebugMode) {
      print('getAction: $actionString');
    }

    final conclusionList = List<String>.from(conclusions[sex]! as Iterable);
    conclusionString = _randomizeTemplate(
      conclusionList[Random().nextInt(conclusionList.length)],
      sets,
    ).toUpperCase();
    if (kDebugMode) {
      print('getConclusion: $conclusionString');
    }
  }

  String personString = '';
  String actionString = '';
  String conclusionString = '';

  String getPerson() => personString;

  String getAction() => actionString;

  String getConclusion() => conclusionString;

  static String _randomizeTemplate(
    String template,
    Map<String, List<dynamic>> sets,
  ) {
    final exp = RegExp(
      r'\[[а-яА-Яa-zA-Z_w]*\]',
      caseSensitive: false,
      multiLine: true,
    );
    for (final match in exp.allMatches(template)) {
      final currentMatch = match.group(0);
      if (currentMatch == null || currentMatch.length < 2) {
        continue;
      }
      final key = currentMatch.substring(1, currentMatch.length - 1);
      final randomSets = sets[key];
      if (randomSets != null && randomSets.isNotEmpty) {
        final replacement =
            randomSets[Random().nextInt(randomSets.length)].toString().trim();
        template = template.replaceAll(currentMatch, replacement);
      } else if (kDebugMode) {
        print('randomSets length is 0 for $key');
      }
    }
    return template;
  }
}
