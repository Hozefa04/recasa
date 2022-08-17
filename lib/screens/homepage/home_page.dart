import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/homepage/bloc/home_bloc.dart';
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
    BlocProvider.of<HomeBloc>(context).add(LoadNFTs(address));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppStrings.appName,
          style: AppStyles.appBarStyle,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColors.lightColor,
            ),
            child: Text(
              address.substring(0, 5) + "...." + address.substring(38),
              style: AppStyles.smallTextStyleBold,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      body: const HomeContent(),
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
      padding: const EdgeInsets.all(22),
    );
  }
}
