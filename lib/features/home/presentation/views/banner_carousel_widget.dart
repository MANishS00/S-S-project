// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import '../../data/models/banner_model.dart';
// import '../../data/repositories/banner_repository_impl.dart';

// class BannerCarousel extends StatefulWidget {
//   const BannerCarousel({Key? key}) : super(key: key);

//   @override
//   _BannerCarouselState createState() => _BannerCarouselState();
// }

// class _BannerCarouselState extends State<BannerCarousel> {
//   final CarouselSliderController _controller = CarouselSliderController();
//   int _current = 0;
//   List<BannerModel> _banners = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchBanners();
//   }

//   Future<void> _fetchBanners() async {
//     try {
//       final banners = await BannerRepositoryImpl().fetchBanners();
//       setState(() {
//         _banners = banners;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Column(
//       children: [
//         CarouselSlider(
//           items: _banners.map((banner) {
//             return ClipRRect(
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               borderRadius: BorderRadius.circular(8.0),
//               child: Image.network(
//                 banner.image,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             );
//           }).toList(),
//           carouselController: _controller,
//           options: CarouselOptions(
//             height: 150.0,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 5),
//             aspectRatio: 16 / 9,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _current = index;
//               });
//             },
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: _banners.asMap().entries.map((entry) {
//             return GestureDetector(
//               onTap: () => _controller.animateToPage(entry.key),
//               child: Container(
//                 width: 12.0,
//                 height: 12.0,
//                 margin:
//                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _current == entry.key
//                       ? Colors.orange
//                       : Colors.grey,
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
