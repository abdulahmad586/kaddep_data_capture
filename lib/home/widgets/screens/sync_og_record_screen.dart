import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SyncOGRecordPage extends StatelessWidget {
  final int rid;
  const SyncOGRecordPage(this.rid,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=> OGDataSyncCubit(rid, OGDataSyncState()),
      child: BlocBuilder<OGDataSyncCubit,OGDataSyncState>(
        builder: (context,state){
          return BaseScaffold(
            noGradient: true,
            backgroundColor: Colors.white,
            showBack:true,
            body: Container(
              padding: const EdgeInsets.all(10),

              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "PUBLISH TO SERVER",
                    style:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                          width: 200,
                          height: 200,
                          child: state.syncing??false ? LoadingIndicator(
                              indicatorType: Indicator.ballRotateChase,
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.1),
                                Theme.of(context).primaryColor.withOpacity(0.25),
                                Theme.of(context).primaryColor.withOpacity(0.45),
                                Theme.of(context).primaryColor.withOpacity(0.60),
                                Theme.of(context).primaryColor.withOpacity(0.75),
                              ],
                              strokeWidth: 5,
                              pathBackgroundColor: Colors.black)
                              : const SizedBox()
                      ),
                      const Icon(Icons.cloud_upload, size: 75, color: Colors.lightGreen,),

                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    state.data?.businessName??"Loading",
                    style:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  Text((state.error != null && state.error!.isNotEmpty ? state.error : null) ?? state.statusText ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: state.error != null && state.error!.isNotEmpty ? Colors.red : Colors.grey,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: AppTextButton(
                      buttonColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      loading: state.syncing ?? false,
                      width: MediaQuery.of(context).size.width-100,
                      label: "CONTINUE",
                      onPressed: () {
                        context.read<OGDataSyncCubit>().syncRecord(context.read<AppCubit>().user!.id, (){
                          Navigator.pop(context);
                        });
                      },
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
