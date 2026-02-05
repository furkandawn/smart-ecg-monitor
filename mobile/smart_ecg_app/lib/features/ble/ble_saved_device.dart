import 'package:shared_preferences/shared_preferences.dart';

class BleStorage {
  static const _keyId = 'last_device_id';
  static const _keyName = 'last_device_name';
  static const _keyAuto = 'auto_connect_enabled';
  
  static SavedDevice? _cached;
  static SavedDevice? get cached => _cached;
  
  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();
  
  static Future<void> saveDevice(String id, String name, {bool auto = true}) async {
    final p = await _prefs;
    await p.setString(_keyId, id);
    await p.setString(_keyName, name);
    await p.setBool(_keyAuto, auto);
    
    _cached = SavedDevice(id, name, auto);
  }
  
  static Future<void> clearLastDevice() async {
    final p = await _prefs;
    await p.remove(_keyId);
    await p.remove(_keyName);
    await p.remove(_keyAuto);
    
    _cached = null;
  }
  
  static Future<void> setAutoConnect(bool enabled) async {
    final p = await _prefs;
    await p.setBool(_keyAuto, enabled);
    
    if (_cached != null) {
      _cached = SavedDevice(_cached!.id, _cached!.name, enabled);
    }
  }
  
  static Future<SavedDevice?> getLastDevice() async {
    final p = await _prefs;
    final id = p.getString(_keyId);
    final name = p.getString(_keyName);
    
    if (id == null || name == null) {
      _cached = null;
      return null;
    }
    
    final auto = p.getBool(_keyAuto) ?? false;
    _cached = SavedDevice(id, name, auto);
    return _cached;
  }
  
  static Future<void> load() async {
    _cached = await getLastDevice();
  }
}

class SavedDevice {
  final String id;
  final String name;
  final bool autoConnect;
  
  SavedDevice(this.id, this.name, this.autoConnect);
}