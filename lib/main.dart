import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sip_calculator/features/sip_calculator/provider/calculation_provider.dart';
import 'package:sip_calculator/features/sip_calculator/provider/saved_plan_provider.dart';
import 'package:sip_calculator/features/sip_calculator/screens/calculation_input.dart';
import 'package:sip_calculator/utils/app_text_styles.dart';
import 'package:sip_calculator/utils/colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ScreenUtilInit(
      designSize: screenSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SipCalculationProvider()),
            ChangeNotifierProvider(create: (_) => SavedPlansProvider()),
            ChangeNotifierProvider(create: (_) => SipGoalTypeProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.backgroundDark,
              textTheme: GoogleFonts.poppinsTextTheme(),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                backgroundColor: AppColors.backgroundDark,
                titleTextStyle: AppTextStyles.bold22,
              ),
            ),
            home: const CalculationInputScreen(),
          ),
        );
      },
    );
  }
}
