import 'package:flutter/material.dart';
import 'package:flutter_hypro/utils/colors/app_colors.dart';
import 'package:flutter_hypro/utils/strings/app_constants.dart';
import 'package:flutter_hypro/view/screens/history/deposit_history_screen.dart';
import 'package:flutter_hypro/view/widgets/app_payment_fail.dart';
import 'package:flutter_hypro/view/widgets/app_payment_success.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutWebView extends StatefulWidget {
  final dynamic url;

  const CheckoutWebView({super.key, required this.url});

  @override
  _CheckoutWebViewState createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 25.h,
            color: AppColors.appBlackColor,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appWhiteColor,
        title: Text(
          "Deposit Preview",
          style: GoogleFonts.niramit(
              fontSize: 16.sp, color: AppColors.appBlackColor),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                //transparentBackground: true,
                javaScriptEnabled: true,
                userAgent:
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
              ),
            ),
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url) as WebUri),
            onWebViewCreated: (controller) {
              // WebView is created, set isLoading to true
              setState(() {
                isLoading = true;
              });
            },
            onLoadStart: (controller, url) {
              print("Check>>>${url.toString()}");

              if (url.toString() == '${AppConstants.baseUri}/success') {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DepositHistoryScreen(
                              status: "true",
                            )),
                    (route) => false);
                Get.dialog(AppPaymentSuccess());
              }
              if (url.toString() == '${AppConstants.baseUri}/failed') {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DepositHistoryScreen(
                              status: "true",
                            )),
                    (route) => false);
                Get.dialog(AppPaymentFail());
              }

              setState(() {
                url = Uri.parse(widget.url) as WebUri?;
              });
            },
            onLoadStop: (controller, url) {
              // WebView loading is complete, set isLoading to false
              setState(() {
                isLoading = false;
              });
            },
          ),
          if (isLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            )
        ],
      ),
    );
  }
}
