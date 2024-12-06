import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/presentation/bloc/post/post_bloc.dart';
import 'package:post_app/presentation/screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      context.read<PostBloc>().add(PostGetAll());
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("POST APP"),
      ),
    );
  }
}
