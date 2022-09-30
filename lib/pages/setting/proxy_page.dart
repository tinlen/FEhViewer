import 'package:fehviewer/common/enum.dart';
import 'package:fehviewer/common/service/ehconfig_service.dart';
import 'package:fehviewer/common/service/theme_service.dart';
import 'package:fehviewer/component/setting_base.dart';
import 'package:fehviewer/fehviewer.dart';
import 'package:fehviewer/pages/setting/webview/mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'setting_items/selector_Item.dart';

class ProxyPage extends StatelessWidget {
  const ProxyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _title = L10n.of(context).proxy;
    final EhConfigService ehConfigService = Get.find();

    return Obx(() {
      return CupertinoPageScaffold(
        backgroundColor: !ehTheme.isDarkMode
            ? CupertinoColors.secondarySystemBackground
            : null,
        navigationBar: CupertinoNavigationBar(
          padding: const EdgeInsetsDirectional.only(start: 0),
          middle: Text(_title),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            child: ListView(
              children: <Widget>[
                _buildProxyTypeItem(context, hideDivider: true),
                const ItemSpace(),
                TextInputItem(
                  title: L10n.of(context).host,
                  textAlign: TextAlign.right,
                  initValue: ehConfigService.proxyHost,
                  onChanged: (val) => ehConfigService.proxyHost = val,
                ),
                TextInputItem(
                  title: L10n.of(context).port,
                  textAlign: TextAlign.right,
                  initValue: ehConfigService.proxyPort.toString(),
                  onChanged: (val) => ehConfigService.proxyPort = int.parse(val),
                  keyboardType: TextInputType.number,
                ),
                TextInputItem(
                  title: L10n.of(context).user_name,
                  textAlign: TextAlign.right,
                  initValue: ehConfigService.proxyUsername,
                  onChanged: (val) => ehConfigService.proxyUsername = val,
                ),
                TextInputItem(
                  title: L10n.of(context).passwd,
                  textAlign: TextAlign.right,
                  initValue: ehConfigService.proxyPassword,
                  onChanged: (val) => ehConfigService.proxyPassword = val,
                  obscureText: true,
                  hideDivider: true,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

Widget _buildProxyTypeItem(BuildContext context, {bool hideDivider = false}) {
  final String _title = L10n.of(context).proxy_type;
  final EhConfigService ehConfigService = Get.find();

  return Obx(() {
    return SelectorItem<ProxyType>(
      title: _title,
      hideDivider: hideDivider,
      actionMap: getProxyTypeModeMap(context),
      initVal: ehConfigService.proxyType,
      onValueChanged: (val) => ehConfigService.proxyType = val,
    );
  });
}