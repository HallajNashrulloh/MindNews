// import 'package:flutter/material.dart';
// import 'package:tb_ppm/views/login_screen.dart';
// import 'package:tb_ppm/utils/helper.dart';

// class IntroductionScreen extends StatefulWidget {
//   const IntroductionScreen({super.key});

//   @override
//   State<IntroductionScreen> createState() => _IntroductionScreenState();
// }

// class _IntroductionScreenState extends State<IntroductionScreen> {
//   List<Map<String, dynamic>> pageList = [
//     {
//       'imageAssets': 'asset/logo.png',
//       'title': 'The World at Your Fingertips',
//       'subtitle':
//           'Get 24/7 updates on global news – from breaking politics to cultural trends, all in one place',
//     },
//     {
//       'imageAssets': 'asset/images/intro2.png',
//       'title': 'Tailored to Your Curiosity',
//       'subtitle':
//           'Select your interests and receive handpicked stories. Technology, sports, or entertainment – we’ve got you covered',
//     },
//     {
//       'imageAssets': 'asset/images/intro3.png',
//       'title': 'Trusted Updates in Real-Time',
//       'subtitle':
//           'Instant alerts for breaking news, rigorously fact-checked by our editors before they reach you',
//     },
//   ];

//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   void nextPage() {
//     if (_currentPage < pageList.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeIn,
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   void initState() {
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page!.round();
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: cWhite,
//       body: SafeArea(
//         child: Stack(
//           alignment: AlignmentDirectional.topEnd,
//           children: [
//             PageView.builder(
//               controller: _pageController,
//               scrollDirection: Axis.horizontal,
//               itemCount: pageList.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 100),
//                       Image.asset(pageList[index]['imageAssets'], height: 300),
//                       vsLarge,
//                       Text(
//                         pageList[index]['title'],
//                         style: headline4.copyWith(
//                           color: cPrimary,
//                           fontWeight: bold,
//                         ),
//                       ),
//                       vsSmall,
//                       Text(pageList[index]['subtitle'], style: subtitle1),
//                       const Spacer(),
//                       if (_currentPage == pageList.length - 1)
//                         ElevatedButton(
//                           onPressed: nextPage,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: cPrimary,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 50,
//                               vertical: 15,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: const Text(
//                             "Get Started",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: Colors.white,
//                               ),
//                             ),
//                         )
//                       else
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () => Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => const LoginPage(),
//                                     ),
//                                 ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: cTextBlue,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 50,
//                                   vertical: 15,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Skip",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     ),
//                                 ),
//                             ),
//                             /*
//                             TextButton(
//                               onPressed:
//                                   () => Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => const LoginPage(),
//                                     ),
//                                   ),
//                               child: const Text(
//                                   "Skip",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     ),
//                                   ),
//                             ),
//                             */
//                             ElevatedButton(
//                               onPressed: nextPage,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: cPrimary,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 50,
//                                   vertical: 15,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Next",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     ),
//                                 ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }