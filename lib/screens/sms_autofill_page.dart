import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:liteline/utils/helpers.dart';

class SmsAutofillPage extends StatefulWidget {
  const SmsAutofillPage({super.key});

  @override
  State<SmsAutofillPage> createState() => _SmsAutofillPageState();
}

class _SmsAutofillPageState extends State<SmsAutofillPage> with CodeAutoFill {
  String _appSignature = '';
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAppSignature();
    listenForCode(); 
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpController.text = code ?? 'No code received';
    });
    showToast(context, 'OTP received: ${_otpController.text}');
  }

  Future<void> _getAppSignature() async {
    try {
      _appSignature = await SmsAutoFill().getAppSignature ?? '';
      setState(() {});
      showToast(context, 'App Signature generated.');
    } catch (e) {
      setState(() {
        _appSignature = 'Error getting signature: $e';
      });
      showToast(context, 'Error getting app signature');
    }
  }

  @override
  void dispose() {
    cancel(); 
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Autofill'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter OTP from SMS:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            PinFieldAutoFill(
              controller: _otpController,
              decoration: UnderlineDecoration(
                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                colorBuilder: FixedColorBuilder(Colors.blue.shade700),
              ),
              currentCode: _otpController.text,
              onCodeChanged: (code) {
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Your App Signature (for SMS Sender):',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SelectableText(
              _appSignature,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showToast(context, 'Manually checking for OTP...');
                listenForCode(); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Listen for SMS (again)', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}