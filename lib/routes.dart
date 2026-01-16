import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/app/user/screens/shop/alert_screen.dart';
import 'package:flutter_application_1/app/user/screens/shop/qr_screen.dart';
import 'package:flutter_application_1/app/user/screens/shop/shop_cart_screen.dart';
import 'package:flutter_application_1/app/user/screens/shop/carrito_screen.dart'
    as shop_carrito;
import 'package:flutter_application_1/app/user/screens/shop/user_screen.dart';
import 'package:flutter_application_1/app/user/screens/login/login_admin/login_admin_screen.dart';
import 'package:flutter_application_1/app/user/screens/login/login_user/login_user_screen.dart'
    as user_login;
import 'package:flutter_application_1/app/user/screens/login/login_user/password_screen.dart';
import 'package:flutter_application_1/app/user/screens/login/login_user/sign_up_user_screen.dart';
import 'package:flutter_application_1/app/user/screens/login/select_user_screen.dart';
import 'package:flutter_application_1/app/user/screens/login/splash_screen.dart';
import 'package:flutter_application_1/app/user/screens/shop/principal_main_screen.dart';
import 'package:flutter_application_1/app/user/screens/dashboard/dashboard.dart';
import 'package:flutter_application_1/app/user/screens/visitante/visitante.dart'
    as visitante;
import 'package:flutter_application_1/app/user/screens/visitante/carrito.dart'
    as carrito_visitante;
import 'package:flutter_application_1/app/user/screens/shop/user_purchase_flow.dart'
    as user_purchase;

Map<String, Widget Function(BuildContext)> routes = {
  "splash": (_) => SplashScreen(),
  "select_user": (_) => SelectScreen(),
  "login": (_) => user_login.LoginScreen(),
  "signup": (_) => SignUpUserScreen(),
  "password": (_) => PasswordScreen(),
  "login_admin": (_) => LoginAdminScreen(),
  "principal": (_) => PrincipalMain(),
  "user": (_) => UserScreen(),
  "shop_cart": (_) => ShopCartScreen(),
  "alert": (_) => AlertScreen(),
  "qr": (_) => QrScreen(),
  "dashboard": (_) => AdminDashboardScreen(),
  "carrito": (_) => const shop_carrito.CarritoScreen(),
  "visitante": (_) => visitante.VisitanteScreen(),
  "carrito_visitante": (_) => const carrito_visitante.CarritoScreen(),
  "login_visitante": (_) => visitante.VisitanteScreen(),
  "carrito_global": (_) => const Text(""),
  // Routes for user purchase flow
  "metodo_pago_user": (_) => const user_purchase.MetodoPagoUserScreen(),
  "pago_tarjeta_user": (_) => const user_purchase.PagoTarjetaUserScreen(),
  "pago_yape_user": (_) => const user_purchase.PagoYapeUserScreen(),
  "pago_efectivo_user": (_) => const user_purchase.PagoEfectivoUserScreen(),
  "finalizar_compra_user": (_) =>
      const user_purchase.FinalizarCompraUserScreen(),
  "notificaciones_user": (_) => const user_purchase.NotificacionesUserScreen(),
  "compra_realizada_user": (_) =>
      const user_purchase.CompraRealizadaUserScreen(),
};
