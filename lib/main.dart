import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/home/home_page.dart';
import 'package:recasa/screens/landing/bloc/connect_bloc.dart';
import 'package:recasa/screens/landing/landing_page.dart';
import 'package:recasa/utils/app_strings.dart';

import 'bloc/observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use
  BlocOverrides.runZoned(
    () {
      runApp(const Recasa());
    },
    blocObserver: AppObserver(),
  );
}

class Recasa extends StatelessWidget {
  const Recasa({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ConnectBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        home: const HomePage(),
      ),
    );
  }
}
