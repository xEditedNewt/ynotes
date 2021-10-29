import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

///Login change notifier
class LoginController extends ChangeNotifier {
  //Login state
  var _actualState = loginStatus.loggedOff;
  //Login status details
  String _details = "Déconnecté";
  //Error logs
  String logs = "";
  //getters
  final Connectivity _connectivity = Connectivity();

  bool attemptedToRelogin = false;
  LoginController() {
    CustomLogger.log("LOGIN", "Init controller");
    _connectivity.onConnectivityChanged.listen(connectionChanged);
  }

  loginStatus get actualState => _actualState;
  set actualState(loginStatus status) {
    _actualState = status;
    notifyListeners();
  }

  get details => _details;
  set details(details) {
    _details = details;
    notifyListeners();
  }

  void connectionChanged(dynamic hasConnection) async {
    if (hasConnection == ConnectivityResult.none) {
      _actualState = loginStatus.offline;
      _details = "Vous êtes hors ligne";
      notifyListeners();
    } else {
      _actualState = loginStatus.loggedOff;
      _details = "Reconnecté";
      notifyListeners();
      await login();
    }
  }

//on connection change
  init() async {
    CustomLogger.log("LOGIN", "Init connection status");

    if (await _connectivity.checkConnectivity() == ConnectivityResult.none) {
      _actualState = loginStatus.offline;
      _details = "Vous êtes hors ligne";
      notifyListeners();
    }
    if (_actualState != loginStatus.offline && appSys.api!.loggedIn == false) {
      await login();
    } else if (appSys.api!.loggedIn) {
      _details = "Connecté";
      _actualState = loginStatus.loggedIn;
      notifyListeners();
    }
  }

  login() async {
    try {
      _actualState = loginStatus.loggedOff;
      _details = "Connexion à l'API...";
      notifyListeners();
      String? u = await KVS.read(key: "username");
      String? p = await KVS.read(key: "password");
      String? url = await KVS.read(key: "pronoteurl");
      String? cas = await KVS.read(key: "pronotecas");
      bool? iscas = (await KVS.read(key: "ispronotecas") == "true");
      bool? demo = (await KVS.read(key: "demo") == "true");

      var z = await KVS.read(key: "agreedTermsAndConfiguredApp");
      if (u != null && p != null && z != null) {
        await appSys.api!
            .login(u, p, additionnalSettings: {"url": url, "mobileCasLogin": iscas, "cas": cas, "demo": demo}).then(
                (List loginValues) {
          // ignore: unnecessary_null_comparison
          if (loginValues == null) {
            _actualState = loginStatus.loggedOff;
            _details = "Connexion à l'API...";
            notifyListeners();
          }
          if (loginValues[0] == 1) {
            logs = "";
            _details = "Connecté";
            _actualState = loginStatus.loggedIn;
            attemptedToRelogin = false;

            notifyListeners();
          } else {
            CustomLogger.log("LOGIN", "La valeur est : ${loginValues[1]}");
            if (loginValues[1].contains("IP")) {
              _details = "Ban temporaire IP !";
            } else {
              _details = "Erreur de connexion.";
            }

            logs = loginValues[1].toString();
            _actualState = loginStatus.error;
            notifyListeners();
          }
        });
      } else if (!attemptedToRelogin) {
        _details = "Déconnecté";
        _actualState = loginStatus.loggedOff;
        attemptedToRelogin = true;
        await login();
        notifyListeners();
      } else {
        _details = "Erreur de connexion.";
        logs = "Sans détails";
        _actualState = loginStatus.error;
        notifyListeners();
      }
    } catch (e) {
      CustomLogger.error(e);
    }
  }
}

enum loginStatus { loggedIn, loggedOff, offline, error }
