import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndPrivacy extends StatefulWidget {
  final String content;
  const TermsAndPrivacy({Key? key, required this.content}) : super(key: key);

  @override
  State<TermsAndPrivacy> createState() => _TermsAndPrivacyState();
}

class _TermsAndPrivacyState extends State<TermsAndPrivacy> {
  bool isPageloaded = false;
  double progress = 0;
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: _onProgress,
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
        ),
      )
      ..loadRequest(Uri.parse(widget.content));
    super.initState();
  }

  void _onPageStarted(String url) {
    setState(() {
      isPageloaded = false;
    });
  }

  void _onPageFinished(String url) {
    setState(() {
      isPageloaded = true;
    });
  }

  void _onProgress(int progress) {
    setState(() {
      this.progress = progress.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.content),
          bottom: !isPageloaded
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : null),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
