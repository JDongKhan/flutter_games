import 'dart:html';

import 'page_provider.dart';

class PageProviderImpl extends PageProvider {
  @override
  String? getPage() {
    var page = window.location.search ?? '';
    if (page.startsWith('?')) {
      page = page.substring(1);
    }
    return page;
  }
}
