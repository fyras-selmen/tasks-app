import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_db_helper.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class CacheServices {
  const CacheServices._();

  static Future<bool> setData(String key, APICacheDBModel model) async =>
      await APICacheManager().addCacheData(model);

  static Future<APICacheDBModel> getData(String key) async =>
      await APICacheManager().getCacheData(key);

  static Future<bool> delete(String key) async =>
      await APICacheManager().deleteCache(key);

  static Future<bool> containsKey(String key) async =>
      await APICacheManager().isAPICacheKeyExist(key);

  static Future<void> clearAll() async => await APICacheManager().emptyCache();

 // Retrieve all cached data (without specifying a key)
  static Future<List<APICacheDBModel>> getAllData() async {
    // Query all entries from the cache database
    final List<Map<String, dynamic>> queryResult = await APICacheDBHelper.query(APICacheDBModel.table);

    // Convert each entry into an APICacheDBModel object
    return queryResult.map((data) => APICacheDBModel.fromMap(data)).toList();
  }
}
