import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../data/auth_repository.dart';
import 'signup_page.dart';
import 'catalog_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brandGreen = const Color(0xFF19C463);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (p, c) => p.success != c.success || p.errorMessage != c.errorMessage,
          listener: (context, state) {
            if (state.success) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const CatalogPage()),
                    (route) => false,
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // Logo en caja verde redondeada
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: brandGreen.withOpacity(.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(Icons.shopping_bag_rounded, color: brandGreen, size: 42),
                  ),

                  const SizedBox(height: 16),
                  const Text('AgriMarket',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  Text('Connecting Farm to Table',
                      style: TextStyle(color: brandGreen, fontWeight: FontWeight.w600)),

                  const SizedBox(height: 24),

                  // Email
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email Address',
                        style: TextStyle(
                            color: Colors.black.withOpacity(.75),
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) => context.read<AuthBloc>().add(AuthEmailChanged(v)),
                    decoration: const InputDecoration(
                      hintText: 'yourname@farm.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Password',
                        style: TextStyle(
                            color: Colors.black.withOpacity(.75),
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: !state.passwordVisible,
                    onChanged: (v) => context.read<AuthBloc>().add(AuthPasswordChanged(v)),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => context.read<AuthBloc>().add(AuthTogglePasswordVisibility()),
                        icon: Icon(state.passwordVisible ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: state.submitting
                          ? null
                          : () => context.read<AuthBloc>().add(AuthResetPasswordRequested()),
                      child: const Text('Forgot Password?'),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                        shadowColor: brandGreen.withOpacity(.4),
                      ),
                      onPressed: state.submitting
                          ? null
                          : () => context.read<AuthBloc>().add(AuthSubmitted()),
                      child: state.submitting
                          ? const SizedBox(
                          width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4))
                          : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                  ),

                  // Divider OR
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.black.withOpacity(.1))),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider(color: Colors.black.withOpacity(.1))),
                      ],
                    ),
                  ),

                  // Create Account (outlined)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: brandGreen, width: 1.6),
                        foregroundColor: brandGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final repo = RepositoryProvider.of<AuthRepository>(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RepositoryProvider.value(
                            value: repo,
                            child: BlocProvider(
                              create: (_) => AuthBloc(repository: repo, mode: AuthMode.signup),
                              child: const SignUpPage(),
                            ),
                          ),
                        ));
                      },
                      child: const Text('Create New Account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Imagen inferior (URL)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1599050751797-5b497ef8b590?q=80&w=1200&auto=format&fit=crop',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: const Color(0xFFEFEFEF),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    'By logging in, you agree to our Terms of Service and Privacy Policy for agricultural commerce.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black.withOpacity(.45), fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}