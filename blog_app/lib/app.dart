import 'package:blog_app/articles_list_tab.dart';
import 'package:blog_app/categories_tab.dart';
import 'package:flutter/cupertino.dart';

import 'profile_tab.dart';

class MyBlogApp extends StatelessWidget {
  const MyBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: CupertinoStoreHomePage(),
    );
  }
}


class CupertinoStoreHomePage extends StatelessWidget {
  const CupertinoStoreHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: ArticlesListTab.title,
            icon: ArticlesListTab.icon,
          ),
          BottomNavigationBarItem(
            label: CategoriesTab.title,
            icon: CategoriesTab.icon,
          ),
          BottomNavigationBarItem(
            label: ProfileTab.title,
            icon: ProfileTab.icon,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: ArticlesListTab.title,
              builder: (context) => const ArticlesListTab(),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: '作品',
              builder: (context) => const CategoriesTab(),
            );
          case 2:
            return CupertinoTabView(
              defaultTitle: '',
              builder: (context) => const ProfileTab(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }
}
