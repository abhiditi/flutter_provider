import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterprovider/bloc/movie_bloc.dart';
import 'package:flutterprovider/widget/movies_info.dart';
import 'package:rating_bar/rating_bar.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  double _ratingStar = 0;
//  final int id;
  Widget customSearchBar = Text("Search Movie");
  Icon customIcon = Icon(Icons.search);
  static String title = " ";
  MovieBloc _movieBloc = new MovieBloc(page: 1, title: title);

  @override
  void dispose() {
    _movieBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  if (this.customIcon.icon == Icons.search) {
                    this.customIcon = Icon(Icons.cancel);
                    this.customSearchBar = TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Movies",
                      ),
                      textInputAction: TextInputAction.go,
                      onSubmitted: (String str) {
                        setState(() {
                          title = str;
                          _movieBloc = new MovieBloc(page: 1, title: title);
                        });
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    );
                  } else {
                    this.customSearchBar = Text("Search");
                    this.customIcon = Icon(Icons.search);
                  }
                });
              },
              padding: EdgeInsets.only(
                left: 0.0,
                right: 0.0,
              ),
              icon: customIcon,
            ),
          ],
          title: customSearchBar,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: Colors.black, width: 3, style: BorderStyle.solid),
          ),
        ),
        body: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Scrollbar(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    if (!_movieBloc.getLoading()) {
                      _movieBloc.setPage();
                      _movieBloc.setLoading();
                      _movieBloc.getData(
                          _movieBloc.getPage(), _movieBloc.getTitle());
                      return true;
                    }
                  }
                  return false;
                },
                child: StreamBuilder(
                  stream: _movieBloc.movieObservable,
                  builder: (context, AsyncSnapshot snapshot) {
                    return ListView.builder(
                      itemCount: _movieBloc.getLength(),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    height: 180.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6.0)),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://image.tmdb.org/t/p/w200/" +
                                                  snapshot.data[index].poster),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        width: 200.0,
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                strutStyle:
                                                    StrutStyle(fontSize: 12.0),
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'RobotoSlab',
                                                    fontSize: 16.0,
                                                  ),
                                                  text:
                                                      '${snapshot.data[index].title}',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // alignment: Alignment.topCenter,
                                      ),
                                      MoviesInfo(id: snapshot.data[index].id),
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            // Icon(Icons.star),
                                            Text(
                                              '${snapshot.data[index].rating}',
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'RobotoSlab',
                                                  fontSize: 20.0),
                                            ),
                                            RatingBar(
                                              onRatingChanged: (rating) =>
                                                  setState(
                                                () => _ratingStar =
                                                    getRating(snapshot, index),
                                              ),
                                              initialRating: _ratingStar =
                                                  getRating(snapshot, index),
                                              filledIcon: Icons.star,
                                              emptyIcon: Icons.star,
                                              halfFilledIcon: Icons.star_half,
                                              isHalfAllowed: true,
                                              filledColor: Colors.orange,
                                              emptyColor: Colors.blueGrey,
                                              halfFilledColor: Colors.orange,
                                              size: 36,
                                            ),
                                          ],
                                        ),
                                        // alignment: Alignment.bottomCenter,
                                      ),
                                    ],
                                  ),
                                ],
                                mainAxisSize: MainAxisSize.max,
                              ),
                              SizedBox(
                                width: 10.0,
                                height: 0.0,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(10.0),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            StreamBuilder(
              stream: _movieBloc.loadingObservable,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == true) {
                  return Align(
                    child: Container(
                      width: 200.0,
                      height: 150.0,
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(child: CircularProgressIndicator())),
                    ),
                    alignment: FractionalOffset.bottomCenter,
                  );
                } else {
                  return SizedBox(
                    width: 0.0,
                    height: 0.0,
                  );
                }
              },
            ),
          ],
        ));
  }

  double getRating(AsyncSnapshot snapshot, int index) {
    double rating = snapshot.data[index].rating;

    if (rating == 10) {
      rating = 5;
    } else if (rating >= 9 && rating < 10) {
      rating = 4.5;
    } else if (rating >= 8 && rating < 9) {
      rating = 4;
    } else if (rating >= 7 && rating < 8) {
      rating = 3.5;
    } else if (rating >= 6 && rating < 7) {
      rating = 3;
    } else if (rating >= 5 && rating < 6) {
      rating = 2.5;
    } else if (rating >= 4 && rating < 5) {
      rating = 2;
    } else if (rating >= 3 && rating < 4) {
      rating = 1.5;
    } else if (rating >= 2 && rating < 3) {
      rating = 1;
    } else if (rating >= 1 && rating < 2) {
      rating = 0.5;
    } else {
      rating = 0;
    }

    return rating;
  }
}
