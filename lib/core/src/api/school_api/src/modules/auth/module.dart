part of school_api;

abstract class AuthModule<R extends AuthRepository> extends Module<R> {
  static const String _credentialsKey = "credentials";

  AuthStatus status = AuthStatus.unauthenticated;

  final Connectivity _connectivity = Connectivity();
  String details = "Déconnecté";

  String? logs;

  AuthModule({required R repository, required SchoolApi api})
      : super(isSupported: true, isAvailable: true, repository: repository, api: api) {
    _connectivity.onConnectivityChanged.listen(_checkConnectivity);
  }

  AppAccount? get account => _Storage.values.appAccountId == null
      ? null
      : offline.appAccounts.filter().entityIdEqualTo(_Storage.values.appAccountId!).findFirstSync();

  YTColor get color {
    switch (status) {
      case AuthStatus.authenticated:
        return theme.colors.success;
      case AuthStatus.unauthenticated:
        return theme.colors.secondary;
      case AuthStatus.error:
        return theme.colors.danger;
      case AuthStatus.offline:
        return theme.colors.warning;
    }
  }

  Widget get icon {
    switch (status) {
      case AuthStatus.authenticated:
        return Icon(Icons.check_rounded, color: color.foregroundColor);
      case AuthStatus.unauthenticated:
        return SpinKitThreeBounce(color: color.foregroundColor);
      case AuthStatus.error:
        return Icon(Icons.new_releases_rounded, color: color.foregroundColor);
      case AuthStatus.offline:
        return Icon(MdiIcons.networkStrengthOff, color: color.foregroundColor);
    }
  }

  SchoolAccount? get schoolAccount => _Storage.values.schoolAccountId == null
      ? null
      : offline.schoolAccounts.filter().entityIdEqualTo(_Storage.values.schoolAccountId!).findFirstSync();

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    return Response();
  }

  Future<Response<Map<String, dynamic>>> getCredentials() async {
    final String? data = await KVS.read(key: _credentialsKey);
    if (data == null) {
      return Response(error: "No credentials found");
    }
    return Response(data: json.decode(data));
  }

  Future<Response<String>> login(
      {required String username, required String password, Map<String, dynamic>? parameters}) async {
    final res = await repository.login(username: username, password: password, parameters: parameters);
    if (res.hasError) {
      status = AuthStatus.error;
      details = "Erreur de connexion";
      logs = res.error;
      notifyListeners();
      return Response(error: res.error);
    }
    try {
      await setCredentials({"username": username, "password": password, "parameters": parameters});
      status = AuthStatus.authenticated;
      details = "Connecté";
      logs = null;
      notifyListeners();
      final AppAccount account = res.data!["appAccount"];
      final SchoolAccount schoolAccount = res.data!["schoolAccount"];
      await offline.writeTxn((isar) async {
        await isar.appAccounts.put(account);
        await account.accounts.save();
        await isar.schoolAccounts.put(schoolAccount);
      });
      _Storage.values.appAccountId = account.entityId;
      _Storage.values.schoolAccountId = schoolAccount.entityId;
      await _Storage.update();
      notifyListeners();
      return Response(data: "Bienvenue ${account.fullName}");
    } catch (e) {
      return Response(error: "Impossible d'initialiser le compte $e");
    }
  }

  Future<void> loginFromOffline() async {
    final credentials = await getCredentials();
    if (credentials.hasError) {
      // Erreur de connexion
      status = AuthStatus.error;
      details = "Erreur de connexion";
      logs = credentials.error;
      notifyListeners();
      return;
    }
    final creds = credentials.data!;
    await login(username: creds["username"], password: creds["password"], parameters: creds["parameters"]);
  }

  @override
  Future<void> reset() async {
    _Storage.values.appAccountId = null;
    _Storage.values.schoolAccountId = null;
    await _Storage.update();
    notifyListeners();
  }

  Future<void> setCredentials(Map<String, dynamic> credentials) async {
    await KVS.write(key: _credentialsKey, value: json.encode(credentials));
  }

  Future<void> update(SchoolAccount account) async {
    _Storage.values.schoolAccountId = account.entityId;
    await _Storage.update();
  }

  Future<void> _checkConnectivity(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.none:
        status = AuthStatus.offline;
        details = "Hors ligne";
        logs = null;
        notifyListeners();
        break;
      default:
        // Reconnecté
        status = AuthStatus.unauthenticated;
        details = "Reconnecté";
        logs = null;
        notifyListeners();
        await loginFromOffline();
        break;
    }
  }

  @override
  Future<void> _init() async {
    await super._init();
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    await _checkConnectivity(result);
  }
}

enum AuthStatus { authenticated, unauthenticated, offline, error }
