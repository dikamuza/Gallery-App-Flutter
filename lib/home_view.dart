import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'app_bar.dart';
import 'app_controller.dart';
import 'detail_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final AppController homeController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            /// AppBar
            const MyAppBar(),

            /// Main Body
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),

                  /// TabBar
                  Expanded(flex: 1, child: _buildTabBar()),
                  const SizedBox(
                    height: 25,
                  ),

                  /// Pictures
                  Expanded(
                    flex: 13,
                    child: Obx(
                      () => homeController.isLoading.value
                          ? Center(
                              child: LoadingAnimationWidget.flickr(
                                rightDotColor: Colors.black,
                                leftDotColor: const Color(0xfffd0079),
                                size: 30,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.custom(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate: SliverQuiltedGridDelegate(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  repeatPattern:
                                      QuiltedGridRepeatPattern.inverted,
                                  pattern: const [
                                    QuiltedGridTile(2, 2),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 2),
                                  ],
                                ),
                                childrenDelegate: SliverChildBuilderDelegate(
                                    childCount: homeController.photos.length,
                                    (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              DetailsView(index: index),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: homeController.photos[index].id!,
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        child: CachedNetworkImage(
                                          imageUrl: homeController
                                              .photos[index].urls!['small']!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.image_not_supported_rounded,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom TabBar
  Widget _buildTabBar() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: homeController.orders.map((order) {
          int index = homeController.orders.indexOf(order);
          return Obx(
            () => GestureDetector(
              onTap: () {
                homeController.selectedIndex.value = index;
                homeController.ordersFunc(order);
              },
              child: AnimatedContainer(
                margin: EdgeInsets.fromLTRB(index == 0 ? 15 : 5, 0, 5, 0),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(index == homeController.selectedIndex.value ? 15 : 9),
                  ),
                  color: index == homeController.selectedIndex.value
                      ? const Color.fromARGB(255, 216, 1, 105)
                      : Colors.grey,
                ),
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: Text(
                    order,
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
