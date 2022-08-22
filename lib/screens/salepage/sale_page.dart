import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/salepage/bloc/sale_bloc.dart';
import 'package:recasa/utils/app_colors.dart';

import '../../utils/app_extras.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';

TextEditingController _priceController = TextEditingController();

class SalePage extends StatefulWidget {
  final String nftId;
  const SalePage({Key? key, required this.nftId}) : super(key: key);

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  void initState() {
    BlocProvider.of<SaleBloc>(context).add(GetNFTInfo(widget.nftId, context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CustomAppBar(
        title: AppStrings.salePageTitle,
      ),
      body: Container(
        margin: const EdgeInsets.all(32),
        child: SizedBox(
          height: double.infinity,
          child: BlocBuilder<SaleBloc, SaleState>(
            buildWhen: (previous, current) {
              if (current is NFTForSaleState ||
                  current is NFTForSaleAddedState ||
                  current is NFTForSaleErrorState) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is NFTLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  ),
                );
              }
              if (state is NFTLoadedState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ThumbImage(
                      imageUrl: state.doc.get("nftImage"),
                      tag: state.doc.id,
                    ),
                    const SizedBox(width: 122),
                    InputFields(doc: state.doc),
                  ],
                );
              }
              if (state is NFTLoadErrorState) {
                return Center(
                  child: Text(
                    AppStrings.nftFetchError,
                    style: AppStyles.mediumTextStyleBold,
                  ),
                );
              }
              return Center(
                child: Text(
                  AppStrings.nftFetchError,
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

class InputFields extends StatelessWidget {
  final DocumentSnapshot doc;
  const InputFields({
    Key? key,
    required this.doc,
  }) : super(key: key);

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
            NameText(name: doc.get("nftName") ?? AppStrings.noName),
            const SizedBox(height: 4),
            const ContractText(),
            const SizedBox(height: 4),
            TokenText(
              tokenId: doc.get("tokenId"),
            ),
            const SizedBox(height: 4),
            AmountText(amount: doc.get("nftAmount")),
            const SizedBox(height: 22),
            CustomTextField(
              hintText: AppStrings.priceInput,
              controller: _priceController,
            ),
            const SizedBox(height: 22),
            SaleButton(doc: doc),
            const StateText(),
          ],
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
  const ContractText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Contract: " +
          AppStrings.fractionalizeContractAddress.substring(0, 4) +
          "......" +
          AppStrings.fractionalizeContractAddress.substring(38, 42),
      style: AppStyles.mediumTextStyleBold,
    );
  }
}

class TokenText extends StatelessWidget {
  const TokenText({
    Key? key,
    required this.tokenId,
  }) : super(key: key);

  final String tokenId;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Token ID: " + tokenId,
      style: AppStyles.mediumTextStyleBold,
    );
  }
}

class AmountText extends StatelessWidget {
  const AmountText({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Fractions: " + amount,
      style: AppStyles.mediumTextStyleBold,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class SaleButton extends StatelessWidget {
  final DocumentSnapshot doc;
  const SaleButton({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaleBloc, SaleState>(
      builder: (context, state) {
        if (state is NFTForSaleState || state is NFTForSaleAddedState) {
          return Container();
        }
        return InkWell(
          onTap: () {
            if (_priceController.text.isNotEmpty &&
                _priceController.text != "0") {
              BlocProvider.of<SaleBloc>(context).add(
                AddForSale(doc, _priceController.text, context),
              );
            }
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
              AppStrings.saleButton,
              style: AppStyles.buttonTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class StateText extends StatelessWidget {
  const StateText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleBloc, SaleState>(
      listener: (context, state) {
        if (state is NFTForSaleErrorState) {
          AppExtras.showToast(
            context: context,
            message: AppStrings.saleError,
            bgColor: AppColors.errorColor,
          );
        }
        if (state is NFTForSaleAddedState) {
          AppExtras.showToast(
            context: context,
            message: AppStrings.saleAdded,
            bgColor: AppColors.successColor,
          );
        }
      },
      builder: (context, state) {
        if (state is NFTForSaleState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.addingForSale,
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
        if (state is NFTForSaleAddedState) {
          return Text(
            AppStrings.forSale,
            style: AppStyles.mediumTextStyleBold,
          );
        }
        return Container();
      },
    );
  }
}
