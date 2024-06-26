import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/widgets/sub-widgets/more_popup.dart';

import '../../states/states.dart';
import '../sub-widgets/og_list_item.dart';

class CapturedSMEs extends StatelessWidget {
  final String title;
  const CapturedSMEs({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final listState = context.watch<OGDataEntryListCubit>().state;
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
                        return OGListItem(
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
                                        .read<OGDataEntryListCubit>()
                                        .deleteItem(index);
                                    context
                                        .read<OGDataEntryListCubit>()
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
