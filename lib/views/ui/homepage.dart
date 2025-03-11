import 'package:construction_store_mobile_app/views/shared/export_packages.dart';
import 'package:construction_store_mobile_app/views/shared/export.dart';
import 'package:construction_store_mobile_app/views/shared/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    var productNotifier = Provider.of<ProductNotifier>(context);
    var favoritesNotifier = Provider.of<FavoritesNotifier>(context);

    favoritesNotifier.getFavorites();
    productNotifier.getRuuvit();
    productNotifier.getPultit();
    productNotifier.getMutterit();

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: 812.h,
        width: 375.w,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 45.h, 0, 0),
              height: 325.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bgtest.webp",
                  ), //add link to background image
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 8.w, bottom: 15.h),
                width: 375.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reusableText(
                      text: "Raksatavarakauppa",
                      style: appstyleWithHeight(
                        32,
                        Colors.white,
                        FontWeight.bold,
                        1.5,
                      ),
                    ),
                    reusableText(
                      text: "Tavaraperkele Oy",
                      style: appstyleWithHeight(
                        20,
                        Colors.white,
                        FontWeight.bold,
                        1.2,
                      ),
                    ),

                    TabBar(
                      padding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.white,
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      labelStyle: appstyle(24, Colors.black, FontWeight.bold),
                      unselectedLabelColor: Colors.white.withOpacity(0.6),

                      tabs: const [
                        Tab(text: "Ruuveja"),
                        Tab(text: "Pultteja"),
                        Tab(text: "Muttereita"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 203.h),
              child: Container(
                padding: EdgeInsets.only(left: 12.w),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    HomeWidget(
                      ruuvit: productNotifier.ruuvit,
                      tabIndex: _tabController.index,
                    ),
                    HomeWidget(
                      ruuvit: productNotifier.pultit,
                      tabIndex: _tabController.index,
                    ),
                    HomeWidget(
                      ruuvit: productNotifier.mutterit,
                      tabIndex: _tabController.index,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
