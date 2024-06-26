import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kaddep_data_capture/authentication/authentication.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

void main() async {
  await AppConfig.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (ctx) => AppCubit(AppState(
              isLoggedIn: false,
              user: null,
              isFirstTimeLoad: AppSettings().isFirstTimeLoad)),
        ),
        BlocProvider<SettingsCubit>(
          create: (ctx) => SettingsCubit(),
        ),
        BlocProvider(
          create: (_) => OGDataEntryListCubit(),
        ),
        BlocProvider(
          create: (_) => ICTDataEntryListCubit(),
        ),
        BlocProvider(
          create: (_) => OfflineRepositoryCubit(OfflineRepositoryState(ictNumRecords: 0, ogNumRecords: 0)),
        )
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            color: Colors.lightGreen,
            theme: ThemeData(primaryColor: Colors.green[900]),
            home: (state.isFirstTimeLoad ?? false)
                ? const OnboardingPage()
                : ((state.isLoggedIn ?? false)
                ? HomePage(key: GlobalKey(),)
                : const LoginPage()),
          );
        },
      ),
    );
  }
}
