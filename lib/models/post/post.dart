import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
// ignore: must_be_immutable
class Post extends Equatable {
  int? id;
  int? userId;
  String? title;
  String? body;

  Post({this.id, this.userId, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  List<Object?> get props => [id, userId, title, body];
}
