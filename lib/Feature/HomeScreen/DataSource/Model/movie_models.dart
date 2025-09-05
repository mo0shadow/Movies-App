import 'package:hive/hive.dart';
part 'movie_models.g.dart';

// موديل استجابة قائمة الأفلام
@HiveType(typeId: 0)
class MovieResponse extends HiveObject {
  @HiveField(0)
  String? status;
  @HiveField(1)
  String? statusMessage;
  @HiveField(2)
  Data? data;
  @HiveField(3)
  Meta? meta;

  MovieResponse({
    this.status,
    this.statusMessage,
    this.data,
    this.meta,
  });

  factory MovieResponse.fromJson(dynamic json) {
    return MovieResponse(
      status: json['status'],
      statusMessage: json['status_message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      meta: json['@meta'] != null ? Meta.fromJson(json['@meta']) : null,
    );
  }
}

// موديل البيانات لقائمة الأفلام
@HiveType(typeId: 1)
class Data extends HiveObject {
  @HiveField(0)
  int? movieCount;
  @HiveField(1)
  int? limit;
  @HiveField(2)
  int? pageNumber;
  @HiveField(3)
  List<Movie>? movies;

  Data({
    this.movieCount,
    this.limit,
    this.pageNumber,
    this.movies,
  });

  factory Data.fromJson(dynamic json) {
    final moviesList = <Movie>[];
    if (json['movies'] != null) {
      json['movies'].forEach((v) {
        moviesList.add(Movie.fromJson(v));
      });
    }
    return Data(
      movieCount: json['movie_count'],
      limit: json['limit'],
      pageNumber: json['page_number'],
      movies: moviesList,
    );
  }
}

// موديل الميتا المشترك
@HiveType(typeId: 2)
class Meta extends HiveObject {
  @HiveField(0)
  int? serverTime;
  @HiveField(1)
  String? serverTimezone;
  @HiveField(2)
  int? apiVersion;
  @HiveField(3)
  String? executionTime;

  Meta({
    this.serverTime,
    this.serverTimezone,
    this.apiVersion,
    this.executionTime,
  });

  factory Meta.fromJson(dynamic json) {
    return Meta(
      serverTime: json['server_time'],
      serverTimezone: json['server_timezone'],
      apiVersion: json['api_version'],
      executionTime: json['execution_time'],
    );
  }
}

// موديل الفيلم الرئيسي
@HiveType(typeId: 3)
class Movie extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? url;
  @HiveField(2)
  String? imdbCode;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? titleEnglish;
  @HiveField(5)
  String? titleLong;
  @HiveField(6)
  String? slug;
  @HiveField(7)
  int? year;
  @HiveField(8)
  double? rating;
  @HiveField(9)
  int? runtime;
  @HiveField(10)
  List<String>? genres;
  @HiveField(11)
  String? summary;
  @HiveField(12)
  String? descriptionFull;
  @HiveField(13)
  String? synopsis;
  @HiveField(14)
  String? ytTrailerCode;
  @HiveField(15)
  String? language;
  @HiveField(16)
  String? mpaRating;
  @HiveField(17)
  String? backgroundImage;
  @HiveField(18)
  String? backgroundImageOriginal;
  @HiveField(19)
  String? smallCoverImage;
  @HiveField(20)
  String? mediumCoverImage;
  @HiveField(21)
  String? largeCoverImage;
  @HiveField(22)
  String? state;
  @HiveField(23)
  List<Torrents>? torrents;
  @HiveField(24)
  int? likeCount;
  @HiveField(25)
  String? dateUploaded;
  @HiveField(26)
  int? dateUploadedUnix;

  Movie({
    this.id, this.url, this.imdbCode, this.title, this.titleEnglish, this.titleLong, this.slug, this.year, this.rating, this.runtime, this.genres, this.summary, this.descriptionFull, this.synopsis, this.ytTrailerCode, this.language, this.mpaRating, this.backgroundImage, this.backgroundImageOriginal, this.smallCoverImage, this.mediumCoverImage, this.largeCoverImage, this.state, this.torrents, this.likeCount, this.dateUploaded, this.dateUploadedUnix,
  });

  factory Movie.fromJson(dynamic json) {
    final torrentsList = <Torrents>[];
    if (json['torrents'] != null) {
      json['torrents'].forEach((v) {
        torrentsList.add(Torrents.fromJson(v));
      });
    }
    return Movie(
      id: json['id'],
      url: json['url'],
      imdbCode: json['imdb_code'],
      title: json['title'],
      titleEnglish: json['title_english'],
      titleLong: json['title_long'],
      slug: json['slug'],
      year: json['year'],
      rating: (json['rating'] as num?)?.toDouble(),
      runtime: json['runtime'],
      genres: json['genres']?.cast<String>(),
      summary: json['summary'],
      descriptionFull: json['description_full'],
      synopsis: json['synopsis'],
      ytTrailerCode: json['yt_trailer_code'],
      language: json['language'],
      mpaRating: json['mpa_rating'],
      backgroundImage: json['background_image'],
      backgroundImageOriginal: json['background_image_original'],
      smallCoverImage: json['small_cover_image'],
      mediumCoverImage: json['medium_cover_image'],
      largeCoverImage: json['large_cover_image'],
      state: json['state'],
      torrents: torrentsList,
      likeCount: json['like_count'],
      dateUploaded: json['date_uploaded'],
      dateUploadedUnix: json['date_uploaded_unix'],
    );
  }
}

// موديل التورنت المشترك
@HiveType(typeId: 4)
class Torrents extends HiveObject {
  @HiveField(0)
  String? url;
  @HiveField(1)
  String? hash;
  @HiveField(2)
  String? quality;
  @HiveField(3)
  String? type;
  @HiveField(4)
  String? isRepack;
  @HiveField(5)
  String? videoCodec;
  @HiveField(6)
  String? bitDepth;
  @HiveField(7)
  String? audioChannels;
  @HiveField(8)
  int? seeds;
  @HiveField(9)
  int? peers;
  @HiveField(10)
  String? size;
  @HiveField(11)
  int? sizeBytes;
  @HiveField(12)
  String? dateUploaded;
  @HiveField(13)
  int? dateUploadedUnix;

  Torrents({this.url, this.hash, this.quality, this.type, this.isRepack, this.videoCodec, this.bitDepth, this.audioChannels, this.seeds, this.peers, this.size, this.sizeBytes, this.dateUploaded, this.dateUploadedUnix});

  factory Torrents.fromJson(dynamic json) {
    return Torrents(
      url: json['url'],
      hash: json['hash'],
      quality: json['quality'],
      type: json['type'],
      isRepack: json['is_repack'],
      videoCodec: json['video_codec'],
      bitDepth: json['bit_depth'],
      audioChannels: json['audio_channels'],
      seeds: json['seeds'],
      peers: json['peers'],
      size: json['size'],
      sizeBytes: json['size_bytes'],
      dateUploaded: json['date_uploaded'],
      dateUploadedUnix: json['date_uploaded_unix'],
    );
  }
}