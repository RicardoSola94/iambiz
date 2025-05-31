import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/presentation/screens/calendar/calendar_task.dart';
import 'package:iambiz/presentation/screens/clientes/details_cliente_screen.dart';
import 'package:iambiz/presentation/screens/clientes/edit_cliente_screen.dart';
import 'package:iambiz/presentation/screens/estadisticas/estadisticas_screen.dart';
import 'package:iambiz/presentation/screens/inventory/inventory_screen.dart';
import 'package:iambiz/presentation/screens/quote/add/add_cliente_quote_screen.dart';
import 'package:iambiz/presentation/screens/quote/add/add_producto_quote_screen.dart';
import 'package:iambiz/presentation/screens/quote/add/add_service_quote_screen.dart';
import 'package:iambiz/presentation/screens/quote/edit/edit_service_quote_screen.dart';
import 'package:iambiz/presentation/screens/quote/quote_details_screen.dart';
import 'package:iambiz/presentation/screens/quote/select/quote_select_client_screen.dart';
import 'package:iambiz/presentation/screens/quote/select/quote_select_products_screen.dart';
import 'package:iambiz/presentation/screens/quote/select/quote_select_service_screen.dart';
import 'package:iambiz/presentation/screens/quote/quote_summary_screen.dart';
import 'package:iambiz/presentation/screens/screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/clientes/clientes_model.dart';
import '../../presentation/screens/quote/edit/edit_cliente_quote_screen.dart'
    show QuoteEditSelectClientScreen;
import '../../presentation/screens/quote/edit/edit_products_quote_screen.dart'
    show QuoteEditSelectProductsScreen;
import '../../presentation/screens/quote/quote_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Ruta de inicio (Onboarding Screen)
      GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clientes',
                builder: (context, state) => const ClientesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                builder: (context, state) => const InventoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/estadisticas',
                builder: (context, state) => const EstadisticasScreen(),
              ),
            ],
          ),
        ],
      ),
      // Rutas para el login y la creación de cuenta
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/create-account',
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: '/add-cliente',
        builder: (context, state) => const AddClienteScreen(),
      ),
      GoRoute(
        path: '/edit-cliente',
        builder: (context, state) {
          final cliente = state.extra as ClienteModel;
          return EditClienteScreen(cliente: cliente);
        },
      ),
      GoRoute(
        path: '/detail-cliente/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ClienteDetailsScreen(id: id);
        },
      ),

      GoRoute(
        path: '/add-inventory',
        builder: (context, state) => const AddInventoryScreen(),
      ),
      GoRoute(
        path: '/quote-cliente',
        builder: (context, state) => const QuoteSelectClientScreen(),
      ),
      GoRoute(
        path: '/quote-cliente-add',
        builder: (context, state) => const AddClienteQuoteScreen(),
      ),
      GoRoute(
        path: '/quote-cliente-edit',
        builder: (context, state) => const QuoteEditSelectClientScreen(),
      ),
      GoRoute(
        path: '/quote-products',
        builder: (context, state) => const QuoteSelectProductsScreen(),
      ),
      GoRoute(
        path: '/quote-producto-add',
        builder: (context, state) => const AddProductoQuoteScreen(),
      ),
      GoRoute(
        path: '/quote-producto-edit',
        builder: (context, state) => const QuoteEditSelectProductsScreen(),
      ),
      GoRoute(
        path: '/quote-service',
        builder: (context, state) => const QuoteSelectServiceScreen(),
      ),
      GoRoute(
        path: '/quote-servicio-add',
        builder: (context, state) => const AddServiceQuoteScreen(),
      ),
      GoRoute(
        path: '/quote-service-edit',
        builder: (context, state) => const QuoteEditSelectServiceScreen(),
      ),
      GoRoute(
        path: '/quote-summary',
        builder: (context, state) => const QuoteSummaryScreen(),
      ),
      GoRoute(
        path: '/quotations',
        builder: (context, state) => const QuotationScreen(),
      ),
      GoRoute(
        path: '/quote-details/:id',
        name: 'quote-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return QuoteDetailsScreen(quotationId: id);
        },
      ),
      GoRoute(
        path: '/calendar-task',
        builder: (context, state) => const CalendarTask(),
      ),
    ],
  );
}
