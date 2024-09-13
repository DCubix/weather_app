import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:validators/validators.dart';
import 'package:weather_app/globals.dart';
import 'package:weather_app/providers/auth_provider.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/widgets/basic_responsive.dart';
import 'package:weather_app/widgets/loading.dart';
import 'package:weather_app/widgets/percent_sized_box.dart';
import 'package:weather_app/widgets/sky_background.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(currentUserProvider, (prev, curr) {
      if (curr != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      backgroundColor: colorsNight[0],
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colorsNight,
                stops: const [0.8, 1.0],
              ),
            ),
          ),

          SingleChildScrollView(
            child: BasicResponsive(
              mobile: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 54.0),
                child: _buildLoginScreen(ref, 1.0),
              ),
              tablet: _buildLoginScreen(ref, 0.5),
              desktop: _buildLoginScreen(ref, 0.36),
              desktopHQ: _buildLoginScreen(ref, 0.24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginScreen(WidgetRef ref, double factor) {
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();

    final loading = useState(false);

    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return PercentSizedBox(
          widthFactor: factor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/weather/fair_day.png', width: 80.0),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Weather\nApp',
                    style: TextStyle(
                      fontSize: 36.0,
                      color: cardTextNight,
                      height: 1,
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 32.0),
        
              Card(
                elevation: 0.0,
                color: cardColor(true),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(0.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Login', style: TextStyle(fontSize: 20.0)),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          decoration: inputStyleWhite.copyWith(
                            labelText: 'E-mail',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your e-mail';
                            }
                            if (!isEmail(value)) {
                              return 'Invalid e-mail address';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailCtrl,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          decoration: inputStyleWhite.copyWith(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordCtrl,
                        ),
                        const SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              loading.value = true;
                              await ref.read(authStateNotifierProvider.notifier).login(emailCtrl.text, passwordCtrl.text);
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(context, '/home');
                              }
                              loading.value = false;
                            },
                            icon: loading.value ? null : const Icon(UniconsLine.sign_in_alt),
                            label: loading.value ? const Loading() : const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

}
