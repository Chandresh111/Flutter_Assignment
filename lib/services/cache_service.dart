import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';

class CacheService {
  static const String _postsKey = 'cached_posts';
  static const String _timestampKey = 'cached_posts_timestamp';

  // ============================================================
  // SAVE POSTS
  // ============================================================

  Future<void> savePosts(List<Post> posts) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedPosts = posts
        .map(
          (post) => {
            'userId': post.userId,
            'id': post.id,
            'title': post.title,
            'body': post.body,
          },
        )
        .toList();

    await preferences.setString(
      _postsKey,
      jsonEncode(encodedPosts),
    );

    await preferences.setString(
      _timestampKey,
      DateTime.now().toIso8601String(),
    );
  }

  // ============================================================
  // GET CACHED POSTS
  // ============================================================

  Future<List<Post>?> getCachedPosts() async {
    final preferences = await SharedPreferences.getInstance();

    final cachedData = preferences.getString(_postsKey);

    if (cachedData == null || cachedData.isEmpty) {
      return null;
    }

    try {
      final decodedData = jsonDecode(cachedData);

      if (decodedData is! List) {
        return null;
      }

      return decodedData
          .map(
            (item) => Post.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // CACHE EXISTS?
  // ============================================================

  Future<bool> hasCachedPosts() async {
    final preferences = await SharedPreferences.getInstance();

    final cachedData = preferences.getString(_postsKey);

    return cachedData != null && cachedData.isNotEmpty;
  }

  // ============================================================
  // GET CACHE TIME
  // ============================================================

  Future<DateTime?> getCacheTimestamp() async {
    final preferences = await SharedPreferences.getInstance();

    final timestamp = preferences.getString(_timestampKey);

    if (timestamp == null) {
      return null;
    }

    return DateTime.tryParse(timestamp);
  }

  // ============================================================
  // GET CACHE AGE
  // ============================================================

  Future<String> getCacheAge() async {
    final timestamp = await getCacheTimestamp();

    if (timestamp == null) {
      return 'No cached data';
    }

    final difference = DateTime.now().difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Cached just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Cached $minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Cached $hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    final days = difference.inDays;
    return 'Cached $days ${days == 1 ? 'day' : 'days'} ago';
  }

  // ============================================================
  // CLEAR CACHE
  // ============================================================

  Future<void> clearCache() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_postsKey);
    await preferences.remove(_timestampKey);
  }
}