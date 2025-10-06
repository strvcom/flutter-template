import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'external_url_open_use_case.g.dart';

@riverpod
Future<void> externalUrlOpenUseCase(
  Ref ref, {
  required String url,
}) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    return;
  }
}
