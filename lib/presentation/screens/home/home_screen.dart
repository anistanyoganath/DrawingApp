import 'package:aidrawing/core/constants/app_strings.dart';
import 'package:aidrawing/core/constants/app_styles.dart';
import 'package:aidrawing/core/constants/colors.dart';
import 'package:aidrawing/domain/models/caregory.dart';
import 'package:aidrawing/presentation/screens/home/widgets/home_header.dart';
import 'package:aidrawing/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';

import 'widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? selectedCategory;

  // Sample categories data
  final List<Category> categories = [
    Category(
      id: '1',
      name: AppStrings.dinosaurs,
      iconAsset: 'assets/categories/dinosaur.svg',
      color: const Color(0xFF4CAF50),
      description: 'T-Rex, Triceratops, Pterodactyl',
    ),
    Category(
      id: '2',
      name: AppStrings.space,
      iconAsset: 'assets/categories/space.svg',
      color: const Color(0xFF2196F3),
      description: 'Rockets, Planets, Aliens',
    ),
    Category(
      id: '3',
      name: AppStrings.unicorns,
      iconAsset: 'assets/categories/unicorn.svg',
      color: const Color(0xFFE91E63),
      description: 'Magical unicorns & rainbows',
    ),
    Category(
      id: '4',
      name: AppStrings.ocean,
      iconAsset: 'assets/categories/ocean.svg',
      color: const Color(0xFF00BCD4),
      description: 'Whales, Sharks, Dolphins',
    ),
    Category(
      id: '5',
      name: AppStrings.jungle,
      iconAsset: 'assets/categories/jungle.svg',
      color: const Color(0xFF8BC34A),
      description: 'Lions, Monkeys, Elephants',
    ),
    Category(
      id: '6',
      name: AppStrings.fairytale,
      iconAsset: 'assets/categories/fairytale.svg',
      color: const Color(0xFF9C27B0),
      description: 'Castles, Dragons, Princess',
    ),
    Category(
      id: '7',
      name: AppStrings.vehicles,
      iconAsset: 'assets/categories/vehicles.svg',
      color: const Color(0xFFFF9800),
      description: 'Cars, Trucks, Airplanes',
    ),
    Category(
      id: '8',
      name: AppStrings.robots,
      iconAsset: 'assets/categories/robots.svg',
      color: const Color(0xFF795548),
      description: 'Friendly robots & gadgets',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            const HomeHeader(),

            // Categories Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories Title
                    Text(
                      'Popular Categories',
                      style: AppStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select a theme to start creating',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Categories Grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryCard(
                            category: category,
                            isSelected: selectedCategory?.id == category.id,
                            onTap: () {
                              setState(() {
                                if (selectedCategory?.id == category.id) {
                                  selectedCategory = null;
                                } else {
                                  selectedCategory = category;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),

                    // Generate Button
                    if (selectedCategory != null) ...[
                      const SizedBox(height: 20),
                      PrimaryButton(
                        text: 'Generate ${selectedCategory!.name} Drawing',
                        onPressed: () {
                          // Navigate to generate screen
                          _navigateToGenerateScreen(context);
                        },
                        icon: Icons.auto_awesome,
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGenerateScreen(BuildContext context) {
    Navigator.pushNamed(context, '/generate', arguments: selectedCategory);
  }
}
