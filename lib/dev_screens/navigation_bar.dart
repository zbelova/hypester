import 'package:flutter/material.dart';

class NavigationBar1 extends StatefulWidget {
  const NavigationBar1({Key? key}) : super(key: key);

  @override
  State<NavigationBar1> createState() => _NavigationBar1State();
}

class _NavigationBar1State extends State<NavigationBar1> {
  late int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Избранное',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            switch (index) {
              case 0:
                if (_selectedIndex == 0) {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Поиск',
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        );
                      });
                }
              case 1:
                showFeatured(context);
            }
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }

  void showFeatured(BuildContext context) {}
}
