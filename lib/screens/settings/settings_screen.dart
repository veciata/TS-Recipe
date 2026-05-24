import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/sync_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final currentColor = ref.watch(themeColorProvider);
    final darkMode = ref.watch(darkModeProvider);
    final authState = ref.watch(authStateProvider);
    final syncState = ref.watch(syncStateProvider);
    final isGuest = authState is AuthGuest;
    final user = switch (authState) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/logo.png', height: 32)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: l10n.language),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: currentLocale.languageCode == 'tr'
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                  title: Text(l10n.turkish),
                  subtitle: const Text('Türkçe'),
                  onTap: () => ref.read(localeProvider.notifier).setLocale('tr'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: currentLocale.languageCode == 'en'
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                  title: Text(l10n.english),
                  subtitle: const Text('English'),
                  onTap: () => ref.read(localeProvider.notifier).setLocale('en'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: l10n.theme),
          Card(
            child: SwitchListTile(
              title: Text(l10n.darkMode),
              subtitle: Text(darkMode ? l10n.darkMode : l10n.lightMode),
              value: darkMode,
              onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: l10n.account),
          Card(
            child: Column(
              children: [
                if (user != null)
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  )
                else if (isGuest)
                  ListTile(
                    leading: const Icon(Icons.person_off_outlined),
                    title: Text(l10n.browsingWithoutAccount),
                    subtitle: Text(l10n.signIn),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/auth'),
                  ),
                if (user != null || isGuest) const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.sync),
                  title: const Text('Sync recipes'),
                  subtitle: Text(
                    isGuest
                        ? l10n.syncRequiresAccount
                        : switch (syncState.status) {
                            SyncStatus.syncing => 'Syncing…',
                            SyncStatus.success =>
                              syncState.lastSync != null
                                  ? 'Last sync: ${syncState.lastSync!.toLocal()}'
                                  : 'Sync completed',
                            SyncStatus.error => 'Sync failed',
                            SyncStatus.idle => 'Sync with server',
                          },
                  ),
                  trailing: syncState.status == SyncStatus.syncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: isGuest
                      ? () => context.push('/auth')
                      : syncState.status == SyncStatus.syncing
                          ? null
                          : () => ref
                              .read(syncStateProvider.notifier)
                              .initiateSync(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(isGuest ? Icons.login : Icons.logout),
                  title: Text(isGuest ? l10n.signIn : l10n.signOut),
                  onTap: () async {
                    if (isGuest) {
                      context.push('/auth');
                    } else {
                      await ref.read(authStateProvider.notifier).logout();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: l10n.themeColor),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(AppColors.themeColors.length, (i) {
                  final color = AppColors.themeColors[i];
                  final isSelected = color == currentColor;
                  return GestureDetector(
                    onTap: () => ref.read(themeColorProvider.notifier).setColor(color),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(color),
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                            boxShadow: isSelected
                                ? [BoxShadow(color: Color(color).withValues(alpha: 0.5), blurRadius: 8)]
                                : null,
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                        ),
                        const SizedBox(height: 4),
                        Text(AppColors.themeColorNames[i], style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
