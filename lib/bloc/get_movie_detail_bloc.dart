import 'package:flutter/cupertino.dart';
import 'package:flutterprovider/bloc/GenreBloc.dart';
import 'package:flutterprovider/model/movie_detail_response.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc {
  final GenreBloc _repo = GenreBloc();
  final BehaviorSubject<MovieDetailResponse> _subject =
      BehaviorSubject<MovieDetailResponse>();
  getMovieDetail(int id) async {
    MovieDetailResponse response = await _repo.getMovieDetail(id);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieDetailResponse> get subject => _subject;
}

final movieDetailBloc = MovieDetailBloc();
