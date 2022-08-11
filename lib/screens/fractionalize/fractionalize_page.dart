import 'package:alchemy_web3/alchemy_web3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/fractionalize/bloc/fractionalize_bloc.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:recasa/utils/app_styles.dart';
import 'package:recasa/widgets/custom_text_field.dart';

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
      appBar: AppBar(
        title: Text(
          AppStrings.appBarTitle,
          style: AppStyles.mediumTextStyleBold,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FractionalizeContent(imageUrl: imageUrl, nft: nft),
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
      margin: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 22),
          NFTImage(
            imageUrl: imageUrl,
            tag: nft.contract.toString() + nft.id.tokenId.toString(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  NameText(name: nft.title ?? AppStrings.noName),
                  const SizedBox(height: 4),
                  ContractText(nft: nft),
                  const SizedBox(height: 22),
                  CustomTextField(
                    hintText: AppStrings.quantityInput,
                    controller: _fractionsController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  // const SizedBox(height: 22),
                  // CustomTextField(
                  //   hintText: AppStrings.priceInput,
                  // ),
                  const SizedBox(height: 22),
                  CustomTextField(
                    hintText: AppStrings.symbolInput,
                    controller: _symbolController,
                  ),
                  const SizedBox(height: 22),
                  FractionalizeButton(
                    contract: nft.contract.address,
                    tokenId: nft.id.tokenId,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FractionalizeButton extends StatelessWidget {
  final String contract;
  final String tokenId;
  const FractionalizeButton({
    Key? key,
    required this.contract,
    required this.tokenId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<FractionalizeBloc>(context).add(FractionalizeNFT(
          context,
          _fractionsController.text,
          contract,
          tokenId,
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

class NFTImage extends StatelessWidget {
  const NFTImage({
    Key? key,
    required this.tag,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
            width: MediaQuery.of(context).size.width * 0.75,
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
    );
  }
}
