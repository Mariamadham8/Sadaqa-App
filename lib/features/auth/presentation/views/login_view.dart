import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sadaqa_app/core/router/app_router.dart';
import 'package:sadaqa_app/core/utils/app_colors.dart';
import 'package:sadaqa_app/core/utils/app_fonts.dart';
import 'package:sadaqa_app/core/utils/validators.dart';
import 'package:sadaqa_app/core/widgets/custom_button.dart';
import 'package:sadaqa_app/core/widgets/custom_input_field.dart';
import 'package:sadaqa_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sadaqa_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sadaqa_app/features/auth/presentation/widgets/ordivider.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await context.read<AuthCubit>().signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    await Future.delayed(const Duration(seconds: 2)); // remove when wiring cubit

    setState(() => _isLoading = false);
    context.pushReplacement(AppRouter.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: 'Welcome back 👋',
                  subtitle:
                      'Sign in to continue your sadaqa journey.',
                ),
                const SizedBox(height: 36),

                // ── Email ──────────────────────────────────────────────────
                InputField(
                  controller: _emailController,
                  hint: 'you@example.com',
                  focusNode: _emailFocus,
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                  validator: FieldValidators.email
                ),
                const SizedBox(height: 16),

                // ── Password ───────────────────────────────────────────────
                InputField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  label: 'Password',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _onLoginPressed(),
                  validator: FieldValidators.password
                ),
                const SizedBox(height: 10),

                // ── Forgot password ────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: context.push('/forgot-password')
                    },
                    child: Text('Forgot password?', style: AppTextStyles.bodySmall),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Login button ───────────────────────────────────────────
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      context.pushReplacement(AppRouter.home);
                    }
                  },
                  child: AppButton(
                    label: 'Sign In',
                    isLoading: _isLoading,
                    onPressed: _onLoginPressed,
                  
                  ),
                ),
                const SizedBox(height: 32),

                // ── Divider ────────────────────────────────────────────────
                OrDivider(),
                const SizedBox(height: 28),
        

                // ── Sign up link ───────────────────────────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium,
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () {
                              context.push(AppRouter.kSignupview);
                            },
                            child: Text(
                              'Sign Up',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

