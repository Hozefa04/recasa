import 'package:alchemy_web3/alchemy_web3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/fractionalize/fractionalize_page.dart';
import 'package:recasa/screens/home/bloc/home_bloc.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:recasa/utils/app_styles.dart';

import '../landing/bloc/connect_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String address;

  @override
  void initState() {
    address = BlocProvider.of<ConnectBloc>(context).walletAddress!;
    // address = "0x8F4cb4272c6AC594553199c4bc42658cFF66E5E1";

    BlocProvider.of<HomeBloc>(context).add(LoadNFTs(address));
    super.initState();
  }

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
        children: const [
          SizedBox(height: 22),
          NFTText(),
          SizedBox(height: 22),
          NFTGrid(),
        ],
      ),
    );
  }
}

class NFTText extends StatelessWidget {
  const NFTText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.yourNft,
      style: AppStyles.headingStyleBold,
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
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is NFTsLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.secondaryColor,
                ),
                const SizedBox(height: 22),
                Text(
                  AppStrings.loadingText,
                  style: AppStyles.mediumTextStyleBold,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          if (state is NFTsLoaded) {
            return GridView.builder(
              itemCount: state.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 22.0,
                childAspectRatio: 2 / 1,
              ),
              itemBuilder: (context, index) {
                late String imageUrl;
                if (state.nfts[index].metadata != null &&
                    state.nfts[index].metadata?.image != null) {
                  if (state.nfts[index].metadata!.image!.contains("ipfs") &&
                      !state.nfts[index].metadata!.image!.contains("gateway")) {
                    String hash =
                        state.nfts[index].metadata!.image!.substring(7);
                    imageUrl = "https://cloudflare-ipfs.com/ipfs/" + hash;
                  } else {
                    imageUrl = state.nfts[index].metadata!.image!;
                  }
                } else {
                  imageUrl = AppStrings.brokenImage;
                }
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NFTImage(
                        image: imageUrl,
                        tag: state.nfts[index].contract.toString() +
                            state.nfts[index].id.tokenId.toString(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NFTInfo(
                                name: state.nfts[index].title ??
                                    AppStrings.noName,
                                value: state.nfts[index].balance ??
                                    AppStrings.noValue,
                                standard: state.nfts[index].id.tokenMetadata
                                        ?.tokenType ??
                                    "Unknown",
                              ),
                              FractionalizeButton(
                                nft: state.nfts[index],
                                imageUrl: imageUrl,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (state is EmptyNFTs) {
            return Center(
              child: Text(
                AppStrings.noNFTs,
                style: AppStyles.mediumTextStyleBold,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.secondaryColor,
            ),
          );
        },
      ),
    );
  }
}

class FractionalizeButton extends StatelessWidget {
  final EnhancedNFT nft;
  final String imageUrl;
  const FractionalizeButton({
    Key? key,
    required this.nft,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FractionalizePage(nft: nft, imageUrl: imageUrl),
        ));
      },
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
            style: AppStyles.smallTextStyleBold,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Owned: " + value,
            style: AppStyles.smallTextStyleBold,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            standard,
            style: AppStyles.smallTextStyleBold,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

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
