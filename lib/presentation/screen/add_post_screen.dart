import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/models/post/post.dart';
import 'package:post_app/presentation/bloc/post/post_bloc.dart';

class AddPostScreen extends StatefulWidget {
  final Post? post;

  const AddPostScreen({super.key, this.post});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late TextEditingController _userIdController;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.post != null) {
      _titleController = TextEditingController(text: widget.post!.title);
      _bodyController = TextEditingController(text: widget.post!.body);
      _userIdController =
          TextEditingController(text: widget.post!.userId.toString());
    } else {
      _titleController = TextEditingController();
      _bodyController = TextEditingController();
      _userIdController = TextEditingController();
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Post"),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("User Id"),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter user id";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          label: Text("Title"), border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter title";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        label: Text("Body"),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter title";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    BlocConsumer<PostBloc, PostState>(
                      listener: (context, state) {
                        if (state is PostSuccess) {
                          if (state.isError) {
                            ///errormessage
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                      builder: (context, state) {
                        log(state.toString(), name: "state");

                        return ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (!(state is PostSuccess && state.isLoading)) {
                              if (_formKey.currentState!.validate()) {
                                // Save data
                                final title = _titleController.text.trim();
                                final body = _bodyController.text.trim();
                                final String userIdString =
                                    _userIdController.text.trim();
                                final post = Post(
                                  id: widget.post != null
                                      ? widget.post!.id!
                                      : 0,
                                  title: title,
                                  body: body,
                                  userId: int.tryParse(userIdString) ?? 0,
                                );
                                if (widget.post == null) {
                                  context
                                      .read<PostBloc>()
                                      .add(PostAddNewItem(post: post));
                                } else {
                                  log(widget.post!.id!.toString(),
                                      name: "edit post id");
                                  context.read<PostBloc>().add(PostEditItem(
                                      post: post, id: widget.post!.id!));
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: state is PostSuccess && state.isLoading
                              ? CircularProgressIndicator()
                              : widget.post != null
                                  ? const Text("Edit")
                                  : const Text("Save"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
