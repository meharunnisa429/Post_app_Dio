part of 'post_bloc.dart';

sealed class PostEvent {}

class PostAddNewItem extends PostEvent {
  final Post post;
  PostAddNewItem({required this.post});
}

class PostGetAll extends PostEvent {}

class PostEditItem extends PostEvent {
  final Post post;
  final int id;
  PostEditItem({required this.post, required this.id});
}

class PostDeleteItem extends PostEvent {
  final int id;
  PostDeleteItem({required this.id});
}

class PostSearchItem extends PostEvent {
  final String text;
  PostSearchItem({required this.text});
}
