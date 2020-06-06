import 'package:flutter/material.dart';
import 'package:flutterprovider/bloc/movie_bloc.dart';
import 'package:flutterprovider/screen/movie_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieBloc>(
          // ignore: deprecated_member_use
          builder: (_) => MovieBloc(page: 1),
          create: (BuildContext context) {},
        ),
      ],
      child: MaterialApp(
        title: 'Provider & Bloc example',
        theme:
            ThemeData(primarySwatch: Colors.blue, primaryColor: Colors.white),
        home: MovieList(),
      ),
    );
  }
}
