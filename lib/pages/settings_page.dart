import 'package:flutter/material.dart';
import 'package:payroute_desktop/pages/select_account_type_page.dart';

/// Settings route.
///
/// NOTE: The product spec for this route is currently the “Select Account Type”
/// screen (HTML parity). The legacy settings UI was removed because it was not
/// the expected content for this page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectAccountTypePage();
  }
}
