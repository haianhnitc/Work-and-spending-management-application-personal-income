import 'dart:io';
import 'package:flutter/services.dart';

class EnvConfig {
  static final Map<String, String> _env = {};
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      String? envContent;

      try {
        print('🔍 EnvConfig: Trying to load from assets/.env...');
        envContent = await rootBundle.loadString('assets/.env');
        print('✅ EnvConfig: Found .env file in assets');
      } catch (e) {
        print('⚠️ EnvConfig: Could not load from assets: $e');

        final possiblePaths = [
          '.env',
          '../.env',
          '../../.env',
          '../../../.env',
          Platform.script.resolve('../.env').toFilePath(),
          Platform.script.resolve('../../.env').toFilePath(),
          Platform.script.resolve('../../../.env').toFilePath(),
        ];

        File? envFile;

        for (final path in possiblePaths) {
          try {
            final file = File(path);
            if (await file.exists()) {
              envFile = file;
              print('✅ EnvConfig: Found .env file at: $path');
              break;
            }
          } catch (e) {
            continue;
          }
        }

        if (envFile != null) {
          envContent = await envFile.readAsString();
        }
      }

      if (envContent != null) {
        print('✅ EnvConfig: Loading environment variables...');
        _parseEnvFile(envContent);

        if (_env.isNotEmpty) {
          print('🔧 EnvConfig: Loaded ${_env.length} environment variables');
          _env.forEach((key, value) {
            if (key.contains('API_KEY')) {
              print(
                  '🔑 EnvConfig: $key = ${value.length > 10 ? value.substring(0, 10) + '...' : value}');
            } else {
              print('🔧 EnvConfig: $key = $value');
            }
          });
        }
      } else {
        print(
            '⚠️ EnvConfig: No .env file found in any of the expected locations');
        print('📍 Current working directory: ${Directory.current.path}');
      }
    } catch (e) {
      print('❌ EnvConfig: Error loading .env file: $e');
    }
    _initialized = true;
  }

  static void _parseEnvFile(String contents) {
    for (final line in contents.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final parts = trimmed.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        _env[key] = value;
      }
    }
  }

  static String? get(String key) {
    final value = _env[key] ?? Platform.environment[key];
    if (value == null) {
      print('⚠️ EnvConfig: Key "$key" not found in environment variables');
      print('📋 Available keys: ${_env.keys.join(', ')}');
    }
    return value;
  }

  static String getOrDefault(String key, String defaultValue) {
    return get(key) ?? defaultValue;
  }

  static String get openAiApiKey => get('OPENAI_API_KEY') ?? '';
  static String get openAiModel =>
      getOrDefault('OPENAI_MODEL', 'gpt-3.5-turbo');
  static int get openAiMaxTokens =>
      int.tryParse(get('OPENAI_MAX_TOKENS') ?? '1000') ?? 1000;
  static double get openAiTemperature =>
      double.tryParse(get('OPENAI_TEMPERATURE') ?? '0.7') ?? 0.7;

  static String get geminiApiKey => get('GEMINI_API_KEY') ?? '';
  static String get geminiModel =>
      getOrDefault('GEMINI_MODEL', 'gemini-2.0-flash');

  static String get appEnv => getOrDefault('APP_ENV', 'development');
  static bool get debugMode => get('DEBUG_MODE')?.toLowerCase() == 'true';

  static bool get isOpenAiConfigured => openAiApiKey.isNotEmpty;

  static bool get isGeminiConfigured => geminiApiKey.isNotEmpty;

  static bool get isAiConfigured => isOpenAiConfigured || isGeminiConfigured;

  static List<String> validate() {
    final missing = <String>[];

    if (!isAiConfigured) {
      missing.add('OPENAI_API_KEY or GEMINI_API_KEY');
    }

    return missing;
  }
}
