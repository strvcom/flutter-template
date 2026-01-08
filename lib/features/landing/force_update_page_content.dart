import 'package:flutter/material.dart';
import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/assets/assets.gen.dart';
import 'package:flutter_app/common/component/custom_button/custom_button_primary.dart';
import 'package:flutter_app/common/component/custom_text/custom_text.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/common/usecase/native_store_open_use_case.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForceUpdatePageContent extends ConsumerWidget {
  const ForceUpdatePageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.imgRocket.svg(width: 200),
              const SizedBox(height: 48),
              CustomText(text: context.locale.forceUpdateTitle, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              CustomText(
                text: context.locale.forceUpdateDescription,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 48),
              if (AppPlatform.isMobile)
                CustomButtonPrimary(
                  onPressed: () {
                    // TODO(strv): Fill correct Android and iOS app IDs
                    ref.read(
                      nativeStoreOpenUseCaseProvider(androidAppBundleId: dotenv.get('APP_ID'), appStoreId: dotenv.get('APPLE_ID')),
                    );
                  },
                  text: context.locale.forceUpdateButton,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
