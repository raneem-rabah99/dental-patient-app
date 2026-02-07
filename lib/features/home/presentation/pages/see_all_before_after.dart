import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/sources/favorite_case_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/favorite_case_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/favorite_case_state.dart';
import 'package:dentaltreatment/features/home/presentation/pages/before_after_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeeAllBeforeAfter extends StatelessWidget {
  const SeeAllBeforeAfter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => FavoriteCaseCubit(FavoriteCaseService())..loadFavoriteCases(),
      child: BlocBuilder<FavoriteCaseCubit, FavoriteCaseState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.darkblue),
            );
          }
          final items = state.cases;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "TOP DOCTORS",
                style: TextStyle(fontFamily: 'Serif'),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),

                SizedBox(
                  height: 680,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(left: 8.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final caseItem = items[index];

                      return BeforeAfterItem(
                        caseItem: caseItem, // <--- USE FavoriteCaseModel
                      );
                    },
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
