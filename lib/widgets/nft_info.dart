import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class NFTInfo extends StatelessWidget {
  final String name;
  final String value;
  final String standard;
  const NFTInfo({
    Key? key,
    required this.name,
    required this.value,
    required this.standard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppStyles.mediumTextStyleBold,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Owned: " + value,
            style: AppStyles.mediumTextStyleBold,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            standard,
            style: AppStyles.mediumTextStyleBold,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}