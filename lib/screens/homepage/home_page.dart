import 'package:alchemy_web3/alchemy_web3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:recasa/screens/fractionalize/fractionalize_page.dart';
import 'package:recasa/screens/homepage/bloc/home_bloc.dart';
import 'package:recasa/screens/recasa/recasa_page.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_extras.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:recasa/utils/app_styles.dart';
import '../../widgets/nft_image.dart';
import '../../widgets/nft_info.dart';
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
    BlocProvider.of<HomeBloc>(context).add(LoadNFTs(address));

    // Subscribe to `chainChanged` event
    ethereum!.onChainChanged((chainId) {
      chainId; // foo
    });

    // Subscribe to `accountsChanged` event.
    ethereum!.onAccountsChanged((accounts) {
      BlocProvider.of<ConnectBloc>(context).setAddress = accounts[0];
      BlocProvider.of<HomeBloc>(context).add(LoadNFTs(accounts[0]));
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
      appBar: CustomAppBar(address: address),
      body: const HomeContent(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.address,
  }) : super(key: key);

  final String address;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        AppStrings.appName,
        style: AppStyles.appBarStyle,
      ),
      actions: [
        AppBarWalletAddress(address: address),
        const AppBarRecasaButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarRecasaButton extends StatelessWidget {
  const AppBarRecasaButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppExtras.push(context, const RecasaNFTPage());
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(right: 22),
          child: Text(
            AppStrings.recasaNFTs,
            style: AppStyles.linkTextStyleBold,
          ),
        ),
      ),
    );
  }
}

class AppBarWalletAddress extends StatelessWidget {
  const AppBarWalletAddress({
    Key? key,
    required this.address,
  }) : super(key: key);

  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: AppColors.lightColor,
      ),
      child: AppBarTitle(address: address),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.address,
  }) : super(key: key);

  final String address;

  @override
  Widget build(BuildContext context) {
    return Text(
      address.substring(0, 5) + "...." + address.substring(38),
      style: AppStyles.smallTextStyleBold,
      textAlign: TextAlign.center,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 32, left: 32, top: 12),
      child: BlocBuilder<HomeBloc, HomeState>(
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
                bool isERC721 =
                    state.nfts[index].id.tokenMetadata?.tokenType == "ERC721";
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
                        image: state.nfts[index].media[0].gateway,
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
                              isERC721
                                  ? FractionalizeButton(
                                      nft: state.nfts[index],
                                      imageUrl:
                                          state.nfts[index].media[0].gateway,
                                    )
                                  : Container(),
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
        AppExtras.push(
          context,
          FractionalizePage(
            nft: nft,
            imageUrl: imageUrl,
          ),
        );
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
          style: AppStyles.buttonTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
