import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ArticlesListTab extends StatefulWidget {
  static const title = '文章';
  static const icon = Icon(CupertinoIcons.music_note);
  const ArticlesListTab({Key? key}) : super(key: key);

  @override
  State<ArticlesListTab> createState() => _ArticlesListTabState();
}

class _ArticlesListTabState extends State<ArticlesListTab> {
  static const _itemsLength = 50;
  late List<String> songNames;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  void _setData() {
    // 设置列表数据
  }

  Future<void> _refreshData() {
    return Future.delayed(
      // 发送网络请求
      const Duration(seconds: 2),
      () => setState(() => _setData()),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (index >= _itemsLength) return Container();

    // Show a slightly different color palette. Show poppy-ier colors on iOS
    // due to lighter contrasting bars and tone it down on Android.
    // final color = defaultTargetPlatform == colors[index]

    return SafeArea(
      top: false,
      bottom: false,
      child: Text(
        '这是第$index片文章',
      )
    );
  }

  void _togglePlatform() {
    // if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   debugDefaultTargetPlatformOverride = TargetPlatform.android;
    // } else {
    //   debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    // }
    //
    // // This rebuilds the application. This should obviously never be
    // // done in a real app but it's done here since this app
    // // unrealistically toggles the current platform for demonstration
    // // purposes.
    // WidgetsBinding.instance.reassembleApplication();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _togglePlatform,
            child: const Icon(CupertinoIcons.shuffle),
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: _refreshData,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                _listBuilder,
                childCount: _itemsLength,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
