import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  Future<void> _savePin() async {
    if (_pinController.text.isEmpty || _confirmPinController.text.isEmpty) {
      _showSnack('Enter both fields.');
      return;
    }
    if (_pinController.text != _confirmPinController.text) {
      _showSnack('PINs do not match.');
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', _pinController.text);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Your PIN')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter PIN'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _confirmPinController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm PIN'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock),
              label: const Text('Save PIN'),
              onPressed: _savePin,
            )
          ],
        ),
      ),
    );
  }
}
