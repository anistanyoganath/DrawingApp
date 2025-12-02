import 'package:aidrawing/core/constants/app_styles.dart';
import 'package:aidrawing/core/constants/colors.dart';
import 'package:aidrawing/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/setting_tile.dart';
import 'widgets/toggle_option.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoSaveEnabled = true;
  final bool _darkModeEnabled = false;
  final bool _notificationsEnabled = true;
  bool _highQualityEnabled = false;
  bool _kidModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppStyles.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              _buildProfileSection(),

              const SizedBox(height: 32),

              // App Settings
              _buildSectionHeader('App Settings'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    ToggleOption(
                      title: 'Sound Effects',
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() {
                          _soundEnabled = value;
                        });
                      },
                      icon: Icons.volume_up,
                    ),
                    const Divider(height: 1),
                    ToggleOption(
                      title: 'Vibration',
                      value: _vibrationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                      },
                      icon: Icons.vibration,
                    ),
                    const Divider(height: 1),
                    ToggleOption(
                      title: 'Auto-save',
                      subtitle: 'Automatically save your progress',
                      value: _autoSaveEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoSaveEnabled = value;
                        });
                      },
                      icon: Icons.save,
                    ),
                    const Divider(height: 1),
                    ToggleOption(
                      title: 'High Quality',
                      subtitle: 'Better quality but larger files',
                      value: _highQualityEnabled,
                      onChanged: (value) {
                        setState(() {
                          _highQualityEnabled = value;
                        });
                      },
                      icon: Icons.high_quality,
                    ),
                    const Divider(height: 1),
                    ToggleOption(
                      title: 'Kid Mode',
                      subtitle: 'Simpler interface for kids',
                      value: _kidModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _kidModeEnabled = value;
                        });
                      },
                      icon: Icons.child_care,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account
              _buildSectionHeader('Account'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    SettingTile(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      onTap: _editProfile,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.family_restroom,
                      title: 'Family Sharing',
                      onTap: _openFamilySharing,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.subscriptions,
                      title: 'Subscription',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      onTap: _openSubscription,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Support
              _buildSectionHeader('Support'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    SettingTile(
                      icon: Icons.help,
                      title: 'Help & FAQ',
                      onTap: _openHelp,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.contact_support,
                      title: 'Contact Us',
                      onTap: _contactUs,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.rate_review,
                      title: 'Rate App',
                      onTap: _rateApp,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.share,
                      title: 'Share App',
                      onTap: _shareApp,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // About
              _buildSectionHeader('About'),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    SettingTile(
                      icon: Icons.info,
                      title: 'About App',
                      onTap: _openAbout,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: _openPrivacyPolicy,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.description,
                      title: 'Terms of Service',
                      onTap: _openTerms,
                    ),
                    const Divider(height: 1),
                    SettingTile(
                      icon: Icons.update,
                      title: 'App Version',
                      subtitle: 'Version 1.0.0',
                      onTap: _checkForUpdates,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              PrimaryButton(
                text: 'Log Out',
                onPressed: _logout,
                icon: Icons.logout,
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: _deleteAccount,
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
              ),
              child: const Center(
                child: Text('👑', style: TextStyle(fontSize: 32)),
              ),
            ),

            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Super Artist',
                    style: AppStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Premium Member',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatItem('42', 'Drawings'),
                      const SizedBox(width: 16),
                      _buildStatItem('156', 'Colored'),
                      const SizedBox(width: 16),
                      _buildStatItem('12', 'Favorites'),
                    ],
                  ),
                ],
              ),
            ),

            // Edit Button
            IconButton(icon: const Icon(Icons.edit), onPressed: _editProfile),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: AppStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Magic Coloring',
          style: AppStyles.heading3.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.0.0',
          style: AppStyles.bodySmall.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 8),
        Text(
          '© 2024 Magic Coloring App. All rights reserved.',
          style: AppStyles.caption.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.facebook, size: 24),
              onPressed: () {},
              color: AppColors.primary,
            ),
            IconButton(
              icon: Icon(Icons.tiktok, size: 24),
              onPressed: () {},
              color: AppColors.primary,
            ),
            IconButton(
              icon: Icon(Icons.facebook, size: 24),
              onPressed: () {},
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  // Action Methods
  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _openFamilySharing() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Family Sharing...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openSubscription() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, size: 32, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Go Premium',
              style: AppStyles.heading2.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock all features and get unlimited drawings',
              style: AppStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildPlanOption('Monthly', '\$4.99/month', true),
            const SizedBox(height: 12),
            _buildPlanOption('Yearly', '\$29.99/year', false),
            const SizedBox(height: 12),
            _buildPlanOption('Lifetime', '\$99.99', false),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Continue',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subscription activated!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption(String title, String price, bool isRecommended) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRecommended
            ? AppColors.primary.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isRecommended ? AppColors.primary : Colors.grey.shade300,
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRecommended ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: isRecommended ? AppColors.primary : Colors.grey.shade400,
              ),
            ),
            child: isRecommended
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isRecommended
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  price,
                  style: AppStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'RECOMMENDED',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Help & FAQ...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _contactUs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Us'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Email: support@magiccoloring.com'),
            const SizedBox(height: 8),
            const Text('Phone: +1 (555) 123-4567'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Your Message',
                border: OutlineInputBorder(),
                hintText: 'How can we help you?',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message sent! We\'ll respond soon.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redirecting to app store...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing app...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Magic Coloring',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('🎨', style: TextStyle(fontSize: 24))),
      ),
      children: [
        const SizedBox(height: 16),
        const Text(
          'AI-Powered Drawing & Coloring App for Kids',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Create magical drawings with AI and bring them to life with colors!',
          style: AppStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Privacy Policy...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Terms of Service...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking for updates...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
