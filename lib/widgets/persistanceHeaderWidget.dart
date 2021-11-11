// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final Color backgroundColor;
  final Widget title;

  const CustomHeader(this.backgroundColor, this.title, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true, delegate: Delegate(backgroundColor, title));
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final Widget title;

  Delegate(this.backgroundColor, this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: backgroundColor),
      child: Center(
        child: title,
      ),
    );
  }

  @override
  double get maxExtent => 30;

  @override
  double get minExtent => 20;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
