import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task_expense_manager/core/constants/app_enums.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final AppBarType type;
  final PreferredSizeWidget? bottom;
  final String? subtitle;
  final VoidCallback? onBackPressed;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? titleSpacing;
  final bool wrapActionsInContainer;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.type = AppBarType.secondary,
    this.bottom,
    this.subtitle,
    this.onBackPressed,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.titleSpacing,
    this.wrapActionsInContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    switch (type) {
      case AppBarType.primary:
        return _buildPrimaryAppBar(context, isTablet, isDesktop);
      case AppBarType.secondary:
        return _buildSecondaryAppBar(context, isTablet, isDesktop);
      case AppBarType.modal:
        return _buildModalAppBar(context, isTablet, isDesktop);
    }
  }

  AppBar _buildPrimaryAppBar(
      BuildContext context, bool isTablet, bool isDesktop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing ?? (isTablet ? 32 : 16),
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.light,
      leading: leading ??
          (automaticallyImplyLeading ? _buildLeading(context, isTablet) : null),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1E293B).withValues(alpha: 0.95),
                    const Color(0xFF0F172A).withValues(alpha: 0.9),
                  ]
                : [
                    const Color(0xFF4F46E5).withValues(alpha: 0.95),
                    const Color(0xFF3B82F6).withValues(alpha: 0.9),
                  ],
          ),
        ),
      ),
      title: _buildTitle(context, isTablet, isDesktop),
      actions: _buildActions(context, isTablet),
      bottom: bottom,
      toolbarHeight: _getToolbarHeight(isTablet, isDesktop),
    );
  }

  AppBar _buildSecondaryAppBar(
      BuildContext context, bool isTablet, bool isDesktop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFFEFEFE),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing ?? (isTablet ? 32 : 16),
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      leading: leading ??
          (automaticallyImplyLeading ? _buildLeading(context, isTablet) : null),
      title: _buildTitle(context, isTablet, isDesktop),
      actions: _buildActions(context, isTablet),
      bottom: bottom,
      toolbarHeight: _getToolbarHeight(isTablet, isDesktop),
    );
  }

  AppBar _buildModalAppBar(
      BuildContext context, bool isTablet, bool isDesktop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor:
          isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF),
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing ?? (isTablet ? 32 : 16),
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      leading: leading ?? _buildModalLeading(context, isTablet),
      title: _buildTitle(context, isTablet, isDesktop),
      actions: _buildModalActions(context, isTablet),
      bottom: bottom,
      toolbarHeight: _getToolbarHeight(isTablet, isDesktop),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTablet ? 24 : 20),
          topRight: Radius.circular(isTablet ? 24 : 20),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isTablet, bool isDesktop) {
    final titleFontSize = isDesktop ? 22.0 : (isTablet ? 20.0 : 18.0);
    final subtitleFontSize = isDesktop ? 16.0 : (isTablet ? 15.0 : 14.0);
    final isPrimaryAppBar = type == AppBarType.primary;

    final titleColor = isPrimaryAppBar
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

    final subtitleColor = isPrimaryAppBar
        ? Colors.white.withValues(alpha: 0.9)
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);

    if (subtitle != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: titleColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: subtitleFontSize - 2,
                  color: subtitleColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: titleColor,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget? _buildLeading(BuildContext context, bool isTablet) {
    final currentRoute = Get.routing.current;
    final mainRoutes = [
      '/home',
      '/calendar',
      '/budget',
      '/expense',
      '/profile',
      '/'
    ];

    if (mainRoutes.contains(currentRoute) || !Navigator.of(context).canPop()) {
      return null;
    }

    final iconSize = isTablet ? 28.0 : 24.0;
    final isPrimaryAppBar = type == AppBarType.primary;

    return Container(
      margin: EdgeInsets.only(
        left: isTablet ? 16 : 12,
        top: isTablet ? 12 : 8,
        bottom: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: isPrimaryAppBar
            ? Colors.white.withValues(alpha: 0.2)
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
        border: Border.all(
          color: isPrimaryAppBar
              ? Colors.white.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: isPrimaryAppBar
            ? []
            : [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: isTablet ? 12 : 8,
                  offset: Offset(0, isTablet ? 4 : 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
          onTap: () {
            HapticFeedback.lightImpact();
            if (onBackPressed != null) {
              onBackPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: SizedBox(
            width: isTablet ? 48 : 40,
            height: isTablet ? 48 : 40,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: iconSize,
              color: isPrimaryAppBar
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildModalLeading(BuildContext context, bool isTablet) {
    final iconSize = isTablet ? 28.0 : 24.0;

    return Container(
      margin: EdgeInsets.only(
        left: isTablet ? 16 : 12,
        top: isTablet ? 12 : 8,
        bottom: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
          onTap: () {
            HapticFeedback.lightImpact();
            Get.back();
          },
          child: SizedBox(
            width: isTablet ? 48 : 40,
            height: isTablet ? 48 : 40,
            child: Icon(
              Icons.close_rounded,
              size: iconSize,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? _buildActions(BuildContext context, bool isTablet) {
    if (actions == null) return null;

    return actions!.map((action) {
      return Padding(
        padding: EdgeInsets.only(
          right: isTablet ? 16 : 12,
          top: isTablet ? 8 : 4,
          bottom: isTablet ? 8 : 4,
        ),
        child: wrapActionsInContainer && !_isFlexibleWidget(action)
            ? _wrapActionWithContainer(context, action, isTablet)
            : action,
      );
    }).toList();
  }

  bool _isFlexibleWidget(Widget widget) {
    return widget is Obx ||
        widget is Chip ||
        widget is Padding && (widget.child is Chip);
  }

  List<Widget>? _buildModalActions(BuildContext context, bool isTablet) {
    return [
      Padding(
        padding: EdgeInsets.only(
          right: isTablet ? 16 : 12,
          top: isTablet ? 8 : 4,
          bottom: isTablet ? 8 : 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
              onTap: () {
                HapticFeedback.lightImpact();
                Get.back();
              },
              child: SizedBox(
                width: isTablet ? 48 : 40,
                height: isTablet ? 48 : 40,
                child: Icon(
                  Icons.close_rounded,
                  size: isTablet ? 28.0 : 24.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
      if (actions != null) ...actions!,
    ];
  }

  Widget _wrapActionWithContainer(
      BuildContext context, Widget action, bool isTablet) {
    final isPrimaryAppBar = type == AppBarType.primary;

    return Container(
      decoration: BoxDecoration(
        color: isPrimaryAppBar
            ? Colors.white.withValues(alpha: 0.2)
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
        border: Border.all(
          color: isPrimaryAppBar
              ? Colors.white.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: isPrimaryAppBar
            ? []
            : [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: isTablet ? 12 : 8,
                  offset: Offset(0, isTablet ? 4 : 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
        child: SizedBox(
          width: isTablet ? 48 : 40,
          height: isTablet ? 48 : 40,
          child: action,
        ),
      ),
    );
  }

  double _getToolbarHeight(bool isTablet, bool isDesktop) {
    if (isDesktop) return 72;
    if (isTablet) return 64;
    return 56;
  }

  @override
  Size get preferredSize {
    final context = Get.context;
    if (context == null) return Size.fromHeight(56);

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    final toolbarHeight = _getToolbarHeight(isTablet, isDesktop);
    final bottomHeight = bottom?.preferredSize.height ?? 0;

    return Size.fromHeight(toolbarHeight + bottomHeight);
  }
}
