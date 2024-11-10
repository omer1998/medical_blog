
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
class MedCalcPage extends ConsumerStatefulWidget {
  const MedCalcPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MedCalcPageState();
}
class _MedCalcPageState extends ConsumerState<MedCalcPage> {
  final webViewController = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse("https://www.mdcalc.com/calc/43/creatinine-clearance-cockcroft-gault-equation"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedCalc'),
      ),
      body: WebView(
        onWebViewCreated: (WebViewController webViewController) {
          webViewController.loadUrl('https://www.mdcalc.com/calc/43/creatinine-clearance-cockcroft-gault-equation');
        },
      ),
    );
  }
}
