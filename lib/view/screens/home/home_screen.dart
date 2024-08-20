import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tvst/consts/consts_shelf.dart';
import 'package:tvst/view/shared/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              pageIdx = idx;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).colorScheme.secondary,
          currentIndex: pageIdx,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          iconSize: 30.sp,
          items: [
            _buildNavItem(Icons.home, 'Home'),
            _buildNavItem(Icons.search, 'Search'),
            const BottomNavigationBarItem(
              icon: CustomIcon(),
              label: '',
            ),
            _buildNavItem(Icons.person, 'Profile'),
          ],
        ),
      ),
      body: IndexedStack(
        index: pageIdx,
        children: pages,
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 30.sp),
      activeIcon:
          Icon(icon, size: 30.sp, color: Theme.of(context).primaryColor),
      label: label,
    );
  }
}
