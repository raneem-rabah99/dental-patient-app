import 'package:dentaltreatment/core/classes/icons_classes.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:dentaltreatment/features/home/data/sources/favorite_case_service.dart';
import 'package:dentaltreatment/features/home/presentation/managers/favorite_case_cubit.dart';
import 'package:dentaltreatment/features/home/presentation/managers/favorite_case_state.dart';
import 'package:dentaltreatment/features/home/presentation/pages/before_after_item.dart';
import 'package:dentaltreatment/features/home/presentation/pages/see_all_before_after.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeforeAfterSection extends StatelessWidget {
  const BeforeAfterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => FavoriteCaseCubit(FavoriteCaseService())..loadFavoriteCases(),
      child: BlocBuilder<FavoriteCaseCubit, FavoriteCaseState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = state.cases;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HEADER ----------------
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 14, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Doctors",
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 25,
                        color: AppColor.darkblue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value: BlocProvider.of<FavoriteCaseCubit>(
                                    context,
                                  ),
                                  child: const SeeAllBeforeAfter(),
                                ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Text(
                            "See All",
                            style: TextStyle(
                              fontFamily: 'Serif',
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Iconarowright.arowright,
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ---------------- LIST ----------------
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15.0),
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
          );
        },
      ),
    );
  }
}
