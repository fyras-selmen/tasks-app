import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_db_helper.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class CacheServices {
  const CacheServices._();

  /// Enregistrer des données dans le cache
  static Future<bool> setData(String key, APICacheDBModel model) async =>
      await APICacheManager().addCacheData(model);

  /// Récupérer des données à partir du cache en utilisant une clé
  static Future<APICacheDBModel> getData(String key) async =>
      await APICacheManager().getCacheData(key);

  /// Vérifie si une clé existe dans le cache
  static Future<bool> containsKey(String key) async =>
      await APICacheManager().isAPICacheKeyExist(key);

  /// Récupère toutes les données mises en cache (sans spécifier de clé)
  static Future<List<APICacheDBModel>> getAllData() async {
    // Interroge toutes les entrées de la base de données du cache
    final List<Map<String, dynamic>> queryResult =
        await APICacheDBHelper.query(APICacheDBModel.table);

    // Convertit chaque entrée en objet APICacheDBModel
    return queryResult.map((data) => APICacheDBModel.fromMap(data)).toList();
  }
}
