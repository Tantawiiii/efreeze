import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/localization/language_cubit.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/widgets/language_switcher.dart';
import '../../auth/services/auth_service.dart';
import '../cubit/update_profile_cubit.dart';
import '../../contact_us/cubit/contact_us_cubit.dart';
import 'update_profile_tab.dart';
import '../../contact_us/ui/contact_us_tab.dart';

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
              title: Text(AppTexts.updateProfile),
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
              title: Text(AppTexts.contactUs),
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
        title: Text(AppTexts.logout),
        content: Text(AppTexts.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppTexts.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppTexts.logout),
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
    context.watch<LanguageCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(AppTexts.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(AppTexts.language),
            subtitle: Text(AppTexts.changeLanguage),
            trailing: const LanguageSwitcher(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(AppTexts.updateProfile),
            subtitle: Text(AppTexts.editYourInfo),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _openUpdateProfile(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: Text(AppTexts.contactUs),
            subtitle: Text(AppTexts.sendUsMessage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _openContactUs(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(AppTexts.logout),
            subtitle: Text(AppTexts.signOutReturn),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
