import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MedCalcViewPage extends ConsumerStatefulWidget {
  final String title;
  final String url;

  const MedCalcViewPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  ConsumerState<MedCalcViewPage> createState() => _MedCalcViewPageState();
}

class _MedCalcViewPageState extends ConsumerState<MedCalcViewPage> {
  late final WebViewController webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppPallete.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          // onPageFinished: (String url) {
          //   setState(() {
          //     isLoading = false;
          //   });
          // },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              showSnackBar(context, error.description);
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: Text(
          widget.title,
          style: TextStyle(color: AppPallete.whiteColor),
        ),
        iconTheme: IconThemeData(color: AppPallete.whiteColor),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: webViewController),
          if (isLoading)
            Container(
              color: AppPallete.backgroundColor,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppPallete.gradient1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
