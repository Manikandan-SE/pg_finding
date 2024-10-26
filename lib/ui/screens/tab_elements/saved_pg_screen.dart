import 'package:flutter/material.dart';
import 'package:pg_finding/utils/index.dart';

import '../../widgets/index.dart';

class SavedPgScreen extends StatelessWidget {
  const SavedPgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              child: Text(
                "Saved PG's List",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                children: [
                  PgCard(
                    height: context.height * 0.25,
                  ),
                  SizedBox(
                    height: context.width * 0.04,
                  ),
                  PgCard(
                    height: context.height * 0.25,
                  ),
                  SizedBox(
                    height: context.width * 0.04,
                  ),
                  PgCard(
                    height: context.height * 0.25,
                  ),
                  SizedBox(
                    height: context.width * 0.04,
                  ),
                  PgCard(
                    height: context.height * 0.25,
                  ),
                  SizedBox(
                    height: context.width * 0.04,
                  ),
                  PgCard(
                    height: context.height * 0.25,
                  ),
                  SizedBox(
                    height: context.width * 0.04,
                  ),
                  PgCard(
                    height: context.height * 0.25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
