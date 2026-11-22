import 'package:flutter/material.dart';
import 'package:gsform_plus/gsform_plus.dart';

/// A three-step sign-up built with GSForm.stepper.
class WizardPage extends StatelessWidget {
  const WizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wizard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GSForm.stepper(
          context,
          onComplete: (values) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Done: $values'))),
          sections: [
            GSSection(
              sectionTitle: 'Account',
              fields: [
                GSField.text(tag: 'name', title: 'Name', required: true, errorMessage: 'Required'),
                GSField.email(tag: 'email', title: 'Email', required: true, errorMessage: 'Enter a valid email'),
              ],
            ),
            GSSection(
              sectionTitle: 'Profile',
              fields: [
                GSField.datePicker(tag: 'birthday', title: 'Birthday', isPastAvailable: true, weight: 6),
                GSField.masked(tag: 'phone', title: 'Phone', mask: '(###) ###-####', weight: 6),
              ],
            ),
            GSSection(
              sectionTitle: 'Confirm',
              fields: [GSField.toggle(tag: 'terms', hint: 'I accept the terms', required: true)],
            ),
          ],
        ),
      ),
    );
  }
}
