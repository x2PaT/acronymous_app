import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/screens/boarding_page/boarding_pages/boarding_pages.dart';
import 'package:flutter/material.dart';

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key});

  @override
  State<BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  int pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> boardingPages = [
      BoardPageWelcome(pageController: _pageController, index: pageIndex),
      BoardPageTTS(pageController: _pageController, index: pageIndex),
      BoardPageQuiz(pageController: _pageController, index: pageIndex),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boarding Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
              children: boardingPages,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => GestureDetector(
                onTap: () => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                      ),
                    ],
                    color: pageIndex == index
                        ? AppColors.mainAppColor
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
