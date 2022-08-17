import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class NFTImage extends StatelessWidget {
  final String image;
  final String tag;
  const NFTImage({
    Key? key,
    required this.image,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Hero(
            tag: tag,
            child: Image.network(
              image,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondaryColor,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, exception, stackTrace) {
                return Center(
                  child: Text(
                    '😢',
                    style: AppStyles.mediumTextStyleBold,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
