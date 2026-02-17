import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';
import '../widgets/category_title.dart';


class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    context.read<CategoryBloc>().add(CategoryLoadRequested());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Categorias'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded)),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextField(
                    controller: _controller,
                    onChanged: (q) => context.read<CategoryBloc>().add(CategoryQueryChanged(q)),
                    decoration: const InputDecoration(
                      hintText: 'Buscar productos',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                // Banner "Featured"
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9FFF3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF19C463),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_fire_department, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Buscar productos',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: .6)),
                              SizedBox(height: 4),
                              Text('Cosecha estacional',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w800)),
                              SizedBox(height: 2),
                              Text('Selecciones frescas de agricultores locales',
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: state.visible.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, i) {
                        final cat = state.visible[i];
                        return CategoryTile(
                          item: cat,
                          onTap: () {
                            // Aquí puedes navegar al catálogo filtrado por categoría
                            Navigator.pop(context, cat.name); // devolvemos selección si quieres usarla
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const _BottomNav(selectedIndex: 1),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  const _BottomNav({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        NavigationDestination(icon: Icon(Icons.sell_outlined), label: 'Ventas'),
        NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orden'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
      ],
    );
  }
}