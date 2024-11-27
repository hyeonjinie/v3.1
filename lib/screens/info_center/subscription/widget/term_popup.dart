import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsPopupPage extends StatefulWidget {
  final VoidCallback onAgree;

  const TermsPopupPage({
    Key? key,
    required this.onAgree,
  }) : super(key: key);

  @override
  _TermsPopupPageState createState() => _TermsPopupPageState();
}

class _TermsPopupPageState extends State<TermsPopupPage> {
  String termsContent = '';

  @override
  void initState() {
    super.initState();
    loadTermsContent();
  }

  Future<void> loadTermsContent() async {
    String loadedContent = await rootBundle.loadString('assets/term_content/main_term_content.txt');
    setState(() {
      termsContent = loadedContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth > 700 ? 700 : constraints.maxWidth * 0.9,
            height: constraints.maxHeight * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '약관 동의',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      termsContent,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 26),
                      backgroundColor: const Color(0xFF1E357D),
                    ),
                    onPressed: () {
                      widget.onAgree();
                      Navigator.of(context).pop();
                    },
                    child: const Text('동의하기', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



class TermsAdditionalPopupPage extends StatefulWidget {
  final VoidCallback onAgree;

  const TermsAdditionalPopupPage({
    Key? key,
    required this.onAgree,
  }) : super(key: key);

  @override
  _TermsAdditionalPopupPageState createState() => _TermsAdditionalPopupPageState();
}

class _TermsAdditionalPopupPageState extends State<TermsAdditionalPopupPage> {
  String termsContent = '';

  @override
  void initState() {
    super.initState();
    loadTermsContent();
  }

  Future<void> loadTermsContent() async {
    String loadedContent = await rootBundle.loadString('assets/term_content/additional_term_content.txt');
    setState(() {
      termsContent = loadedContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth > 700 ? 700 : constraints.maxWidth * 0.9,
            height: constraints.maxHeight * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '약관 동의',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      termsContent,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 26),
                      backgroundColor: const Color(0xFF1E357D),
                    ),
                    onPressed: () {
                      widget.onAgree();
                      Navigator.of(context).pop();
                    },
                    child: const Text('동의하기', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
