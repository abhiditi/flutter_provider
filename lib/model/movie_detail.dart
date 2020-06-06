import 'genre.dart';

class MovieDetail {
  final int id;
  final bool adult;
  final int budget;
  final List<Genre> genres;
  final String relaseDate;
  final int runTime;

  MovieDetail(this.id, this.adult, this.budget, this.genres, this.relaseDate,
      this.runTime);
  MovieDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        adult = json["adult"],
        budget = json["budget"],
        genres =
            (json["genres"] as List).map((i) => new Genre.fromJson(i)).toList(),
        relaseDate = json["release_date"],
        runTime = json["runtime"];
}
