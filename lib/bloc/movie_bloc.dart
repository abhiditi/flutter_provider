import 'package:flutter/cupertino.dart';
import 'package:flutterprovider/model/movie.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MovieBloc with ChangeNotifier {
  BehaviorSubject<List<Movie>> _movieList;
  BehaviorSubject<bool> _loadingStream;

  List<Movie> tmpList = new List();
  int page;
  String title;
  bool _loading;
  Observable get movieObservable => _movieList.stream;
  Observable get loadingObservable => _loadingStream.stream;

  MovieBloc({this.page, this.title}) {
    _movieList =
        new BehaviorSubject.seeded(List<Movie>.generate(0, (int index) {
      return null;
    }));
    _loadingStream = new BehaviorSubject.seeded(false);
    getData(this.page, this.title);
  }

  getData(page, String title) async {
    var url =
        "https://api.themoviedb.org/3/search/movie?query=${title}&api_key=a413dc1e70d4133769723e788efbbd83&language=en-US&page=${page}&include_adult=false";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body)['results'];
      //print(jsonResponse);
      jsonResponse.forEach((i) => tmpList.add(Movie.fromJson(i)));
      _movieList.sink.add(tmpList);
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    _loadingStream.sink.add(false);
    _loading = false;
  }

  getLength() => _movieList.value.length;
  setPage() => page++;
  getPage() => page;

  setTitle() => title;
  getTitle() => title;
  void setLoading() {
    _loading = true;
    _loadingStream.sink.add(true);
  }

  getLoading() => _loading;

  void dispose() {
    _movieList.close();
    _loadingStream.close();
  }
}
