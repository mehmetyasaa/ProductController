import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String name;
  final String description;
  final int count;

  const ListTileWidget({
    super.key,
    required this.name,
    required this.description,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Text("${"description".tr()} : ${description}"),
      ),
      trailing: Text(
        "${count}  ${"quantity".tr()}",
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 255, 99, 9)),
      ),
      contentPadding: const EdgeInsets.all(10),
      onTap: () {},
    );
  }
}
