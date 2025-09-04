import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie/Core/Utils/app_assets.dart';
import 'package:movie/Core/Utils/app_colors.dart';
import 'package:movie/Core/Utils/app_text_style.dart';
import 'package:movie/l10n/app_language_provider.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'home_provider.dart';

class HomeScreen extends StatefulWidget {
  final Function(String genre) onSeeAllTapped;

  const HomeScreen({Key? key, required this.onSeeAllTapped}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late var width;
  late var height;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MovieProvider>();
      provider.fetchAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          if (provider.availableNowMovies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final backgroundImage =
              provider.availableNowMovies[_currentIndex].mediumCoverImage;

          return Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: backgroundImage ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.black),
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.black),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(19, 18, 18, 0.8),
                        Color.fromRGBO(19, 18, 18, 0.6),
                        Color.fromRGBO(19, 18, 18, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // هنا يبدأ التعديل
              RefreshIndicator(
                onRefresh: () async {
                  await provider.fetchAllData();
                },
                color: AppColors.yellow,
                backgroundColor: AppColors.black,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.availableNow),
                        const SizedBox(height: 16),
                        _buildAvailableNowSection(provider),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: Image.asset(AppAssets.watchNow),
                        ),
                        _buildAllMoviesSection(provider),
                      ],
                    ),
                  ),
                ),
              ),
              // هنا ينتهي التعديل
            ],
          );
        },
      ),
    );
  }
  //------------------------------------------------------------------------------------------------------------------
  // Avalabile Now Widget

  Widget _buildAvailableNowSection(MovieProvider provider) {
    if (provider.availableNowState == ViewState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.yellow),
      );
    } else if (provider.availableNowState == ViewState.error) {
      return Column(
        children: [
          Text(
            provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Failed to load Available Movies',
            style: const TextStyle(color: Colors.red),
          ),
          ElevatedButton(
            onPressed: () => provider.fetchAvailableNowMovies(),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return CarouselSlider.builder(
      itemCount: provider.availableNowMovies.length,
      itemBuilder: (context, index, realIndex) {
        final movie = provider.availableNowMovies[index];
        return GestureDetector(
          // onTap: () => Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => MovieDetailsScreen(movieId: movie.id!),
          //   ),
          // ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: movie.mediumCoverImage ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey),
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.grey),
                ),
              ),
              Positioned(
                top: 11,
                left: 9,
                child: Container(
                  width: width * 0.18,
                  height: height * 0.04,
                  decoration: BoxDecoration(
                    color: AppColors.black_71opacity,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${movie.rating}",
                        style: AppTextStyle.robotoW400Wight16,
                      ),
                      ImageIcon(
                        AssetImage(AppAssets.rateIcon),
                        color: AppColors.yellow,
                        size: width * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: height * 0.3766,
        aspectRatio: 430 / 254,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.5,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
  //----------------------------------------------------------------------------------------------------------------------------
  //All movie Section Widget

  Widget _buildAllMoviesSection(MovieProvider provider) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    if (provider.allMoviesState == ViewState.loading) {
      return Center(child: CircularProgressIndicator(color: AppColors.yellow));
    } else if (provider.allMoviesState == ViewState.error) {
      return Column(
        children: [
          Text(
            provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Failed to load Movies by Genre',
            style: const TextStyle(color: Colors.red),
          ),
          ElevatedButton(
            onPressed: () => provider.fetchMoviesByGenre(),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return Column(
      children: provider.movieGenres.map((genre) {
        final movies = provider.moviesByGenre[genre];
        if (movies == null || movies.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: languageProvider.applanguage == "ar" ? width * 0.01 : 0,
                right: languageProvider.applanguage == "ar" ? 0 : width * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    genre.sentenceCase,
                    style: AppTextStyle.robotoW400Wight20,
                  ),

                  TextButton(
                    onPressed: () {
                      widget.onSeeAllTapped(genre);
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "See More",
                          style: TextStyle(color: AppColors.yellow),
                        ),
                        SizedBox(width: width * 0.01),
                        Icon(
                          languageProvider.applanguage == "en"
                              ? Icons.arrow_back
                              : Icons.arrow_forward,
                          color: AppColors.yellow,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              height: height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length > 8 ? 8 : movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    // onTap: () => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => MovieDetailsScreen(movieId: movie.id!),
                    //   ),
                    // ),
                    child: Stack(
                      children: [
                        Container(
                          width: width * 0.3,
                          margin: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: movie.mediumCoverImage ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey),
                              errorWidget: (context, url, error) =>
                                  Container(color: Colors.grey),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 11,
                          left: 11,
                          child: Container(
                            width: width * 0.15,
                            height: height * 0.03,
                            decoration: BoxDecoration(
                              color: AppColors.black_71opacity,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${movie.rating}",
                                  style: AppTextStyle.robotoW400Wight16,
                                ),
                                ImageIcon(
                                  AssetImage(AppAssets.rateIcon),
                                  color: AppColors.yellow,
                                  size: width * 0.05,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.01),
          ],
        );
      }).toList(),
    );
  }
}
