class DrawerDataModal {
  int id;
  String moduels;
  List<DrawerSubMenu>? drawerSubMenu;

  DrawerDataModal(
      {required this.id, required this.moduels, required this.drawerSubMenu});

  factory DrawerDataModal.fromJson(Map<String, dynamic> map) {
    int idD = map['id'];
    String moduelsD = map['moduels'];
    List<DrawerSubMenu>? drawerSubMenuD;

    if (map['DrawerSubMenu'] != null) {
      drawerSubMenuD = <DrawerSubMenu>[];
      (map['DrawerSubMenu'] as List).forEach((e) {
        drawerSubMenuD?.add(DrawerSubMenu.fromJson(e));
      });
    }

    return DrawerDataModal(
        id: idD, moduels: moduelsD, drawerSubMenu: drawerSubMenuD);
  }
}

class DrawerSubMenu {
  final int id;
  final String submodule;

  DrawerSubMenu({required this.id, required this.submodule});

  factory DrawerSubMenu.fromJson(Map<String, dynamic> map) {
    return DrawerSubMenu(id: map['id'], submodule: map['submodule']);
  }
}
