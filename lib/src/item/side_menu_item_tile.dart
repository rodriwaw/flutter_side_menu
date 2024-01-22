import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/src/data/side_menu_item_data.dart';
import 'package:flutter_side_menu/src/utils/constants.dart';

class SideMenuItemTile extends StatefulWidget {
  const SideMenuItemTile({
    Key? key,
    required this.isOpen,
    required this.minWidth,
    required this.data,
  }) : super(key: key);
  final SideMenuItemDataTile data;
  final bool isOpen;
  final double minWidth;

  @override
  State<SideMenuItemTile> createState() => _SideMenuItemTileState();
}

class _SideMenuItemTileState extends State<SideMenuItemTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.data.itemList != null ? null : widget.data.itemHeight,
      decoration: ShapeDecoration(
        shape: shape(context),
        color: widget.data.isSelected
            ? widget.data.highlightSelectedColor ??
                Theme.of(context).colorScheme.secondaryContainer
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: shape(context),
        child: InkWell(
          onTap: widget.data.onTap,
          hoverColor: widget.data.hoverColor,
          child: _createView(context: context),
        ),
      ),
    );
  }

  OutlinedBorder shape(BuildContext context) {
    return widget.data.borderRadius != null
        ? RoundedRectangleBorder(borderRadius: widget.data.borderRadius!)
        : Theme.of(context).useMaterial3
            ? const StadiumBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
  }

  Color getSelectedColor() {
    return widget.data.isSelected
        ? widget.data.selectedTitleStyle?.color ??
            Theme.of(context).colorScheme.onSecondaryContainer
        : widget.data.titleStyle?.color ??
            Theme.of(context).colorScheme.onSurfaceVariant;
  }

  Widget? getSelectedIcon() {
    return widget.data.isSelected && widget.data.selectedIcon != null
        ? widget.data.selectedIcon
        : widget.data.icon;
  }

  Widget _createView({
    required BuildContext context,
  }) {
    final content = _hasTooltip(
      child: _content(
        context: context,
      ),
    );

    return content;
  }

  Widget _hasTooltip({
    required Widget child,
  }) {
    if (widget.data.tooltip != null) {
      return Tooltip(
        message: widget.data.tooltip,
        child: child,
      );
    }
    return child;
  }

  Widget _content({
    required BuildContext context,
  }) {
    final hasIcon = widget.data.icon != null;
    final hasTitle = widget.data.title != null;
    final hasExpansionTileList = widget.data.itemList != null;
    if (hasIcon && hasTitle && hasExpansionTileList) {
      return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Wrap(
          alignment: widget.isOpen ? WrapAlignment.start : WrapAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8), child: _icon()),
            if (widget.isOpen) _title(context: context),
          ],
        ),
        children: widget.data.itemList!,
      );
    } else if (hasIcon && hasTitle) {
      return SizedBox(
        width: widget.minWidth - 36,
        child: Wrap(
          alignment: widget.isOpen ? WrapAlignment.start : WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8), child: _icon()),
            if (widget.isOpen) _title(context: context)
          ],
        ),
      );
    } else if (hasIcon) {
      return Align(
        alignment: widget.isOpen ? Alignment.centerLeft : Alignment.center,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8), child: _icon()),
      );
    } else {
      return Container(
        alignment: widget.isOpen ? Alignment.centerLeft : Alignment.center,
        padding: widget.isOpen ? Constants.textStartPadding : null,
        child: _title(context: context),
      );
    }
  }

  Widget _icon() {
    return widget.data.icon != null
        ? SizedBox(
            width: widget.minWidth - widget.data.margin.horizontal - 40,
            child: IconTheme(
              data: Theme.of(context)
                  .iconTheme
                  .copyWith(color: getSelectedColor()),
              child: getSelectedIcon()!,
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _title({
    required BuildContext context,
  }) {
    final TextStyle? titleStyle =
        widget.data.titleStyle ?? Theme.of(context).textTheme.bodyLarge;
    final TextStyle? selectedTitleStyle =
        widget.data.selectedTitleStyle ?? Theme.of(context).textTheme.bodyLarge;
    return AutoSizeText(
      widget.data.title!,
      style: widget.data.isSelected
          ? selectedTitleStyle?.copyWith(color: getSelectedColor())
          : titleStyle?.copyWith(color: getSelectedColor()),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
