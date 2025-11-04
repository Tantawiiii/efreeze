import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/services/auth_service.dart';
import '../cubit/update_profile_cubit.dart';
import '../cubit/contact_us_cubit.dart';
import 'update_profile_tab.dart';
import 'contact_us_tab.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _openUpdateProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => di.sl<UpdateProfileCubit>(),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text('Update Profile'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: const UpdateProfileTab(),
          ),
        ),
      ),
    );
  }

  void _openContactUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => di.sl<ContactUsCubit>(),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text('Contact Us'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: const ContactUsTab(),
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await di.sl<AuthService>().logout();
    } catch (_) {
      // ignore server logout failure
    }

    // Clear local auth
    await di.sl<StorageService>().clearAuthData();
    di.sl<DioClient>().clearAuthToken();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Update Profile'),
            subtitle: const Text('Edit your info'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _openUpdateProfile(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text('Contact Us'),
            subtitle: const Text('Send us a message'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _openContactUs(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            subtitle: const Text('Sign out and return to login'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
