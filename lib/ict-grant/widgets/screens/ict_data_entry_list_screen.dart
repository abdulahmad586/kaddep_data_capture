import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/home/home.dart';

class ICTDataEntryListPage extends StatelessWidget {
  const ICTDataEntryListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Builder(
        builder: (context) {
          final appState = context.watch<AppCubit>().state;
          final listState = context.watch<ICTDataEntryListCubit>().state;

          return Scaffold(
            body: Container(
              decoration: (appState.isOnlineMode??false) ? ThemeConstants.onlineModeDecoration : null,
              height: MediaQuery.of(context).size.height * 1.5,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height:10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0),
                    child: HomeTopBar(text1:"ICT", text2:" Grant"),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(child: RegisteredSMEs(value: (listState.unsyncedDataCount??0)+(listState.syncedDataCount??0), cardColor: Colors.blue[800],), onTap: () {

                        },),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left:20),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical:5),
                                  padding: const EdgeInsets.symmetric(vertical:20, horizontal: 15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[800]?.withOpacity(0.05),
                                      borderRadius: const BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: Row(children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.blue[800],
                                          borderRadius: const BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.cloud, color: Colors.white,),
                                      ),
                                    ),
                                    const SizedBox(width:10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Published", overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
                                          const SizedBox(height:5),
                                          Text((listState.syncedDataCount??0).toString(), style: TextStyle(color: Colors.grey[600]),),
                                        ],
                                      ),
                                    ),
                                  ],),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical:5),
                                  padding: const EdgeInsets.symmetric(vertical:20, horizontal: 15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: (listState.unsyncedDataCount??0) > 0 ? Colors.blue[800] : Colors.blue[800]?.withOpacity(0.05),
                                      borderRadius: const BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: Row(children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius: const BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Center(
                                        child: Text((listState.unsyncedDataCount??0).toString(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                    const SizedBox(width:10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Unpublished", overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: (listState.unsyncedDataCount??0) > 0 ? Colors.white:Colors.black),),
                                          const SizedBox(height:5),
                                          Text((listState.unsyncedDataCount??0) > 0 ? "Sync data" : "No data", style: TextStyle(color: (listState.unsyncedDataCount??0) > 0 ? Colors.grey[200] : Colors.grey),),
                                        ],
                                      ),
                                    ),
                                  ],),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if((listState.unsyncedDataCount??0)>0 && !(listState.syncing??false))Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blue, width: 0.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.info, color: listState.syncError !=null && listState.syncError!.isNotEmpty ? Colors.orange : Colors.blue),
                                  const SizedBox(width:5),
                                  Expanded(child: Text(listState.syncError != null && listState.syncError!.isNotEmpty ? listState.syncError! : "You have some data waiting to be published", maxLines: 2, style: Theme.of(context).textTheme.bodySmall,))
                                ],
                              ),
                            ),
                            if(listState.syncError ==null || listState.syncError!.isEmpty)AppTextButton(label: (appState.isOnlineMode??false) ? "Sync" : "Go online", fontSize: 12, onPressed: (){
                              if(appState.isOnlineMode ?? false){
                                context.read<ICTDataEntryListCubit>().startSyncing(context.read<AppCubit>().user!.id);
                              }else{
                                context.read<AppCubit>().updateMode(true);
                              }
                            }, textColor: Colors.blue[800],buttonColor: Colors.blue[200],),
                            if(listState.syncError !=null && listState.syncError!.isNotEmpty)AppTextButton(label:"Clear", fontSize: 12, onPressed: (){
                              context.read<ICTDataEntryListCubit>().clearSyncError();
                            }, textColor: Colors.orange[800],buttonColor: Colors.white,)
                          ],
                        ),
                      )
                  ),
                  if(listState.syncing ??false)Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blue, width: 0.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.cloud, color:Colors.blue),
                                const SizedBox(width:5),
                                Text("${listState.syncedDataCount}/${listState.unsyncedDataCount} | Syncing data, please stay online", style: Theme.of(context).textTheme.bodySmall,)
                              ],
                            ),
                            AppTextButton(label: "${(((listState.syncedDataCount ?? 0)/(listState.unsyncedDataCount??0)) *100).toStringAsFixed(1)}%", onPressed: (){}, textColor: Colors.white,buttonColor: Colors.blue[200],)
                          ],
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0, left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(listState.view == DataEntryListView.published ? "Recently published data" : "Recently saved data"),
                        Row(
                          children: [
                            TextPopup(
                              width: 150,
                              active: listState.view == DataEntryListView.published ? 0 : 1,
                              list: const ["Published", "Unpublished"],
                              onSelected: (i){
                                context.read<ICTDataEntryListCubit>().switchView(i==0 ? DataEntryListView.published : DataEntryListView.unpublished);
                              },
                            ),
                            if(listState.loading??false) const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                            ),
                            if(!(listState.loading??false))CustomIconButton(Icons.refresh, backgroundColor: Colors.blue[800]?.withOpacity(0.05), onPressed: (){
                              context.read<ICTDataEntryListCubit>().loadData(refresh: true);
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: listState.list !=null && listState.list!.isNotEmpty ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: listState.list?.length??0,
                        itemBuilder: (context,index){
                          return ICTListItem(
                            data:listState.list![index],
                            cardColor: Colors.blue[800],
                            trailing: (listState.list![index].dataSynced??false) ? null: MorePopup(options: const ["Edit","Sync now", "Delete record"], onAction: (a){
                              switch(a){
                                case 0:
                                  NavUtils.navTo(context, ICTDataEntryPage(existingRecordId: listState.list![index].rid,), onReturn: (){
                                    context.read<ICTDataEntryListCubit>().refreshAll();
                                  });
                                  break;
                                case 1:
                                // NavUtils.navTo(context, SyncRecordPage(listState.list![index].rid));
                                  break;
                                case 2:
                                  context.showConfirmationDialog(onConfirm: (){
                                    context.read<ICTDataEntryListCubit>().deleteItem(index);
                                    context.read<ICTDataEntryListCubit>().refreshAll();
                                    Navigator.pop(context);
                                  }, title: "Delete Record?", message: "You are about to permanently erase this captured record"
                                  );
                                  break;
                                default:
                              }
                            }),
                          );
                        }
                    ): const Center(child: Text("No records yet"),),
                  )),
                ],
              ),
            ),
          );
        }
    );
  }


}
