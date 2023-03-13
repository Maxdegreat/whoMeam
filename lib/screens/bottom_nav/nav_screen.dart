import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whomeam/enums/bottom_nav.dart';
import 'package:whomeam/screens/bottom_nav/cubit/bottomnav_cubit.dart';
import 'package:whomeam/screens/bottom_nav/widgets/bottom_nav_bar.dart';
import 'package:whomeam/screens/bottom_nav/widgets/tab_navigator.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => NavScreen()); //buildcontext, animaitons ;
  }

  //navigator keys to maintain current satate across pages

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, Widget> items = const {
    BottomNavItem.feed: Icon(Icons.home, size: 20,),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // sets the ability to pop this stack to false
      child: BlocBuilder<BottomnavCubit, BottomnavState>(
        builder: (context, state) { 
          return Scaffold(
            body: Stack( // the body is a stack the stack of the bottom sheet
              children: items // this is a map, bottomnavitem to icon data
                  .map((item, _) => MapEntry( // this mapping every 
                        item,
                        _buildOffStageNavigator(item, item == state.selectedItem,),
                      ))
                  .values
                  .toList(),
            ),
            bottomNavigationBar: context.read<BottomnavCubit>().state.showBottomNav ? BottomNavBar(
              onTap: (index) {
                final selectedItem = BottomNavItem.values[index];
                _selectBottomNavItem(context, selectedItem, selectedItem == state.selectedItem);
              },
              items: items,
              selectedItem: state.selectedItem,
            ) : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _selectBottomNavItem(
      BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      navigatorKeys[selectedItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomnavCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffStageNavigator(BottomNavItem currentItem, bool isSelected) {
    //only show item that is selected
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }
}
