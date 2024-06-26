import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

class CapturedICTGrants extends StatelessWidget {
  final String title;
  const CapturedICTGrants({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final listState = context.watch<ICTDataEntryListCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: listState.list != null && listState.list!.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listState.list?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ICTListItem(
                          data: listState.list![index],
                          cardColor: Colors.blue[800],
                          trailing: MorePopup(
                              options: const ["Sync now", "Delete record"],
                              onAction: (index) {
                                switch (index) {
                                  case 0:
                                    // context.read<DataEntryListCubit>().syncData(listState.list![index]);
                                    break;
                                  case 1:
                                    context
                                        .read<ICTDataEntryListCubit>()
                                        .deleteItem(index);
                                    context
                                        .read<ICTDataEntryListCubit>()
                                        .loadSyncStats();
                                    break;
                                  default:
                                }
                              }),
                        );
                      })
                  : const Center(
                      child: Text("No records yet"),
                    ),
            )),
          ],
        ),
      ),
    );
  }
}
