import 'package:flutter/material.dart';
import 'package:gsform_plus/gsform_plus.dart';

/// Shows the controller, custom validators, onChanged, autovalidate and the newer field types.
class FeaturesPage extends StatefulWidget {
  const FeaturesPage({super.key});

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  final controller = GSFormController(initialValues: {'name': 'Ana', 'volume': 40});
  String lastChange = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New features')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GSForm.singleSection(
              context,
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (tag, value) => setState(() => lastChange = '$tag → $value'),
              style: GSFormStyle.fromTheme(Theme.of(context)).copyWith(labels: GSFormLabels.es),
              fields: [
                GSField.text(
                  tag: 'name',
                  title: 'Name',
                  validator: (v) => (v as String).trim().length < 3 ? 'At least 3 letters' : null,
                ),
                GSField.password(tag: 'pass', title: 'Password', weight: 6),
                GSField.password(
                  tag: 'confirm',
                  title: 'Confirm',
                  weight: 6,
                  validator: (v) => v == controller.getValue('pass') ? null : 'Passwords differ',
                ),
                GSField.masked(
                  tag: 'phone',
                  title: 'Phone',
                  mask: '(###) ###-####',
                  keyboardType: TextInputType.phone,
                  required: true,
                  errorMessage: 'Complete the number',
                ),
                GSField.pinCode(tag: 'pin', title: 'Verification code', length: 6, required: true),
                GSField.autocomplete(
                  tag: 'city',
                  title: 'City',
                  hint: 'Start typing',
                  items: [
                    SpinnerDataModel(name: 'Guatemala', id: 1),
                    SpinnerDataModel(name: 'San Salvador', id: 2),
                    SpinnerDataModel(name: 'Tegucigalpa', id: 3),
                    SpinnerDataModel(name: 'Managua', id: 4),
                    SpinnerDataModel(name: 'San José', id: 5),
                  ],
                ),
                GSField.slider(tag: 'volume', title: 'Volume', min: 0, max: 100, divisions: 10),
                GSField.slider(tag: 'budget', title: 'Budget', min: 0, max: 1000, divisions: 20, isRange: true),
                GSField.dateRangePicker(tag: 'trip', title: 'Trip', hint: 'Pick dates'),
                GSField.custom(
                  tag: 'rating',
                  title: 'Rating',
                  required: true,
                  errorMessage: 'Give us some stars',
                  builder: (context, value, onChanged) => Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        IconButton(
                          icon: Icon(i <= ((value as int?) ?? 0) ? Icons.star : Icons.star_border),
                          onPressed: () => onChanged(i),
                        ),
                    ],
                  ),
                ),
                GSField.toggle(tag: 'terms', hint: 'I accept the terms', required: true),
              ],
            ),
            Text('Last change: $lastChange'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () {
                    final valid = controller.isValid();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(valid ? controller.values.toString() : 'Fix the highlighted fields')),
                    );
                  },
                  child: const Text('Submit'),
                ),
                OutlinedButton(onPressed: controller.reset, child: const Text('Reset')),
                OutlinedButton(
                  onPressed: () => controller.setValues({'phone': '5551234567', 'pin': '123456', 'terms': true}),
                  child: const Text('Fill some'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
