import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/base/base_view_model.dart';

class SettingsViewModel extends BaseViewModel {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  int _dailyWordGoal = 5;

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  bool get soundEnabled => _soundEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  int get dailyWordGoal => _dailyWordGoal;

  // Language options
  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Korean',
    'Chinese'
  ];

  // Daily word goal options
  final List<int> wordGoalOptions = [3, 5, 10, 15, 20, 30];

  Future<void> loadSettings() async {
    setBusy(true);
    try {
      final prefs = await SharedPreferences.getInstance();

      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _dailyWordGoal = prefs.getInt('dailyWordGoal') ?? 5;

      setBusy(false);
    } catch (e) {
      setError('Failed to load settings: ${e.toString()}');
      setBusy(false);
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    try {
      _isDarkMode = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', value);
      notifyListeners();
    } catch (e) {
      setError('Failed to save dark mode setting: ${e.toString()}');
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      _selectedLanguage = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', language);
      notifyListeners();
    } catch (e) {
      setError('Failed to save language setting: ${e.toString()}');
    }
  }

  Future<void> toggleSound(bool value) async {
    try {
      _soundEnabled = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('soundEnabled', value);
      notifyListeners();
    } catch (e) {
      setError('Failed to save sound setting: ${e.toString()}');
    }
  }

  Future<void> toggleNotifications(bool value) async {
    try {
      _notificationsEnabled = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', value);
      notifyListeners();
    } catch (e) {
      setError('Failed to save notifications setting: ${e.toString()}');
    }
  }

  Future<void> setDailyWordGoal(int goal) async {
    try {
      _dailyWordGoal = goal;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dailyWordGoal', goal);
      notifyListeners();
    } catch (e) {
      setError('Failed to save daily word goal: ${e.toString()}');
    }
  }

  Future<void> clearAllData() async {
    setBusy(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Reset to defaults after clearing
      _isDarkMode = false;
      _selectedLanguage = 'English';
      _soundEnabled = true;
      _notificationsEnabled = true;
      _dailyWordGoal = 5;

      setBusy(false);
      notifyListeners();
    } catch (e) {
      setError('Failed to clear data: ${e.toString()}');
      setBusy(false);
    }
  }
}
