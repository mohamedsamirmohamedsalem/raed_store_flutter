
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/tab_Item_model.dart';
import 'package:raed_store/widgets/custom_app_bar.dart';

class TabBarMainView extends StatefulWidget {
  const TabBarMainView({Key? key}) : super(key: key);

  @override
  _TabBarMainViewState createState() => _TabBarMainViewState();
}

class _TabBarMainViewState extends State<TabBarMainView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  List<TabItemModel> tabs = [];

  final List<Widget> _homeScreens = [

  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: _homeScreens.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    tabs = [
      TabItemModel(
        iconData: Icons.home_outlined,
        title: "kHome",
      ),
      TabItemModel(
        iconData: Icons.grid_view,
        title: "kCategories",

      ),
      TabItemModel(
        iconData: Icons.shopping_bag_outlined,
        title: "kOrders",
      ),
      TabItemModel(
        iconData: Icons.settings_outlined,
        title: "kSettings",
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: _getAppBar(),
      body: _getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => AppNavigator.pushTo(
      //     context: context,
      //     widget: CartScreen(),
      //   ),
      //   child: Icon(Icons.shopping_basket_outlined, color: Colors.white),
      // ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  AppBar _getAppBar() {
    return  CustomAppBar.getAppBar(tabs[_tabController.index].title);
  }

  Widget _getBody() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: _homeScreens,
    );
  }

  Widget _bottomNavigationBar() {
    return AnimatedBottomNavigationBar.builder(
      height: 60,
      rightCornerRadius: 18,
      leftCornerRadius: 18,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      splashColor: Theme.of(context).splashColor,
      activeIndex: _tabController.index,
      onTap: (index) => setState(() => _tabController.animateTo(index)),
      itemCount: tabs.length,
      tabBuilder: (index, isActive) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tabs[index].iconData,
              color: isActive
                  ? Theme.of(context).accentColor
                  : Theme.of(context).disabledColor,
            ),
            Text(
              tabs[index].title,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? Theme.of(context).accentColor
                    : Theme.of(context).disabledColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
