import 'package:customer_portal/Screens/accidentreport.dart';
import 'package:customer_portal/Screens/addnewvehicle.dart';
import 'package:customer_portal/Screens/changepassword.dart';
import 'package:customer_portal/Screens/decision.dart';
import 'package:customer_portal/Screens/digimenu.dart';
import 'package:customer_portal/Screens/digitalinsuarance.dart';
import 'package:customer_portal/Screens/menu.dart';
import 'package:customer_portal/Screens/login.dart';
import 'package:customer_portal/Screens/accidentphotos.dart';
import 'package:customer_portal/Screens/newInspection.dart';
import 'package:customer_portal/Screens/newphotosend.dart';
import 'package:customer_portal/Screens/ownersvehicle.dart';
import 'package:customer_portal/Screens/policyinfo.dart';
import 'package:customer_portal/Screens/register.dart';
import 'package:customer_portal/Screens/stafflogin.dart';
import 'package:customer_portal/Screens/vehicledetails.dart';
import 'package:customer_portal/Screens/vehicleinspection.dart';
import 'package:customer_portal/Screens/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const MyHomePage());
          case '/Login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/decision':
            return MaterialPageRoute(builder: (context) => const Decision());
          case '/Register':
            return MaterialPageRoute(
                builder: (context) => const Registerpage());
          case '/Choises':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => ChoicesPage(nicNumber: args),
              );
            }
            return _errorRoute();
          case '/Policyinfo':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => Policyinfo(nicNumber: args),
              );
            }
            return _errorRoute();
          case '/Ownervehicle':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => Ownervehicle(nicNumber: args),
              );
            }
            return _errorRoute();
          case '/VehicleDetails':
            return MaterialPageRoute(
                builder: (context) => const VehicleDetails());
          case '/Digimenu':
            return MaterialPageRoute(builder: (context) => const Digimenu());
          case '/Digitalinsuarance':
            return MaterialPageRoute(
                builder: (context) => const Digitalinsuarance());
          case '/Addnewvehicle':
            return MaterialPageRoute(
                builder: (context) => const Addnewvehicle());
          case '/NewInspection':
            return MaterialPageRoute(
                builder: (context) => const newvehicleInspec(
                      policyNumber: '',
                      vehicleNumber: '',
                      branchNumber: '',
                      policyType: '',
                    ));
          case '/Inspection':
            return MaterialPageRoute(
                builder: (context) => const VehicleInspec());
          case '/Stafflogin':
            return MaterialPageRoute(
                builder: (context) => const StaffLoginPage());
          case '/newphotosend':
            return MaterialPageRoute(
                builder: (context) => const newphotosend());
          case '/Accident':
            return MaterialPageRoute(
                builder: (context) => const AccidentReport());
          case '/Change':
            return MaterialPageRoute(
                builder: (context) => const ChangePassword());
          case '/onsite':
            return MaterialPageRoute(
                builder: (context) => const OnsiteInspection());
          default:
            return _errorRoute();
        }
      },
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
