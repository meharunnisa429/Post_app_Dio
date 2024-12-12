// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_bloc.dart';

class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

class PostSuccess extends PostState {
  final List<Post> posts;
  final bool isError;
  final String message;
  final bool isLoading;
  final List<Post> searchResult;
  final String imagePath;
  PostSuccess(
      {required this.posts,
      this.isError = false,
      this.isLoading = false,
      this.message = "",
      this.searchResult = const [],
      this.imagePath = ""});
  @override
  List<Object> get props =>
      [posts, isError, isLoading, message, searchResult, imagePath];

  PostSuccess copyWith({
    List<Post>? posts,
    bool? isError,
    bool? isLoading,
    String? message,
    List<Post>? searchResult,
  }) {
    return PostSuccess(
      posts: posts ?? this.posts,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      searchResult: searchResult ?? this.searchResult,
    );
  }
}

final class PostError extends PostState {}
