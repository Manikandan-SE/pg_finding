import 'package:flutter/material.dart';
import 'package:pg_finding/utils/index.dart';

import '../../../models/index.dart';
import '../../widgets/index.dart';

class SavedPgScreen extends StatelessWidget {
  final List<FilterPgModel?>? savedPgList;
  final Function({FilterPgModel? pgDetails})? onTapSavePGInSavedList;
  const SavedPgScreen({
    super.key,
    this.onTapSavePGInSavedList,
    this.savedPgList,
  });

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
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: context.width * 0.04,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                itemCount: savedPgList?.length ?? 0,
                itemBuilder: (context, index) {
                  return PgCard(
                    pgDetails: savedPgList != null ? savedPgList![index] : null,
                    // width: context.width * 0.8,
                    height: context.height * 0.25,
                    onTapSave: onTapSavePGInSavedList,
                    isSaved: true,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(pgDetailsRoute, arguments: {
                        'pgDetails': savedPgList != null
                            ? savedPgList![index]?.copyWith(
                                isSaved: true,
                              )
                            : null,
                        'onTapSave': onTapSavePGInSavedList,
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
