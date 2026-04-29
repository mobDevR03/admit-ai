import 'package:flutter/material.dart';

class CountryScreen extends StatefulWidget {
  final int stepNumber;
  final int totalSteps;
  final ValueChanged<String> onNext;

  const CountryScreen({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onNext,
  });

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  String? _selectedCountry;

  final List<String> _countries = [
    'USA',
    'Europe',
  ];

  @override
  Widget build(BuildContext context) {
    final double progress = widget.stepNumber / widget.totalSteps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Country'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Step ${widget.stepNumber} of ${widget.totalSteps}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  return RadioListTile<String>(
                    title: Text(country),
                    value: country,
                    groupValue: _selectedCountry,
                    onChanged: (value) {
                      setState(() {
                        _selectedCountry = value;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedCountry == null
                    ? null
                    : () => widget.onNext(_selectedCountry!),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}