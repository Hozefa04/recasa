import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:recasa/screens/salepage/sale_page.dart';
import 'package:recasa/utils/app_colors.dart';
import 'package:recasa/utils/app_extras.dart';
import 'package:recasa/utils/app_strings.dart';
import 'package:recasa/utils/app_styles.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/nft_image.dart';
import '../../widgets/nft_info.dart';
import '../landing/bloc/connect_bloc.dart';

late String address;

class RecasaNFTPage extends StatefulWidget {
  const RecasaNFTPage({Key? key}) : super(key: key);

  @override
  State<RecasaNFTPage> createState() => _RecasaNFTPageState();
}

class _RecasaNFTPageState extends State<RecasaNFTPage> {
  @override
  void initState() {
    address = BlocProvider.of<ConnectBloc>(context).walletAddress!;

    // Subscribe to `chainChanged` event
    ethereum!.onChainChanged((chainId) {
      chainId; // foo
    });

    // Subscribe to `accountsChanged` event.
    ethereum!.onAccountsChanged((accounts) {
      address = BlocProvider.of<ConnectBloc>(context).walletAddress!;
      setState(() {});
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
      appBar: CustomAppBar(
        title: AppStrings.appBarRecasa
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 32, left: 32, top: 12),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("NFTs")
              .doc(address)
              .collection("RecasaNFTs")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null && snapshot.data!.docs.isEmpty) {
              return Text(
                AppStrings.noRecasaNFTs,
                style: AppStyles.mediumTextStyleBold,
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ),
              );
            }
            return GridView.builder(
              itemCount: snapshot.data?.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 32.0,
                mainAxisSpacing: 32.0,
                childAspectRatio: 2 / 1,
              ),
              itemBuilder: (context, index) {
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
                        image: snapshot.data?.docs[index]['nftImage'],
                        tag: snapshot.data!.docs[index].id,
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
                                name: snapshot.data?.docs[index]['nftName'] ??
                                    AppStrings.noName,
                                value: snapshot.data?.docs[index]
                                        ['nftAmount'] ??
                                    AppStrings.noValue,
                                standard: "",
                              ),
                              StatusView(
                                status: snapshot.data?.docs[index]['status'],
                                nftId: snapshot.data!.docs[index].id,
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
          },
        ),
      ),
    );
  }
}

class StatusView extends StatelessWidget {
  final String status;
  final String nftId;
  const StatusView({
    Key? key,
    required this.status,
    required this.nftId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return status == "Pending"
        ? Center(
            child: Text(
              status,
              style: AppStyles.mediumTextStyleBold,
            ),
          )
        : InkWell(
            onTap: () {
              AppExtras.push(context, SalePage(nftId: nftId));
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
    ;
  }
}
