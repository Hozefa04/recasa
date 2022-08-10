import 'package:flutter/material.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:recasa/utils/app_styles.dart';

List<Map<String, String>> NFTData = [
  {
    "name": "NFT #1",
    "description": "This is some static data",
    "image": AppStrings.nftImage1,
    "value": "0.47",
  },
  {
    "name": "NFT #2",
    "description": "This is some static data",
    "image": AppStrings.nftImage2,
    "value": "0.7",
  },
  {
    "name": "NFT #3",
    "description": "This is some static data",
    "image": AppStrings.nftImage3,
    "value": "0.02",
  },
  {
    "name": "NFT #4",
    "description": "This is some static data",
    "image": AppStrings.nftImage4,
    "value": "1.23",
  },
  {
    "name": "NFT #5",
    "description": "This is some static data",
    "image": AppStrings.nftImage5,
    "value": "0.87",
  },
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: const SafeArea(
        child: HomePageContent(),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
      child: Column(
        children: [
          Text(
            AppStrings.yourNft,
            style: AppStyles.headingStyleBold,
          ),
          const SizedBox(height: 12),
          const NFTGrid(),
        ],
      ),
    );
  }
}

class NFTGrid extends StatelessWidget {
  const NFTGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: NFTData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 14.0,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.lightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NFTImage(image: NFTData[index]['image']!),
                NFTInfo(
                  name: NFTData[index]['name']!,
                  value: NFTData[index]['value']!,
                ),
                const FractionalizeButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FractionalizeButton extends StatelessWidget {
  const FractionalizeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondaryColor,
        ),
        child: Text(
          AppStrings.fracButton,
          style: AppStyles.smallTextStyleBold,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class NFTInfo extends StatelessWidget {
  final String name;
  final String value;
  const NFTInfo({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: AppStyles.mediumTextStyleBold,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "⟠ " + value,
              style: AppStyles.smallTextStyleBold,
            ),
          ),
        ],
      ),
    );
  }
}

class NFTImage extends StatelessWidget {
  final String image;
  const NFTImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: SizedBox(
        height: 122,
        width: double.infinity,
        child: Image.network(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
