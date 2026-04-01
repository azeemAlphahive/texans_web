import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:texans_web/routes/app_routes.dart';
import 'package:texans_web/theme/wp_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  runApp(const WebPanelApp());
}

class WebPanelApp extends StatelessWidget {
  const WebPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Admin Panel',
          theme: WpTheme.light(),
          initialRoute: '/',
          getPages: AppPages.pages,
        );
      },
    );
  }
}
