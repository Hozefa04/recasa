import 'package:alchemy_web3/alchemy_web3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/fractionalize/bloc/fractionalize_bloc.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_extras.dart';

import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';

TextEditingController _fractionsController = TextEditingController();
TextEditingController _symbolController = TextEditingController();

class FractionalizePage extends StatelessWidget {
  final EnhancedNFT nft;
  final String imageUrl;

  const FractionalizePage({
    Key? key,
    required this.nft,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: FractionalizeContent(imageUrl: imageUrl, nft: nft),
      appBar: CustomAppBar(
        title: AppStrings.fractionalizeTitle,
      ),
    );
  }
}

class FractionalizeContent extends StatelessWidget {
  final String imageUrl;
  final EnhancedNFT nft;

  const FractionalizeContent({
    Key? key,
    required this.imageUrl,
    required this.nft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: SizedBox(
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThumbImage(
              imageUrl: imageUrl,
              tag: nft.contract.toString() + nft.id.tokenId.toString(),
            ),
            const SizedBox(width: 122),
            InputFields(nft: nft),
          ],
        ),
      ),
    );
  }
}

class InputFields extends StatelessWidget {
  const InputFields({
    Key? key,
    required this.nft,
  }) : super(key: key);

  final EnhancedNFT nft;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            NameText(name: nft.title ?? AppStrings.noName),
            const SizedBox(height: 4),
            ContractText(nft: nft),
            const SizedBox(height: 4),
            TokenText(nft: nft),
            const SizedBox(height: 22),
            CustomTextField(
              hintText: AppStrings.quantityInput,
              controller: _fractionsController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 22),
            FractionalizeButton(
              contract: nft.contract.address,
              tokenId: nft.id.tokenId,
              uri: nft.tokenUri!.raw,
              nft: nft,
            ),
            const StateText(),
          ],
        ),
      ),
    );
  }
}

class FractionalizeButton extends StatelessWidget {
  final String contract;
  final String tokenId;
  final String uri;
  final EnhancedNFT nft;
  const FractionalizeButton({
    Key? key,
    required this.contract,
    required this.tokenId,
    required this.uri,
    required this.nft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FractionalizeBloc, FractionalizeState>(
      builder: (context, state) {
        if (state is FractionalizeFailureState ||
            state is FractionalizationState ||
            state is TransferTokenState ||
            state is WalletErrorState ||
            state is SetApprovalState) {
          return Container();
        }
        return InkWell(
          onTap: () {
            BlocProvider.of<FractionalizeBloc>(context).add(FractionalizeNFT(
              context,
              _fractionsController.text,
              contract,
              tokenId,
              uri,
              nft.media[0].gateway,
              nft.title ?? "",
              nft.description ?? "",
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
              style: AppStyles.buttonTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class ThumbImage extends StatelessWidget {
  const ThumbImage({
    Key? key,
    required this.tag,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 8) {
              Navigator.of(context).pop();
            }
          },
          child: Hero(
            tag: tag,
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width * 0.3,
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

class NameText extends StatelessWidget {
  const NameText({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      "NFT Name: " + name,
      style: AppStyles.nftTitleStyle,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ContractText extends StatelessWidget {
  const ContractText({
    Key? key,
    required this.nft,
  }) : super(key: key);

  final EnhancedNFT nft;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Contract: " +
          nft.contract.address.substring(0, 4) +
          "......" +
          nft.contract.address.substring(38, 42),
      style: AppStyles.mediumTextStyleBold,
    );
  }
}

class TokenText extends StatelessWidget {
  const TokenText({
    Key? key,
    required this.nft,
  }) : super(key: key);

  final EnhancedNFT nft;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Token ID: " +
          int.parse(nft.id.tokenId.substring(2), radix: 16).toString(),
      style: AppStyles.mediumTextStyleBold,
    );
  }
}

class StateText extends StatelessWidget {
  const StateText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FractionalizeBloc, FractionalizeState>(
      listener: (context, state) {
        if (state is FractionalizeFailureState) {
          AppExtras.showToast(
            context: context,
            message: AppStrings.errorState,
            bgColor: AppColors.errorColor,
          );
        }
        if (state is FractionalizeSuccessState) {
          AppExtras.showToast(
            context: context,
            message: AppStrings.successState,
            bgColor: AppColors.successColor,
          );
        }
      },
      builder: (context, state) {
        if (state is TransferTokenState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.tokenTransfer,
                style: AppStyles.mediumTextStyleBold,
              ),
              const SizedBox(width: 32),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          );
        }
        if (state is FractionalizationState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.fractionalizationState,
                style: AppStyles.mediumTextStyleBold,
              ),
              const SizedBox(width: 32),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          );
        }
        if (state is SetApprovalState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.approvalState,
                style: AppStyles.mediumTextStyleBold,
              ),
              const SizedBox(width: 32),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
