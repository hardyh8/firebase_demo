import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/onboarding/domain/bloc/auth_bloc.dart';
import 'firebase_options.dart';
import 'routing/router.dart';
import 'routing/router_helper.dart';
import 'routing/routes.dart';
import 'utils/get_it_instance.dart';
import 'utils/logger.dart';
import 'utils/widgets/custom_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  } on Exception catch (e) {
    logger.d('Exception $e');
  }
  initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is SignOutFailure) {
                  CustomSnackbar.showSnackbar(
                    context: context,
                    message: 'Failed ${state.reason}',
                    type: SnackbarType.error,
                  );
                } else if (state is SignOutSuccess) {
                  CustomSnackbar.showSnackbar(
                    context: context,
                    message: 'Signout Success!',
                    type: SnackbarType.sucess,
                  );
                  RouterHelper.go(context, AppRoutes.signin.name);
                }
              },
              builder: (context, state) {
                if (state is SignOutLoading) {
                  return const CircularProgressIndicator();
                }
                return const Text(
                  'You have pushed the button this many times:',
                );
              },
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(OnSignOut());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
