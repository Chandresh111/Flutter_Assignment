import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/posts';

  /// Fetches meaningful blog-style posts from the REST API.
  ///
  /// Local caching is handled separately by CacheService.
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl?limit=12'),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode != 200) {
        throw Exception(
          'Server responded with status ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'Unexpected API response format.',
        );
      }

      final postsData = decoded['posts'];

      if (postsData is! List) {
        throw const FormatException(
          'Posts data was not found in the API response.',
        );
      }

      final posts = postsData
          .whereType<Map<String, dynamic>>()
          .map(Post.fromJson)
          .toList();

      if (posts.isEmpty) {
        throw const FormatException(
          'API returned no posts.',
        );
      }

      return posts;
    } catch (error) {
      throw Exception(
        'Failed to fetch posts from the API. Reason: $error',
      );
    }
  }
}