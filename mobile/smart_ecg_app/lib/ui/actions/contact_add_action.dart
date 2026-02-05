import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../core/localization/i18n.dart';
import '../../features/emergency/emergency_contacts_controller.dart';
import '../widgets/error_dialog.dart';

class AddContactAction extends ConsumerStatefulWidget {
  const AddContactAction({super.key});

  @override
  ConsumerState<AddContactAction> createState() => _AddContactActionState();
}

class _AddContactActionState extends ConsumerState<AddContactAction> {
  final TextEditingController _nameCtl = TextEditingController();
  final TextEditingController _phoneCtl = TextEditingController();
  
  final PhoneNumber _initialNumber = PhoneNumber(isoCode: 'TR');
  String? _fullPhoneNumber;
  
  // 1. Track validity
  bool _isPhoneValid = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _phoneCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context, ref);

    return AlertDialog(
      title: Text(i18n.tr('add_emergency_contact')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtl,
            decoration: InputDecoration(
              labelText: i18n.tr('name'),
            ),
          ),
          const SizedBox(height: 12),
          
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              _fullPhoneNumber = number.phoneNumber;
            },
            onInputValidated: (bool value) {
              _isPhoneValid = value;
            },
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,
            // 3. User Interaction validation for red outline
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: const TextStyle(color: Colors.black),
            initialValue: _initialNumber,
            textFieldController: _phoneCtl,
            formatInput: true,
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            inputDecoration: InputDecoration(
              labelText: i18n.tr('phone_number'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(i18n.tr('cancel')),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: Text(i18n.tr('add')),
        ),
      ],
    );
  }

  void _onSave() {
    final i18n = I18n.of(context, ref);
    
    if (_nameCtl.text.trim().isEmpty) {
      ErrorDialog.showErrorDialog(context, ref, i18n.tr('invalid_name'));
      return;
    }

    if (_fullPhoneNumber == null || _fullPhoneNumber!.isEmpty || !_isPhoneValid) {
      ErrorDialog.showErrorDialog(context, ref, i18n.tr('invalid_phone_number'));
      return;
    }

    ref.read(emergencyContactsProvider.notifier).add(
          _nameCtl.text.trim(),
          _fullPhoneNumber!,
        );

    Navigator.pop(context);
  }
}