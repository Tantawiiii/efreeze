import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/localization/language_cubit.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/page_transitions.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/widgets/language_switcher.dart';
import '../../../shared/widgets/settings_tile.dart';
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
      fadeSlideRoute(
        page: BlocProvider(
          create: (_) => di.sl<UpdateProfileCubit>(),
          child: Scaffold(
            backgroundColor: AppColors.whiteBackground,
            appBar: AppBar(title: Text(AppTexts.updateProfile)),
            body: const UpdateProfileTab(),
          ),
        ),
      ),
    );
  }

  void _openContactUs(BuildContext context) {
    Navigator.push(
      context,
      fadeSlideRoute(
        page: BlocProvider(
          create: (_) => di.sl<ContactUsCubit>(),
          child: Scaffold(
            backgroundColor: AppColors.whiteBackground,
            appBar: AppBar(title: Text(AppTexts.contactUs)),
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
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            child: Text(AppTexts.logout),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await di.sl<AuthService>().logout();
    } catch (_) {}

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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        title: Text(AppTexts.settings),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 8, bottom: 120),
        children: [
          SettingsTile(
            icon: Icons.account_circle_outlined,
            title: AppTexts.myAccount,
            subtitle: AppTexts.orders,
            onTap: () => Navigator.pushNamed(context, AppRoutes.userInfo),
          ),
          SettingsTile(
            icon: Icons.language_outlined,
            title: AppTexts.language,
            subtitle: AppTexts.changeLanguage,
            trailing: const LanguageSwitcher(),
          ),
          SettingsTile(
            icon: Icons.person_outline,
            title: AppTexts.updateProfile,
            subtitle: AppTexts.editYourInfo,
            onTap: () => _openUpdateProfile(context),
          ),
          SettingsTile(
            icon: Icons.support_agent_outlined,
            title: AppTexts.contactUs,
            subtitle: AppTexts.sendUsMessage,
            onTap: () => _openContactUs(context),
          ),
          SettingsTile(
            icon: Icons.logout_rounded,
            title: AppTexts.logout,
            subtitle: AppTexts.signOutReturn,
            isDestructive: true,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
