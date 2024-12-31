import 'package:flutter/material.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';

class CaseSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final IconData? icon;
  final bool initiallyExpanded;

  const CaseSection({
    Key? key,
    required this.title,
    this.subtitle,
    required this.children,
    this.icon,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppPallete.backgroundColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppPallete.gradient1.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: icon != null
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppPallete.gradient1.withOpacity(0.2),
                      AppPallete.gradient2.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppPallete.gradient1,
                  size: 20,
                ),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppPallete.whiteColor,
            letterSpacing: 0.2,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppPallete.whiteColor.withOpacity(0.6),
                ),
              )
            : null,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppPallete.gradient1.withOpacity(0.05),
                  AppPallete.gradient2.withOpacity(0.02),
                ],
                stops: const [0.0, 1.0],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
