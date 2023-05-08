import 'package:fireflyai/core/themes/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class SearchResultPageView extends StatefulWidget {
  SearchResultPageView(this.searchSnippet, {this.isUrl, super.key});
  final String searchSnippet;

  /// ---------------------------- if we have received `URL`
  bool? isUrl = false;

  @override
  State<SearchResultPageView> createState() => _SearchResultPageViewState();
}

class _SearchResultPageViewState extends State<SearchResultPageView> {
  //
  late final InAppWebViewController _controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _progress = 0.0.obs;
  final baseUrl = 'https://www.google.com/search?q=';
  PullToRefreshController? _pullToRefreshController;

  @override
  void initState() {
    super.initState();

    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async => _controller.reload(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (await _controller.canGoBack()) {
            _controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: _progress() < 1
                ? PreferredSize(
                    preferredSize: const Size(double.infinity, 10),
                    child: LinearProgressIndicator(
                      value: _progress(),
                      color: ThemeColors.prim1,
                      backgroundColor: ThemeColors.scaffold,
                    ),
                  )
                : null,
          ),
          body: InAppWebView(
            onWebViewCreated: (cntrlr) => _controller = cntrlr,
            pullToRefreshController: _pullToRefreshController,
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                clearCache: true,
              ),
            ),
            initialUrlRequest: URLRequest(
              url: widget.isUrl == null || widget.isUrl == false
                  ? Uri.parse('$baseUrl${widget.searchSnippet.trim()}')
                  : Uri.parse(widget.searchSnippet.trim()),
            ),
            onLoadStop: (controller, url) {
              _pullToRefreshController?.endRefreshing();
            },
            onProgressChanged: (controller, prg) {
              _progress(prg / 100);
              if (prg == 100) {
                _pullToRefreshController?.endRefreshing();
              }
            },
            onLoadError: (_, __, ___, ____) {
              _pullToRefreshController?.endRefreshing();
            },
          ),
        ),
      ),
    );
  }
}
