import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprovider/bloc/get_movie_detail_bloc.dart';
import 'package:flutterprovider/model/movie_detail.dart';
import 'package:flutterprovider/model/movie_detail_response.dart';

class MoviesInfo extends StatefulWidget {
  final int id;
  MoviesInfo({Key key, @required this.id}) : super(key: key);
  @override
  _MoviesInfoState createState() => _MoviesInfoState(id);
}

class _MoviesInfoState extends State<MoviesInfo> {
  final int id;
  _MoviesInfoState(this.id);
  @override
  void initState() {
    super.initState();
    movieDetailBloc..getMovieDetail(id);
  }

  @override
  void dispose() {
    super.dispose();
    movieDetailBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
        stream: movieDetailBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieDetailResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _buildErrorWidget(snapshot.data.error);
            }
            return _buildInfoWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("Error Occured:$error")],
      ),
    );
  }

  Widget _buildInfoWidget(MovieDetailResponse data) {
    MovieDetail detail = data.movieDetail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          //height: 30.0,
          // padding: EdgeInsets.only(top: 10.0),
          child: Text(
            (detail.genres.length >= 7)
                ? 'Genre: ' +
                    detail.genres[0].name +
                    ', ' +
                    detail.genres[1].name +
                    ',\n' +
                    detail.genres[2].name +
                    ', ' +
                    detail.genres[3].name +
                    ',\n' +
                    detail.genres[4].name +
                    ", " +
                    detail.genres[5].name +
                    ", " +
                    detail.genres[6].name
                : (detail.genres.length >= 6)
                    ? 'Genre: ' +
                        detail.genres[0].name +
                        ', ' +
                        detail.genres[1].name +
                        ',\n' +
                        detail.genres[2].name +
                        ', ' +
                        detail.genres[3].name +
                        ',\n' +
                        detail.genres[4].name +
                        ", " +
                        detail.genres[5].name
                    : (detail.genres.length >= 5)
                        ? 'Genre: ' +
                            detail.genres[0].name +
                            ', ' +
                            detail.genres[1].name +
                            ',\n' +
                            detail.genres[2].name +
                            ', ' +
                            detail.genres[3].name +
                            ',\n' +
                            detail.genres[4].name
                        : (detail.genres.length >= 4)
                            ? 'Genre: ' +
                                detail.genres[0].name +
                                ', ' +
                                detail.genres[1].name +
                                ',\n' +
                                detail.genres[2].name +
                                ', ' +
                                detail.genres[3].name
                            : (detail.genres.length >= 3)
                                ? 'Genre: ' +
                                    detail.genres[0].name +
                                    ', ' +
                                    detail.genres[1].name +
                                    ',\n' +
                                    detail.genres[2].name
                                : (detail.genres.length >= 2)
                                    ? 'Genre: ' +
                                        detail.genres[0].name +
                                        ', ' +
                                        detail.genres[1].name
                                    : 'Genre: ' + detail.genres[0].name,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
