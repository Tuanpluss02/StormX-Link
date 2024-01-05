import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_shortener_flutter/blocs/home/home_cubit.dart';

import '../common/constant.dart';
import '../common/enums.dart';
import '../components/blur_container.dart';
import '../components/custom_text_field.dart';
import '../components/submit_button.dart';
import '../utils/validate_extension.dart';
import 'components/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final longUrlController = TextEditingController();
  final urlCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<HomeCubit>().getHomeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) => _listener(state, context),
      builder: (context, state) {
        return Scaffold(
            body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(bgImage), fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              appBar(size, state),
              const SizedBox(height: 50),
              mainWidget(size, state),
              const SizedBox(height: 50),
              SingleChildScrollView(
                  child: blurContainer(
                      width: size.width * 0.6,
                      child: Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text('Recent URLs',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    fontFamily: 'RobotReavers',
                                  )),
                              const Divider(color: Colors.black87),
                              state.getDataState == GetDataState.loading ||
                                      state.getDataState == GetDataState.initial
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : state.getDataState ==
                                              GetDataState.success &&
                                          state.urls!.isEmpty
                                      ? const Center(
                                          child: Text('No URLs created yet'),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.urls!.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                state.urls![index].longUrl!,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                state.urls![index].urlCode!,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            );
                                          })
                            ],
                          ))))
            ],
          ),
        ));
      },
    );
  }

  Widget mainWidget(Size size, HomeState state) {
    return blurContainer(
        width: size.width * 0.6,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text('URL Shortener',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'RobotReavers',
                    )),
                const SizedBox(height: 30),
                customTextFormField(
                    controller: longUrlController,
                    labelText: 'Long URL',
                    validator: longUrlValidator),
                const SizedBox(height: 20),
                customTextFormField(
                  controller: urlCodeController,
                  labelText: 'URL Code (Optional)',
                ),
                const SizedBox(height: 20),
                submitButton(
                    text: "Shorten",
                    onPressed: _onSubmit,
                    state: urlButtonStateMap[state.urlActionState]!),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  _listener(HomeState state, BuildContext context) {
    debugPrint(state.urlActionState.toString());
    if (state.urlActionState == UrlActionState.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL created successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      longUrlController.clear();
      urlCodeController.clear();
    } else if (state.urlActionState == UrlActionState.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL creation failed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  _onSubmit() {
    if (formKey.currentState!.validate()) {
      context.read<HomeCubit>().createUrl(
          longUrl: longUrlController.text.trim(),
          urlCode: urlCodeController.text.trim());
    }
  }
}
