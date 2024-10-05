import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hypro/language/language_screen.dart';
import 'package:flutter_hypro/language/storage_service.dart';
import 'package:flutter_hypro/notification_service/notification_service.dart';
import 'package:flutter_hypro/theme/theme_service.dart';
import 'package:flutter_hypro/theme/themes.dart';
import 'package:flutter_hypro/view/screens/auth/login_screen.dart';
import 'package:flutter_hypro/view/screens/auth/register_screen.dart';
import 'package:flutter_hypro/view/screens/badges/badges_screen.dart';
import 'package:flutter_hypro/view/screens/deposit/deposit_screen.dart';
import 'package:flutter_hypro/view/screens/history/deposit_history_screen.dart';
import 'package:flutter_hypro/view/screens/history/invest_history_screen.dart';
import 'package:flutter_hypro/view/screens/history/payout_history_screen.dart';
import 'package:flutter_hypro/view/screens/menu/address_verification_screen.dart';
import 'package:flutter_hypro/view/screens/menu/change_password_screen.dart';
import 'package:flutter_hypro/view/screens/menu/edit_account_screen.dart';
import 'package:flutter_hypro/view/screens/menu/identity_verification_screen.dart';
import 'package:flutter_hypro/view/screens/menu/two_fa_screen.dart';
import 'package:flutter_hypro/view/screens/notification/notification_screen.dart';
import 'package:flutter_hypro/view/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_hypro/view/screens/payout/payout_screen.dart';
import 'package:flutter_hypro/view/screens/plan/plan_screen.dart';
import 'package:flutter_hypro/view/screens/referral/referral_bonus_screen.dart';
import 'package:flutter_hypro/view/screens/referral/referral_screen.dart';
import 'package:flutter_hypro/view/screens/splash/splash_screen.dart';
import 'package:flutter_hypro/view/screens/support/create_ticket_screen.dart';
import 'package:flutter_hypro/view/screens/support/ticket_view_reply_screen.dart';
import 'package:flutter_hypro/view/screens/transfer/transfer_screen.dart';
import 'package:flutter_hypro/view/verify_required/mail_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/sms_verification_screen.dart';
import 'package:flutter_hypro/view/verify_required/two_factor_verification_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'di_container.dart' as di;
import 'view/screens/bottomnavbar/bottom_navbar.dart';
import 'view/screens/dashboard/dashboard_sreen.dart';
import 'view/screens/support/support_ticket_screen.dart';

dynamic storage;

NotificationService notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     'pk_test_51NayeVFRHqwLPZjY8Eu3S8mR4jzXoSt486Vtx1eOLENOMujlBoBzvY4DVVL5QZABDUR0CrQJcgAMyor7ea1StKFT00OcHIehid';
  // await Stripe.instance.applySettings();

  notificationService.initialiseNotification();

  await di.init();

  await initialConfig();
  //initialize
  storage = Get.find<StorageService>();

  await GetStorage.init();

  runApp(const MyApp());
}

initialConfig() async {
  await Get.putAsync(() => StorageService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //For stop rotating the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black12,
    ));
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: Themes().darkTheme,
            theme: Themes().lightTheme,
            themeMode: ThemeService().getThemeMode(),
            title: 'Hyip Pro',
            initialRoute: SplashScreen.routeName,
            getPages: [
              GetPage(name: SplashScreen.routeName, page: () => SplashScreen()),
              GetPage(
                  name: OnboardingScreen.routeName,
                  page: () => OnboardingScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: LoginScreen.routeName,
                  page: () => LoginScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: RegisterScreen.routeName,
                  page: () => RegisterScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: DashBoardScreen.routeName,
                  page: () => DashBoardScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: BottomNavBar.routeName,
                  page: () => BottomNavBar(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: InvestHistoryScreen.routeName,
                  page: () => InvestHistoryScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: DepositScreen.routeName,
                  page: () => DepositScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: PlanScreen.routeName,
                  page: () => PlanScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: BadgesScreen.routeName,
                  page: () => BadgesScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: ChangePasswordScreen.routeName,
                  page: () => ChangePasswordScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: EditAccountScreen.routeName,
                  page: () => EditAccountScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: TwoFaScreen.routeName,
                  page: () => TwoFaScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: ReferralBonusScreen.routeName,
                  page: () => ReferralBonusScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: PayoutScreen.routeName,
                  page: () => PayoutScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: ReferralScreen.routeName,
                  page: () => ReferralScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: DepositHistoryScreen.routeName,
                  page: () => DepositHistoryScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: PayoutHistoryScreen.routeName,
                  page: () => PayoutHistoryScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: SupportTicketScreen.routeName,
                  page: () => SupportTicketScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: CreateNewTicketScreen.routeName,
                  page: () => CreateNewTicketScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: TicketViewReplyScreen.routeName,
                  page: () => TicketViewReplyScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: AddressVerificationScreen.routeName,
                  page: () => AddressVerificationScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: IdentityVerificationScreen.routeName,
                  page: () => IdentityVerificationScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: NotificationScreen.routeName,
                  page: () => NotificationScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: LanguageScreen.routeName,
                  page: () => LanguageScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: TransferScreen.routeName,
                  page: () => TransferScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: MailVerificationScreen.routeName,
                  page: () => MailVerificationScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: TwoFactorVerificationScreen.routeName,
                  page: () => TwoFactorVerificationScreen(),
                  transition: Transition.fadeIn),
              GetPage(
                  name: SmsVerificationScreen.routeName,
                  page: () => SmsVerificationScreen(),
                  transition: Transition.fadeIn),
            ],
          );
        });
  }
}
