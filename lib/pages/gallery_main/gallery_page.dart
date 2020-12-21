import 'package:fehviewer/models/index.dart';
import 'package:fehviewer/pages/gallery_main/controller/gallery_page_controller.dart';
import 'package:fehviewer/pages/gallery_main/gallery_widget.dart';
import 'package:fehviewer/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

const double kHeaderHeight = 200.0 + 52;
const double kPadding = 12.0;
const double kHeaderPaddingTop = 12.0;

class GalleryPage extends GetView<GalleryPageController> {
  @override
  Widget build(BuildContext context) {
    final GalleryItem _item = controller.galleryItem;
    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          // 导航栏
          Obx(() => CupertinoSliverNavigationBar(
                largeTitle: Text(
                  controller.topTitle,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                middle: controller.hideNavigationBtn
                    ? null
                    : NavigationBarImage(
                        imageUrl: _item.imgUrl,
                        scrollController: controller.scrollController,
                      ),
                trailing: controller.hideNavigationBtn
                    ? CupertinoButton(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        minSize: 0,
                        child: const Icon(
                          FontAwesomeIcons.share,
                          size: 26,
                        ),
                        onPressed: () {
                          logger.v('share ${_item.url}');
                          Share.share(' ${_item.url}');
                        },
                      )
                    : const ReadButton(),
              )),
          CupertinoSliverRefreshControl(
            onRefresh: controller.handOnRefresh,
          ),
          SliverSafeArea(
            top: false,
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  // 内容
                  GalleryContainer(
                    galleryItem: controller.galleryItem,
                    tabIndex: controller.tabIndex,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 导航栏封面小图
class NavigationBarImage extends StatelessWidget {
  const NavigationBarImage({
    Key key,
    @required this.imageUrl,
    @required this.scrollController,
  }) : super(key: key);

  final String imageUrl;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(Get.context).padding.top;
    return GestureDetector(
      onTap: () {
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      },
      child: Container(
        child: CoveTinyImage(
          imgUrl: imageUrl,
          statusBarHeight: _statusBarHeight,
        ),
      ),
    );
  }
}

// 画廊内容
class GalleryContainer extends GetView<GalleryPageController> {
  const GalleryContainer({Key key, @required this.galleryItem, this.tabIndex})
      : super(key: key);
  final GalleryItem galleryItem;
  final Object tabIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GalleryHeader(
            galleryItem: galleryItem,
            tabIndex: tabIndex,
          ),
          Divider(
            height: 0.5,
            color: CupertinoDynamicColor.resolve(
                CupertinoColors.systemGrey4, context),
          ),
          controller.obx(
            (GalleryItem state) {
              return Column(
                children: <Widget>[
                  // 标签
                  TagBox(listTagGroup: state.tagGroup),
                  TopComment(comment: state.galleryComment),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 0.5,
                    color: CupertinoDynamicColor.resolve(
                        CupertinoColors.systemGrey4, context),
                  ),
                  PreviewGrid(previews: controller.firstPagePreview),
                  MorePreviewButton(hasMorePreview: controller.hasMorePreview),
                ],
              );
            },
            onLoading: Container(
              // height: Get.size.height - _top * 3 - kHeaderHeight,
              height: 200,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 50),
              child: const CupertinoActivityIndicator(
                radius: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
