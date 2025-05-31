import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iambiz/config/colors.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const BottomNavigation({super.key, required this.navigationShell});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) setState(() => _isVisible = false);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) setState(() => _isVisible = true);
    }
  }

  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is UserScrollNotification) {
                final direction = scrollNotification.direction;
                if (direction == ScrollDirection.reverse && _isVisible) {
                  setState(() => _isVisible = false);
                } else if (direction == ScrollDirection.forward &&
                    !_isVisible) {
                  setState(() => _isVisible = true);
                }
              }
              return false;
            },
            child: PrimaryScrollController(
              controller: _scrollController,
              child: widget.navigationShell,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _isVisible ? Offset.zero : const Offset(0, 2),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 20,
                  ), // antes: 16

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _NavItem(
                        icon: CupertinoIcons.home,
                        label: 'Home',
                        selected: widget.navigationShell.currentIndex == 0,
                        onTap: () => _onItemTapped(0),
                      ),
                      const SizedBox(width: 15),
                      _NavItem(
                        icon: CupertinoIcons.person,
                        label: 'Clientes',
                        selected: widget.navigationShell.currentIndex == 1,
                        onTap: () => _onItemTapped(1),
                      ),
                      const SizedBox(width: 15),
                      _NavItem(
                        icon: CupertinoIcons.archivebox,
                        label: 'Inventario',
                        selected: widget.navigationShell.currentIndex == 2,
                        onTap: () => _onItemTapped(2),
                      ),
                      const SizedBox(width: 15),
                      _NavItem(
                        icon: CupertinoIcons.graph_circle,
                        label: 'Estadisticas',
                        selected: widget.navigationShell.currentIndex == 3,
                        onTap: () => _onItemTapped(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryColor : Colors.grey[500];

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
