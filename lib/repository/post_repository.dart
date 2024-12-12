import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:post_app/models/post/post.dart';
import 'package:post_app/package/api_service.dart';

class PostRepository {
  Future<List<Post>> getAllPost({required String path}) async {
    try {
      final Response response = await ApiService.get(
        path: path,
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((postToJson) => Post.fromJson(postToJson))
            .toList();
      } else {
        throw "Something went wrong in response - getAllPost";
      }
    } catch (e) {
      throw "Something Went Wrong with request/code - getAllPost";
    }
  }

  Future<Post> addPost({required String path, required Post post}) async {
    try {
      final Response response =
          await ApiService.post(path: path, jsonData: post.toJson());
      log(response.toString(), name: "add post response");
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        throw "Something Went Wrong with response";
      }
    } catch (e) {
      throw "Something Went Wrong with request/code";
    }
  }

  Future<Post> editPost({required String path, required Post post}) async {
    try {
      log(path, name: "edit post path");
      log(post.toJson().toString(), name: "post to edit");
      final Response response = await ApiService.put(path, post.toJson());
      log(response.toString(), name: "edit post response");
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        throw "Wrong in response - EditPost";
      }
    } catch (e) {
      throw "Wrong with code/request -EditPost";
    }
  }

  Future<List<Post>> deletePost({required String path}) async {
    try {
      final Response response = await ApiService.delete(
        path,
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((element) => Post.fromJson(element))
            .toList();
      } else {
        throw "wrong in response - deletePost";
      }
    } catch (e) {
      throw "Wrong with request/code - delete Post";
    }
  }

  Future<List<Post>> searchPost(
      {required String path, required String searchtext}) async {
    try {
      final Response response = await ApiService.get(
          path: path, queryParameters: {"searchText": searchtext});
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((element) => Post.fromJson(element))
            .toList();
      } else {
        throw "wrong in response - searchPost";
      }
    } catch (e) {
      throw "Wrong with request/code -search Post";
    }
  }
}
