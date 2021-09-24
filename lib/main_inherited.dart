import 'package:flutter/material.dart';

import '../bildirim_servisi.dart';

// provider gibi servisi tüm alt widgetlara ulaştırmak amaçlı kullanılır
class MainInherited extends InheritedWidget {
  const MainInherited({
    Key? key,
    required Widget child,
    required this.bildirimServisi,
  }) : super(key: key, child: child);

  final BildirimServisi bildirimServisi;

  static MainInherited of(BuildContext context) {
    final sonuc = context.dependOnInheritedWidgetOfExactType<MainInherited>();

    assert(sonuc != null,
        "buradaki bağlam(context) herhangi bir MainInherited bulamadım");

    return sonuc!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
