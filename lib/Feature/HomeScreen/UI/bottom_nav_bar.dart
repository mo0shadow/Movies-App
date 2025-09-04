import 'package:flutter/material.dart';
import 'package:movie/Feature/Search/UI/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:movie/Core/Utils/app_assets.dart';
import 'package:movie/Core/Utils/app_colors.dart';
import 'package:movie/Feature/HomeScreen/UI/home_screen.dart';
import 'package:movie/Feature/HomeScreen/UI/browse_screen.dart';
 
import '../../profile/UI/profile_screen.dart';
import 'home_provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context, listen: true);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final List<Widget> _screens = [
      HomeScreen(
        onSeeAllTapped: (genre) {
          setState(() {
            _selectedIndex = 2;
          });
          _pageController.jumpToPage(2);
        },
      ),
      const MovieSearchScreen(),
      provider.movieGenres.isNotEmpty
          ? BrowseScreen(
              initialGenre: provider.movieGenres.first,
              genres: provider.movieGenres,
              moviesByGenre: provider.moviesByGenre,
            )
          : const Center(child: CircularProgressIndicator()),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _screens,
          ),
          Positioned(
            bottom: height * 0.01,
            left: 0,
            right: 0,
            child: _buildCustomNav(width, height),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomNav(double width, double height) {
    final double containerHeight = height * 0.08; // التحكم الكامل في الطول
    final double iconSize = width * 0.07;

    List<String> icons = [
      AppAssets.homeIcon,
      AppAssets.searchIcon,
      AppAssets.browseIcon,
      AppAssets.profileIcon,
    ];

    return Container(
      height: containerHeight,
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(40, 42, 40, 1),
        borderRadius: BorderRadius.circular(containerHeight / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => _onItemTapped(index),
            child: ImageIcon(
              AssetImage(icons[index]),
              size: iconSize,
              color: isSelected ? AppColors.yellow : Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}

 
