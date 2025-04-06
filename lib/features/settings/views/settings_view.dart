import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../viewmodels/settings_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsViewModel>(
      viewModelBuilder: () => locator<SettingsViewModel>(),
      onModelReady: (model) => model.loadSettings(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const Center(child: BusyIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Settings',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            elevation: 0,
          ),
          body: model.hasError
              ? _buildErrorView(context, model)
              : _buildSettingsView(context, model),
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, SettingsViewModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${model.errorMessage}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: model.loadSettings,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView(BuildContext context, SettingsViewModel model) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Appearance section
        _buildSectionHeader(context, 'Appearance'),
        _buildSwitchTile(
          context,
          title: 'Dark Mode',
          subtitle: 'Enable dark theme for the app',
          value: model.isDarkMode,
          onChanged: model.toggleDarkMode,
          icon: Icons.dark_mode,
        ),
        const Divider(),

        // Language section
        _buildSectionHeader(context, 'Language'),
        _buildLanguageSelector(context, model),
        const Divider(),

        // Notifications section
        _buildSectionHeader(context, 'Notifications'),
        _buildSwitchTile(
          context,
          title: 'Push Notifications',
          subtitle: 'Enable notifications for daily reminders',
          value: model.notificationsEnabled,
          onChanged: model.toggleNotifications,
          icon: Icons.notifications,
        ),
        const Divider(),

        // Sound section
        _buildSectionHeader(context, 'Sound'),
        _buildSwitchTile(
          context,
          title: 'Sound Effects',
          subtitle: 'Enable sound for pronunciation and feedback',
          value: model.soundEnabled,
          onChanged: model.toggleSound,
          icon: Icons.volume_up,
        ),
        const Divider(),

        // Learning goals section
        _buildSectionHeader(context, 'Learning Goals'),
        _buildWordGoalSelector(context, model),
        const Divider(),

        // Data section
        _buildSectionHeader(context, 'Data'),
        _buildListTile(
          context,
          title: 'Clear All Data',
          subtitle: 'Reset all settings and clear saved data',
          icon: Icons.delete_forever,
          onTap: () => _showClearDataConfirmation(context, model),
        ),

        // Version info
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
      subtitle: Text(subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
      subtitle: Text(subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsViewModel model) {
    return ListTile(
      leading:
          Icon(Icons.language, color: Theme.of(context).colorScheme.secondary),
      title: const Text('App Language', style: TextStyle(fontSize: 12)),
      subtitle: Text('Currently selected: ${model.selectedLanguage}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showLanguageSelectionDialog(context, model),
    );
  }

  Widget _buildWordGoalSelector(BuildContext context, SettingsViewModel model) {
    return ListTile(
      leading:
          Icon(Icons.task_alt, color: Theme.of(context).colorScheme.secondary),
      title: const Text('Daily Word Goal', style: TextStyle(fontSize: 12)),
      subtitle: Text('${model.dailyWordGoal} words per day',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showWordGoalSelectionDialog(context, model),
    );
  }

  void _showLanguageSelectionDialog(
      BuildContext context, SettingsViewModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.languages.length,
            itemBuilder: (context, index) {
              final language = model.languages[index];
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: model.selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    model.setLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  void _showWordGoalSelectionDialog(
      BuildContext context, SettingsViewModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Word Goal'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.wordGoalOptions.length,
            itemBuilder: (context, index) {
              final goal = model.wordGoalOptions[index];
              return RadioListTile<int>(
                title: Text('$goal words'),
                value: goal,
                groupValue: model.dailyWordGoal,
                onChanged: (value) {
                  if (value != null) {
                    model.setDailyWordGoal(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmation(
      BuildContext context, SettingsViewModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
            'This will reset all settings and clear all saved data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              model.clearAllData();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been cleared'),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }
}
