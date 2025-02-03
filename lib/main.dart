import 'dart:developer' as developer;
import 'dart:js' as js;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(jsVariables: fetchJavaScriptVariables()));
}

class JavaScriptVariables {
  final String? token;
  final String? msisdn;

  const JavaScriptVariables({this.token, this.msisdn});
}

JavaScriptVariables fetchJavaScriptVariables() {
  if (!kIsWeb) return const JavaScriptVariables();

  try {
    final token =
        js.context.hasProperty('token') ? js.context['token'] as String? : null;
    final msisdn = js.context.hasProperty('msisdn')
        ? js.context['msisdn'] as String?
        : null;

    if (token != null && msisdn != null) {
      debugPrint(
        '✅ JavaScript Variables Found:\n🔑 Token: $token\n🔗 msisdn: $msisdn',
      );
    } else {
      debugPrint('⚠️ JavaScript variables "token" or "msisdn" not found.');
    }

    return JavaScriptVariables(token: token, msisdn: msisdn);
  } catch (e, stackTrace) {
    debugPrint('❌ Error accessing JavaScript variables: $e\n$stackTrace');
    return const JavaScriptVariables();
  }
}

class MyApp extends StatelessWidget {
  final JavaScriptVariables jsVariables;

  const MyApp({super.key, required this.jsVariables});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [defaultLifecycleObserver],
      title: 'Flutter Web with JS Variables',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StepRewardsScreen(jsVariables: jsVariables),
    );
  }
}

class StepRewardsScreen extends StatelessWidget {
  final JavaScriptVariables jsVariables;

  const StepRewardsScreen({super.key, required this.jsVariables});

  @override
  Widget build(BuildContext context) {
    return LifecycleWrapper(
      onLifecycleEvent: (event) => debugPrint('🔵 Lifecycle Event: $event'),
      child: Scaffold(
        appBar: kIsWeb
            ? AppBar(
                backgroundColor: Colors.teal,
                centerTitle: true,
                title: const Text('Kazandıran Adımlar'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>  {
                      debugPrint('🟢 Close button pressed.'),
                      js.context.callMethod('flutterWebViewCallback', ['close'])
                  },
                  ),
                ],
              )
            : null,
        backgroundColor: Colors.grey[100],
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const _RewardCard(),
            ),
          ),
        ),
      ),
    );
  }
}



class _RewardCard extends StatelessWidget {
  const _RewardCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Kazandıran Adımlar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 4),
                ),
                child: const Center(
                  child: Text(
                    '1\nAdım',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Kalan Süre',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            const Text(
              '6 Gün 23 Saat 2 Dakika',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 1 / 7, // Example progress
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1. Gün'),
                    Text('7. Gün'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blueGrey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: _RewardInfo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardInfo extends StatelessWidget {
  const _RewardInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Günlük 3 GB',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.directions_walk, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              '30.000 Adım',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '29.999 adım daha atmanız gerekiyor.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: null, // disabled example
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Ödülü Al', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
