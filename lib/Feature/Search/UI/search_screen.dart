import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie/Core/Utils/app_assets.dart';
import 'package:movie/Core/Utils/app_colors.dart';
import 'package:movie/Core/Utils/app_text_style.dart';
import 'package:movie/Feature/Search/UI/search_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({Key? key}) : super(key: key);

  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<SearchProvider>(context, listen: false).searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search Text Field
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: height * 0.02,
              ),
              child: TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                cursorColor: AppColors.yellow,
                style: AppTextStyle.robotoW400Wight16,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: AppTextStyle.robotoW400Wight16,
                  prefixIcon: ImageIcon(
                    AssetImage(AppAssets.searchIcon),
                    color: AppColors.wight,
                  ),
                  filled: true,
                  fillColor: AppColors.lightBlack,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            // Search Results
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  if (_controller.text.isEmpty &&
                      provider.state == AppState.initial) {
                    return Center(child: Image.asset(AppAssets.popcowrnIcon));
                  }

                  switch (provider.state) {
                    case AppState.initial:
                      return Center(child: Image.asset(AppAssets.popcowrnIcon));
                    case AppState.loading:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.yellow,
                        ),
                      );
                    case AppState.error:
                      return Center(
                        child: Text(
                          provider.errorMessage,
                          style: AppTextStyle.interW700Yellow20,
                        ),
                      );
                    case AppState.loaded:
                      if (provider.movies.isEmpty) {
                        return Center(
                          child: Text(
                            'No movies found. Try another title.',
                            style: AppTextStyle.interW700Yellow20,
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.035,
                          vertical: 10,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 1,
                              childAspectRatio: 0.64,
                            ),
                        itemCount: provider.movies.length,
                        itemBuilder: (context, index) {
                          final movie = provider.movies[index];
                          return GestureDetector(
                            onTap: () {
                              // TODO: Add navigation to MovieDetailsScreen
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: width * 0.44,
                                  height: height * 0.3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      movie.mediumCoverImage ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: Colors.grey,
                                                child: const Center(
                                                  child: Text(
                                                    'No Image',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                      );
                  }
                },
              ),
            ),
            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }
}
