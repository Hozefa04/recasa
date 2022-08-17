import 'package:alchemy_web3/alchemy_web3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:recasa/screens/recasa/bloc/recasa_bloc.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_methods.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:recasa/utils/app_styles.dart';
import '../../widgets/nft_image.dart';
import '../../widgets/nft_info.dart';
import '../landing/bloc/connect_bloc.dart';

class RecasaNFTPage extends StatefulWidget {
  const RecasaNFTPage({Key? key}) : super(key: key);

  @override
  State<RecasaNFTPage> createState() => _RecasaNFTPageState();
}

class _RecasaNFTPageState extends State<RecasaNFTPage> {
  late String address;

  @override
  void initState() {
    address = BlocProvider.of<ConnectBloc>(context).walletAddress!;
    BlocProvider.of<RecasaBloc>(context).add(LoadRecasaNFTs(address));

    // Subscribe to `chainChanged` event
    ethereum!.onChainChanged((chainId) {
      chainId; // foo
    });

    // Subscribe to `accountsChanged` event.
    ethereum!.onAccountsChanged((accounts) {
      BlocProvider.of<RecasaBloc>(context).add(LoadRecasaNFTs(accounts[0]));
    });

    // Subscribe to `message` event, need to convert JS message object to dart object.
    ethereum!.on('message', (message) {
      dartify(message); // baz
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const CustomAppBar(),
      body: const HomeContent(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        AppStrings.appBarRecasa,
        style: AppStyles.appBarStyle,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 32, left: 32, top: 12),
      child: BlocBuilder<RecasaBloc, RecasaState>(
        builder: (context, state) {
          if (state is NFTsLoading) {
            return Center(
              child: Column(
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
              ),
            );
          }
          if (state is NFTsLoaded) {
            return GridView.builder(
              itemCount: state.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 32.0,
                mainAxisSpacing: 32.0,
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
                            vertical: 12,
                            horizontal: 4,
                          ),
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
                              ViewButton(
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
          if (state is NFTsError) {
            return Center(
              child: Text(
                AppStrings.NFTFetchError,
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

class ViewButton extends StatelessWidget {
  final EnhancedNFT nft;
  final String imageUrl;
  const ViewButton({
    Key? key,
    required this.nft,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final url =
            AppStrings.openSeaUri + nft.contract.address + "/" + nft.id.tokenId;
        AppMethods.openUrl(url);
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
          AppStrings.viewButton,
          style: AppStyles.mediumTextStyleBold,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
