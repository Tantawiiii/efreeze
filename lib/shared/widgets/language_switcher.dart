import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant/app_texts.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/language_cubit.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({
    super.key,
    this.showLabel = false,
    this.compact = false,
  });

  final bool showLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        final languageCubit = context.read<LanguageCubit>();
        final currentLanguage = appLanguageFromLocale(locale);
        final textStyle = compact
            ? Theme.of(context).textTheme.bodySmall
            : Theme.of(context).textTheme.bodyMedium;

        final dropdown = DropdownButton<AppLanguage>(
          value: currentLanguage,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.language),
          style: textStyle,
          onChanged: (AppLanguage? language) {
            if (language != null) {
              languageCubit.setLanguage(language);
            }
          },
          items: AppLanguage.values
              .map(
                (language) => DropdownMenuItem<AppLanguage>(
                  value: language,
                  child: Text(
                    language == AppLanguage.ar
                        ? AppTexts.arabic
                        : AppTexts.english,
                    style: textStyle,
                  ),
                ),
              )
              .toList(growable: false),
        );

        if (!showLabel) {
          return dropdown;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTexts.language, style: textStyle),
            const SizedBox(width: 8),
            dropdown,
          ],
        );
      },
    );
  }
}
