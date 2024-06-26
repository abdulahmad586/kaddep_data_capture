import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class OfflineRepositoryPage extends StatelessWidget {
  const OfflineRepositoryPage({super.key});

  Future<bool> _exportData(BuildContext context, {Function(Object)? handleError}) async {
    Alert.toast(context, message: "Please wait...");
    AppConfig config = AppConfig();
    String databasePath = "${config.databaseDirectory!}/offlineData.db";
    File internalFile = File(databasePath);

    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          final dir = await getDownloadsDirectory();
          if(dir==null){
            throw "Sorry, we're unable to export your file at the moment";
          }
          directory = Directory("${dir.path.replaceAll("/Android/data/", "/Android/media/")}/");
        } else {
          if(context.mounted)Alert.toast(context,message: "Missing storage permission");
          return false;
        }
      } else {
        if (await _requestPermission(Permission.videos)) {
          directory = await getTemporaryDirectory();
        } else {
          if(context.mounted)Alert.toast(context,message: "Missing storage permission");
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists() && context.mounted) {
        File saveFile = File("${directory.path}${internalFile.path.substring(internalFile.path.lastIndexOf("/")+1)}");
        final result = await copyFile(context, internalFile, saveFile);
        if(context.mounted)Alert.toast(context, message: "Data exported");
        return result;
      }

    } catch (e) {
      handleError?.call(e);
      Alert.toast(context, message: e.toString());
    }
    return false;
  }

  Future<bool> copyFile(BuildContext context,File internalFile, File externalFile)async{
    // Open the internal file for reading
    final Stream<List<int>> internalSink = internalFile.openRead();

    // Open the external file for writing
    final IOSink externalSink = externalFile.openWrite();

    // Pipe the contents of the internal file to the external file
    await internalSink.pipe(externalSink);

    // Close the file streams
    // await internalSink.drain();
    await externalSink.close();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File contents copied successfully. ${externalFile.path}')));
    return true;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return Builder(
        builder: (context) {
          final appState = context.watch<AppCubit>().state;
          final listState = context.watch<OfflineRepositoryCubit>().state;

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
                    child: HomeTopBar(text1:"Repository", text2:" Manager"),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(child: MainHomeCard(cardColor: Colors.green[800], totalRecords:(listState.ogNumRecords??0)+(listState.ictNumRecords??0)), onTap: () {

                        },),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left:20),
                            child: Column(
                              children: [
                                DataCard(
                                  icon:Icons.business_sharp,
                                  label:"OP Grants",
                                  value: listState.ogNumRecords.toString(),
                                  color: Colors.green,
                                ),
                                DataCard(
                                  icon:Icons.computer,
                                  label:"ICT Grant",
                                  value: listState.ictNumRecords.toString(),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(child: GenericListItem(label: "Export Database", desc: "Export your data to a folder on your device", trailing: AppIconButton(icon: Icons.save,onTap:()=> _exportData(context),),),)
                ],
              ),
            ),
          );
        }
    );
  }


}
