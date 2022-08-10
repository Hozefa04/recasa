import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/home/home_page.dart';
import 'package:recasa/screens/landing/bloc/connect_bloc.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_extras.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:recasa/utils/app_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectBloc, ConnectState>(
      listener: (context, state) {
        if (state is WalletConnected) {
          AppExtras.showToast(
            context: context,
            message: AppStrings.connectSuccess,
            bgColor: AppColors.successColor,
          );
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const HomePage()),
          );
        }
        if (state is WalletError) {
          AppExtras.showToast(
            context: context,
            message: AppStrings.connectError,
            bgColor: AppColors.errorColor,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: const LandingContent(),
      ),
    );
  }
}

class LandingContent extends StatelessWidget {
  const LandingContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NFTImage(url: AppStrings.nftImage1),
                  NFTImage(url: AppStrings.nftImage2),
                  NFTImage(url: AppStrings.nftImage3),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NFTImage(url: AppStrings.nftImage4, margin: 8),
                    NFTImage(url: AppStrings.nftImage5, margin: 8),
                    NFTImage(url: AppStrings.nftImage6, margin: 8),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              AppStrings.fracInfoText,
              style: AppStyles.mediumTextStyleBold,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              Text(
                AppStrings.getStarted,
                style: AppStyles.headingStyleBold,
              ),
              const SizedBox(height: 12),
              const ConnectButton(),
              const SizedBox(height: 22),
            ],
          ),
        ],
      ),
    );
  }
}

class ConnectButton extends StatelessWidget {
  const ConnectButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectBloc, ConnectState>(
      builder: (context, state) {
        if (state is WalletConnecting) {
          return Container(
            width: 250,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.secondaryColor,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
              ),
            ),
          );
        }
        return InkWell(
          onTap: () {
            BlocProvider.of<ConnectBloc>(context).add(const ConnectWallet());
          },
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.secondaryColor,
            ),
            child: Text(
              AppStrings.connectButton,
              style: AppStyles.buttonTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class NFTImage extends StatelessWidget {
  final String url;
  final double margin;
  const NFTImage({
    Key? key,
    required this.url,
    this.margin = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 212,
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
