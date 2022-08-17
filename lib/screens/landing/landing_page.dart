import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/homepage/home_page.dart';
import 'package:recasa/screens/landing/bloc/connect_bloc.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_extras.dart';
import 'package:recasa/utils/app_strings.dart';
import 'dart:math' as math;

import 'package:recasa/utils/app_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: BlocListener<ConnectBloc, ConnectState>(
        listener: (context, state) {
          if (state is WalletConnected) {
            AppExtras.replace(context, const HomePage());
            AppExtras.showToast(
              context: context,
              message: AppStrings.walletConnected,
              bgColor: AppColors.successColor,
            );
          }
          if (state is WalletError) {
            AppExtras.showToast(
              context: context,
              message: AppStrings.walletError,
              bgColor: AppColors.errorColor,
            );
          }
        },
        child: const LandingContent(),
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
    return Stack(
      clipBehavior: Clip.none,
      children: const [
        ImageGrid(),
        OpacityContainer(),
        ConnectRow(),
      ],
    );
  }
}

class ConnectRow extends StatelessWidget {
  const ConnectRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppStrings.appName,
                  style: AppStyles.bigHeading,
                ),
              ),
              const SizedBox(height: 42),
              SizedBox(
                width: 442,
                child: Text(
                  AppStrings.fracInfoText,
                  style: AppStyles.headingStyleBold,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: InkWell(
              onTap: () {
                BlocProvider.of<ConnectBloc>(context)
                    .add(const ConnectWallet());
              },
              child: Container(
                width: 220,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppColors.secondaryColor,
                ),
                child: Center(
                  child: Text(
                    AppStrings.connectButton,
                    style: AppStyles.buttonTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OpacityContainer extends StatelessWidget {
  const OpacityContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.5),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  const ImageGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
        childAspectRatio: 1 / 0.7,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ImageWidget(
            image: AppStrings.nftImage1,
            angle: math.pi / 1.2,
          ),
          ImageWidget(
            image: AppStrings.nftImage2,
            angle: math.pi / 20,
          ),
          ImageWidget(
            image: AppStrings.nftImage3,
            angle: math.pi / -10,
          ),
          ImageWidget(
            image: AppStrings.nftImage4,
            angle: math.pi / 0.9,
          ),
          ImageWidget(
            image: AppStrings.nftImage5,
            angle: math.pi / -20,
          ),
          ImageWidget(
            image: AppStrings.nftImage6,
            angle: math.pi / 10,
          ),
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String image;
  final double angle;
  const ImageWidget({
    Key? key,
    required this.image,
    required this.angle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.network(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
