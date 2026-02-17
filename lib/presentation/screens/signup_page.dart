import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import 'catalog_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brandGreen = const Color(0xFF19C463);

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Create Account')),
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
                  const SizedBox(height: 8),
                  Text('AgriMarket',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black.withOpacity(.95))),
                  const SizedBox(height: 4),
                  Text('Welcome! Create your farmer account',
                      style: TextStyle(color: brandGreen, fontWeight: FontWeight.w600)),

                  const SizedBox(height: 24),

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
                      hintText: 'Minimum 6 characters',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => context.read<AuthBloc>().add(AuthTogglePasswordVisibility()),
                        icon: Icon(state.passwordVisible ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                          : const Text('Create Account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                  ),

                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('I already have an account'),
                  ),

                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1516905041604-7935af78fbe0?q=80&w=1200&auto=format&fit=crop',
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}