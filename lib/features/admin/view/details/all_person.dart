import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manaf_teacher/core/styles/themes.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/widgets/background.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import 'details_person.dart';

class AllPerson extends StatelessWidget {
  const AllPerson({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..initScrollController(context)
        ..getNameUser(context: context, page: '1'),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AdminCubit.get(context);

          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateBack(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'الطلاب',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ConditionalBuilder(
                            condition: cubit.user.isNotEmpty,
                            builder: (c) {
                              return ListView.builder(
                                controller: cubit.scrollController,
                                itemCount: cubit.user.length + (cubit.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index < cubit.user.length) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            navigateTo(
                                              context,
                                              DetailsPerson(
                                                id: cubit.user[index].id
                                                    .toString(),
                                                name: cubit.user[index].name,
                                                phone: cubit.user[index].phone,
                                                role: cubit.user[index].role,
                                                createdAt: cubit
                                                    .user[index].createdAt
                                                    .toString(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                            height: 85,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(6),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    cubit.deleteUser(
                                                      id: cubit
                                                          .user[index].id
                                                          .toString(),
                                                      context: context,
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Text(
                                                  cubit.user[index].name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${index + 1} #',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(color: Colors.white,),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            fallback: (c) => Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
