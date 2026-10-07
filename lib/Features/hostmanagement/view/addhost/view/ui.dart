import 'package:everqpidadmin/Features/hostmanagement/view/addhost/view/widgets/addform.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/addhost/view/widgets/interestcard.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/addhost/view/widgets/languagecard.dart';
import 'package:flutter/material.dart';

class CreatehostUi extends StatelessWidget {
  const CreatehostUi({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Left Form
              Expanded(
                flex: 3,
                child: CreateHostForm(),
              ),

              const SizedBox(width: 24),

              /// Right Side Widgets
              Expanded(
                flex: 1,
                child: Column(
                  children: const [
                    // ProfileImageCard(),
                    // SizedBox(height: 16),
                    LanguageCard(),
                    SizedBox(height: 16),
                    InterestCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
