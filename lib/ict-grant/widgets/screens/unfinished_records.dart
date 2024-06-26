import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class UnfinishedRecords extends StatelessWidget {
  const UnfinishedRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ICTDataEntryListCubit, ICTDataEntryListState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        height: 500,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text("UNFINISHED RECORDS",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).primaryColor)),
            const SizedBox(height: 10),
            Expanded(
              child: (state.unfinishedRecords?.isEmpty ?? true)
                  ? const Center(
                      child: Text("No records found"),
                    )
                  : ListView.builder(
                      itemCount: state.unfinishedRecords?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Card(
                          child: GenericListItem(
                            verticalPadding: 5,
                            leading: const Icon(Icons.data_exploration),
                            label:
                                "Name: ${(state.unfinishedRecords![index][ICTDataField.firstName.name])} ${state.unfinishedRecords![index][ICTDataField.lastName.name] ?? "Not captured"}",
                            desc:
                                "Business: ${state.unfinishedRecords![index][ICTDataField.businessName.name]?? "Not captured"}",
                            trailing: Row(
                              children: [
                                CustomIconButton(Icons.delete, onPressed: () {
                                  context
                                      .read<ICTDataEntryListCubit>()
                                      .deleteRecordById(
                                          state.unfinishedRecords![index]['rid']
                                              as int);
                                }),
                                CustomIconButton(Icons.play_arrow, iconColor: Colors.white, backgroundColor: Theme.of(context).primaryColor, onPressed: () {
                                  Navigator.pop(context);
                                  NavUtils.navTo(
                                      context,
                                      ICTDataEntryPage(
                                          existingRecordId:
                                          state.unfinishedRecords![index]
                                          ["rid"] as int?));
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            AppTextButton(label: "New Record", textColor: Colors.white, buttonColor: Theme.of(context).primaryColor, onPressed: (){
            Navigator.pop(context);
              NavUtils.navTo(
            context, ICTDataEntryPage(existingRecordId: null));
      }),
          ],
        ),
      );
    });
  }
}
