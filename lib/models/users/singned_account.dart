class SignedAccount {
  String? _id;
  String? _username;
  String? _email;
  String? _photoUrl;
  String? _displayName;
  String? _bio;
  DateTime? _timeJoined;
  bool? _isOnline;
  String? _token;

  String? get token => _token;

  set token(String? value) {
    _token = value;
  }

  SignedAccount._privateConstructor();

  static SignedAccount _instance = SignedAccount._privateConstructor();

  factory SignedAccount() {
    return _instance;
  }

  @override
  String toString() {
    return 'account ( $_username )';
  }

  static SignedAccount get instance => _instance;

  static set instance(SignedAccount value) {
    _instance = value;
  }

  DateTime? get timeJoined => _timeJoined;

  set timeJoined(DateTime? value) {
    _timeJoined = value;
  }

  String? get bio => _bio;

  set bio(String? value) {
    _bio = value;
  }

  bool? get isOnline => _isOnline;

  set isOnline(bool? value) {
    _isOnline = value;
  }

  String? get displayName => _displayName;

  set displayName(String? value) {
    _displayName = value;
  }

  String? get photoUrl => _photoUrl;

  set photoUrl(String? value) {
    _photoUrl = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }
}
