import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/homepage/bloc/home_bloc.dart';
import 'package:recasa/utils/app_strings.dart';

import 'bloc/observer.dart';
import 'screens/landing/bloc/connect_bloc.dart';
import 'screens/landing/landing_page.dart';

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
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        home: const LandingPage(),
      ),
    );
  }
}
