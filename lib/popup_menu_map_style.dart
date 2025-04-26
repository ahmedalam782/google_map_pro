import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PopupMenuMapStyle extends StatelessWidget {
  const PopupMenuMapStyle({
    super.key,
    this.shape,
    this.color,
    required this.items,
    required this.length,
    this.textStyle,
    this.onSelected,
    this.child,
    this.tooltip,
  });
  final ShapeBorder? shape;
  final Color? color;
  final List<String> items;
  final int length;
  final TextStyle? textStyle;
  final void Function(String)? onSelected;
  final Widget? child;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      elevation: 0,
      tooltip: tooltip,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      offset:context.locale.languageCode=='ar'? const Offset(60, -100):Offset(-60, 100),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
      ),
      menuPadding: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              width: 2,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Colors.white,
            ),
          ),
      // position: PopupMenuPosition.under,
      color: color ?? Colors.white,
      onSelected: onSelected,
      itemBuilder: (_) => List.generate(
        length,
        (index) => PopupMenuItem<String>(
          value: items[index],
          child: Text(
            items[index],
            style: textStyle ?? const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
      child: AnimatedContainer(
        height: 60,
        width: 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: child ??
            Icon(
              Icons.layers,
              color: Colors.black,
            ),
      ),
    );
  }
}
