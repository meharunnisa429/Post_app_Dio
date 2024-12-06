import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/presentation/bloc/post/post_bloc.dart';
import 'package:post_app/presentation/screen/add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const AddPostScreen(
              post: null,
            );
          }));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              hintText: "Search",
              hintStyle: const WidgetStatePropertyAll(
                  TextStyle(color: Colors.black38)),
              onChanged: (value) {
                // if (_searchController.text.trim().isEmpty) {
                //   log("on changed");
                //   context
                //       .read<PostBloc>()
                //       .add(PostSearchItem(text: _searchController.text));
                // }
              },
              trailing: [
                IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context
                        .read<PostBloc>()
                        .add(PostSearchItem(text: _searchController.text));
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.clear))
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  log(state.toString(), name: "state of get All post");
                  if (state is PostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PostSuccess) {
                    if (state.posts.isNotEmpty) {
                      return ValueListenableBuilder(
                          valueListenable: _searchController,
                          builder: (context, val, _) {
                            return ListView.separated(
                              itemBuilder: (context, index) {
                                final post =
                                    _searchController.text.trim().isEmpty
                                        ? state.posts[index]
                                        : state.searchResult[index];
                                return ListTile(
                                  tileColor: Colors.amber[100],
                                  title: Text(post.title ?? ""),
                                  subtitle: Text(post.body ?? ""),
                                  leading: Text(
                                    post.userId.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return AddPostScreen(
                                              post: post,
                                            );
                                          }));
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.read<PostBloc>().add(
                                              PostDeleteItem(id: post.id!));
                                        },
                                        style: IconButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 16,
                              ),
                              itemCount: _searchController.text.trim().isEmpty
                                  ? state.posts.length
                                  : state.searchResult.length,
                            );
                          });
                    } else {
                      return const Text("No Post Yet");
                    }
                  }
                  return const Text("No Post Yet");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
