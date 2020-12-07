import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:study_buddy/Screens/MyCoupons.dart';
import './MainScreen/Dashboard.dart';
import './categories_screen.dart';
import 'package:study_buddy/Screens/MainScreen/Dashboard.dart';

import '../app_localizations.dart';

class TabsScreenArguments {
  int selectedTab;
  TabsScreenArguments({
    this.selectedTab,
  });
}

class TabsScreen extends StatelessWidget {
  static const String routeName = '/';
  @override
  Widget build(BuildContext context) {
    String t(String text) => AppLocalizations.of(context).translate(text);
    final TabsScreenArguments args = ModalRoute.of(context).settings.arguments;
    int _intialIndex = args?.selectedTab != null ? args.selectedTab : 1;

    return DefaultTabController(
      length: 3,
      initialIndex: _intialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t('Hi user')),
        ),
        body: TabBarView(
          children: <Widget>[MyCoupons(), Dashboard(), CategoriesScreen()],
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
            // controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(MaterialCommunityIcons.wallet),
                text: t('Wallet'),
              ),
              Tab(
                icon: Icon(MaterialCommunityIcons.clock_outline),
                text: t('Home'),
              ),
              Tab(
                icon: Icon(MaterialCommunityIcons.format_list_bulleted),
                text: t('Categories'),
              )
            ],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
          ),
        ),
      ),
    );
  }
}

// void navigateExample = (){
//   Navigator.pushNamed(context, TabsScreen.routeName,
//         arguments: TabsScreenArguments(
//             selectedTab: 1));
// }
