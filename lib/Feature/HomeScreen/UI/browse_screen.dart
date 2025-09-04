import 'package:flutter/material.dart';
import 'package:movie/Core/Utils/app_assets.dart';
import '../../../Core/Utils/app_colors.dart';
import '../../../Core/Utils/app_text_style.dart';
import '../DataSource/Model/movie_models.dart';
 

class BrowseScreen extends StatefulWidget {
  final String initialGenre;
  final List<String> genres;
  final Map<String, List<Movie>> moviesByGenre;

  const BrowseScreen({
    Key? key,
    required this.initialGenre,
    required this.genres,
    required this.moviesByGenre,
  }) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late String selectedGenre;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.initialGenre; // genre from home page
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.moviesByGenre[selectedGenre] ?? [];
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-------------------------------------------------------------------------------
            //  genre list veiew
            SizedBox(
              height: height * 0.045,
              child: ListView.builder(
                padding: EdgeInsets.only(left: width * 0.01),
                scrollDirection: Axis.horizontal,
                itemCount: widget.genres.length,
                itemBuilder: (context, index) {
                  final genre = widget.genres[index];
                  final isSelected = genre == selectedGenre;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGenre = genre;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: width * 0.02),
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.yellow : AppColors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.yellow),
                      ),
                      child: Center(
                        child: Text(
                          genre,
                          style: isSelected
                              ? AppTextStyle.interW700Black20
                              : AppTextStyle.interW700Yellow20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            //-----------------------------------------------------------------------------------------------------
            SizedBox(height: height * 0.02),

            // movies grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.035),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عدد الأعمدة (3 صور في الصف)
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.64, // نسبة العرض للارتفاع للصورة
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) =>
                      //      //todo:
                      //         //Add movie details Screen   اللي انت هتعملها 
                      //         MovieDetailsScreen(movieId: movie.id!),
                      //   ),
                      // );
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
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Text(
                                        'No Image',
                                        style: TextStyle(color: Colors.white),
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
          ],
        ),
      ),
    );
  }
}
