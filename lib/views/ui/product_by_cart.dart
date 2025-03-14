import 'package:construction_store_mobile_app/views/shared/export_packages.dart';
import 'package:construction_store_mobile_app/views/shared/export.dart';
import 'package:construction_store_mobile_app/views/shared/category_btn.dart';
import 'package:construction_store_mobile_app/views/shared/custom_spacer.dart';
import 'package:construction_store_mobile_app/views/shared/latest_products.dart';

class ProductByCart extends StatefulWidget {
  const ProductByCart({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<ProductByCart> createState() => _ProductByCartState();
}

class _ProductByCartState extends State<ProductByCart>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    initialIndex: widget.tabIndex,
    length: 3,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _tabController.animateTo(widget.tabIndex, curve: Curves.easeIn);
    final productNotifier = Provider.of<ProductNotifier>(
      context,
      listen: false,
    );
    if (productNotifier.allProducts.isEmpty) {
      productNotifier.fetchAllProducts();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> brand = [
    "assets/images/brand1.webp",
    "assets/images/brand2.webp",
    "assets/images/brand3.webp",
    "assets/images/brand4.webp",
    "assets/images/brand5.webp",
    "assets/images/brand6.webp",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductNotifier>(
      builder: (context, productNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE2E2E2),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16.w, top: 45.h),
                  height: 325.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bgtest.webp"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(6.w, 12.h, 16.w, 18.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Ionicons.close_circle,
                                color: Colors.white,
                                size: 48.h,
                              ),
                            ),
                            GestureDetector(
                              onTap: filter,
                              child: Icon(
                                Ionicons.filter_circle,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ],
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
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.225,
                    left: 16,
                    right: 12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        LatestProducts(products: productNotifier.ruuvitList),
                        LatestProducts(products: productNotifier.pultitList),
                        LatestProducts(products: productNotifier.mutteritList),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> filter() {
    double _value = 100;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white54,
      builder:
          (context) => Container(
            height: 650.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.h),
                topRight: Radius.circular(25.h),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Container(
                  height: 5.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.h)),
                    color: Colors.black38,
                  ),
                ),
                SizedBox(
                  width: 375.w,
                  height: 568.h,
                  child: Column(
                    children: [
                      const CustomSpacer(),
                      Text(
                        "Suodatin",
                        style: appstyle(40, Colors.black, FontWeight.bold),
                      ),
                      const CustomSpacer(),
                      Text(
                        "Tyyppi",
                        style: appstyle(20, Colors.black, FontWeight.bold),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CategoryBtn(
                            label: "Ruuvit",
                            buttonColor: Colors.black,
                          ),
                          CategoryBtn(
                            label: "Pultit",
                            buttonColor: Colors.grey,
                          ),
                          CategoryBtn(
                            label: "Mutterit",
                            buttonColor: Colors.grey,
                          ),
                        ],
                      ),
                      const CustomSpacer(),
                      Text(
                        "Kategoria",
                        style: appstyle(20, Colors.black, FontWeight.w600),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CategoryBtn(
                            label: "Tarvikkeet",
                            buttonColor: Colors.black,
                          ),
                          CategoryBtn(
                            label: "Työkalut",
                            buttonColor: Colors.grey,
                          ),
                          CategoryBtn(label: "Muut", buttonColor: Colors.grey),
                        ],
                      ),
                      const CustomSpacer(),
                      Text(
                        "Hinta",
                        style: appstyle(20, Colors.black, FontWeight.bold),
                      ),
                      const CustomSpacer(),
                      Slider(
                        value: _value,
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey,
                        thumbColor: Colors.black,
                        max: 500,
                        divisions: 50,
                        label: _value.toString(),
                        secondaryTrackValue: 200,
                        onChanged: (double value) {},
                      ),
                      const CustomSpacer(),
                      Text(
                        "Merkki",
                        style: appstyle(20, Colors.black, FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        child: ListView.builder(
                          itemCount: brand.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Image.asset(
                                  brand[index],
                                  height: 60,
                                  width: 80,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
