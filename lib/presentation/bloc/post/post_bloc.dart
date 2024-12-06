import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/models/post/post.dart';
import 'package:post_app/repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository = PostRepository();
  PostBloc() : super(PostInitial()) {
    on<PostGetAll>(_getAll);
    on<PostAddNewItem>(_addNewItem);
    on<PostDeleteItem>(_deleteItem);
    on<PostEditItem>(_editItem);
    on<PostSearchItem>(_searchItem);
  }

  void _getAll(PostGetAll event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      List<Post> postlist = await postRepository.getAllPost(path: "posts");
      emit(PostSuccess(posts: postlist));
    } catch (e) {
      emit(PostError());
    }
  }

  void _addNewItem(PostAddNewItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        Post post =
            await postRepository.addPost(path: "post", post: event.post);
        emit(currentState.copyWith(
            posts: List.from(currentState.posts)..add(post), isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(
          posts: List.from(currentState.posts),
          isError: true,
          isLoading: false,
          message: e.toString(),
        ));
      }
    }
  }

  void _editItem(PostEditItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        Post post = await postRepository.editPost(
            path: "post/${event.id}", post: event.post);

        emit(currentState.copyWith(
            posts: List.from(currentState.posts)
              ..removeWhere(
                (element) {
                  return element.id == event.id;
                },
              )
              ..add(post),
            isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(
          posts: List.from(currentState.posts),
          isError: true,
          isLoading: false,
          message: e.toString(),
        ));
      }
    }
  }

  void _deleteItem(PostDeleteItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        await postRepository.deletePost(
          path: "post/${event.id}",
        );

        emit(currentState.copyWith(
            posts: List.from(currentState.posts)
              ..removeWhere(
                (element) {
                  return element.id == event.id;
                },
              ),
            isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(
          posts: List.from(currentState.posts),
          isError: true,
          isLoading: false,
          message: e.toString(),
        ));
      }
    }
  }

  void _searchItem(PostSearchItem event, Emitter<PostState> emit) async {
    final currentState = state;

    if (currentState is PostSuccess) {
      emit(currentState.copyWith(isLoading: true));
      try {
        List<Post> postlist = await postRepository.searchPost(
            path: "search", searchtext: event.text);

        emit(currentState.copyWith(searchResult: postlist, isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(
          posts: List.from(currentState.posts),
          isError: true,
          isLoading: false,
          message: e.toString(),
        ));
      }
    }
  }
}
