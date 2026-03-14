// ignore_for_file: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum CacheFrequency { none, oneHour, sixHours, oneDay, oneWeek }

class SharedPrefsService {
  static Future<void> set(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception("Unsupported type for SharedPrefsService");
    }
  }

  static Future<T?> get<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T?;
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Duration _frequencyToDuration(CacheFrequency frequency) {
    switch (frequency) {
      case CacheFrequency.none:
        return Duration(seconds: 0);
      case CacheFrequency.oneHour:
        return Duration(hours: 1);
      case CacheFrequency.sixHours:
        return Duration(hours: 6);
      case CacheFrequency.oneDay:
        return Duration(days: 1);
      case CacheFrequency.oneWeek:
        return Duration(days: 7);
    }
  }

  Future<http.Response> cacheResponse({
    required String key,
    required CacheFrequency frequency,
    required Future<http.Response> Function() fetchCallback,
    bool override = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final cachedData = prefs.getString(key);
    final cachedTimestampStr = prefs.getString('${key}_timestamp');
    final now = DateTime.now();

    bool cacheExist = cachedData != null && cachedTimestampStr != null;

    if (!override && cacheExist) {
      final cachedTimestamp = DateTime.tryParse(cachedTimestampStr);

      if (cachedTimestamp != null) {
        final expiryDuration = _frequencyToDuration(frequency);

        if (now.difference(cachedTimestamp) < expiryDuration) {
          return http.Response(cachedData, 200);
        } else {
          await prefs.remove(key);
          await prefs.remove('${key}_timestamp');
        }
      } else {
        await prefs.remove(key);
        await prefs.remove('${key}_timestamp');
      }
    }

    final response = await fetchCallback();

    if (response.statusCode == 200 || response.statusCode == 201) {
      await prefs.setString(key, response.body);
      await prefs.setString('${key}_timestamp', now.toIso8601String());
    }

    return response;
  }
}
