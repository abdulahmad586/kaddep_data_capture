import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/tutorial-videos/tutorial-videos.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

    @override
    Widget build(BuildContext context) {
      Function()? refreshStats;

      return BlocProvider<DashboardCubit>(
        create: (_) =>
            DashboardCubit(context
                .read<SettingsCubit>()
                .state
                .captureLga ?? "", DashboardState(existingOgGrants: 0,
                newOgGrants: 0,
                existingIctGrants: 0,
                newIctGrants: 0,
                syncedIctGrants: 0,
                syncedOgGrants: 0,
                updatedIctGrants: 0,
                updatedOfGrants: 0)),
        child: Scaffold(
          body: BlocBuilder<AppCubit, AppState>(
              buildWhen: (p, c) => c.isOnlineMode != p.isOnlineMode,
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Container(
                    decoration: (state.isOnlineMode ?? false)
                        ? ThemeConstants.onlineModeDecoration
                        : null,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.9,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const HomeTopBar(showUserIcon: true),
                        BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, state) {
                              return
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200.withOpacity(
                                            0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: GenericListItem(
                                        verticalPadding: 10,
                                        leading: AppIconButton(
                                          borderColor: state.captureLga == null
                                              ? Colors.amber
                                              : null,
                                          icon: state.captureLga == null ? Icons
                                              .warning_amber : Icons
                                              .location_on_rounded,),
                                        label: "Location of Interest",
                                        desc: state.captureLga == null
                                            ? "Please set location"
                                            : "${state.captureLga}, ${state
                                            .captureLgaCode?.toUpperCase()}",
                                        descStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: state.captureLga == null
                                                ? Colors.amber
                                                : Theme
                                                .of(context)
                                                .primaryColor),
                                        trailing: AppTextButton(
                                          padding: EdgeInsets.zero,
                                          textColor: Theme
                                              .of(context)
                                              .primaryColor,
                                          label: "Change", onPressed: () {
                                          NavUtils.navTo(context,
                                              const ChangeCaptureLocation(),
                                              onReturn: () {
                                                refreshStats?.call();
                                              });
                                        },),
                                      ),),
                                  ),
                                );
                            }
                        ),
                        const SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                border: Border.all(
                                    color: Colors.blue, width: 0.5)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.video_collection,
                                            color: Colors.blue),
                                        const SizedBox(width: 5),
                                        Expanded(child: Text(
                                          "Need more information? watch video tutorials",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodySmall, maxLines: 2,))
                                      ],
                                    ),
                                  ),
                                  AppTextButton(
                                    padding: EdgeInsets.zero,
                                    label: "Tutorials",
                                    onPressed: () {
                                      NavUtils.navTo(
                                          context, VideosListScreen());
                                    },
                                    textColor: Colors.white,
                                    buttonColor: Colors.blue[200],)
                                ],
                              ),
                            )
                        ),
                        Expanded(child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "ICT Grant Records", textAlign: TextAlign.start,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Theme
                                  .of(context)
                                  .primaryColor),),
                            const SizedBox(height: 10),
                            BlocBuilder<DashboardCubit, DashboardState>(
                                builder: (context, state) {
                                  refreshStats = () {
                                    String? lga = context
                                        .read<SettingsCubit>()
                                        .state
                                        .captureLga;
                                    if (lga != null) {
                                      context.read<DashboardCubit>().loadStats(
                                          lga);
                                    }
                                  };
                                  return GridView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 100,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 10,
                                    ),
                                    children: [
                                      StatWidget(icon: Icons.add,
                                        label: "New",
                                        showShadow: false,
                                        display: state.newIctGrants
                                            .toString(),),
                                      StatWidget(icon: Icons.extension_outlined,
                                          label: "Old records",
                                          showShadow: false,
                                          display: state.existingIctGrants
                                              .toString()),
                                      StatWidget(icon: Icons.verified,
                                          label: "Verified",
                                          showShadow: false,
                                          display: state.updatedIctGrants
                                              .toString()),
                                      StatWidget(icon: Icons.cloud_upload,
                                          label: "Synced",
                                          showShadow: false,
                                          display: state.syncedIctGrants
                                              .toString()),
                                    ],
                                  );
                                }
                            ),
                            const SizedBox(height: 20),
                            Text("Operational Cost Grant Records",
                              textAlign: TextAlign.start, style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Theme
                                  .of(context)
                                  .primaryColor),),
                            const SizedBox(height: 10),
                            BlocBuilder<DashboardCubit, DashboardState>(
                                builder: (context, state) {
                                  return GridView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 100,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 10,
                                    ),
                                    children: [
                                      StatWidget(icon: Icons.add,
                                        label: "New",
                                        showShadow: false,
                                        display: state.newOgGrants.toString(),),
                                      StatWidget(icon: Icons.extension_outlined,
                                          label: "Old records",
                                          showShadow: false,
                                          display: state.existingOgGrants
                                              .toString()),
                                      StatWidget(icon: Icons.verified,
                                          label: "Verified",
                                          showShadow: false,
                                          display: state.updatedOfGrants
                                              .toString()),
                                      StatWidget(icon: Icons.cloud_upload,
                                          label: "Synced",
                                          showShadow: false,
                                          display: state.syncedOgGrants
                                              .toString()),
                                    ],
                                  );
                                }
                            )
                          ],))
                      ],
                    ),
                  ),
                );
              }),
        ),
      );
    }
}