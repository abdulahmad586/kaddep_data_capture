import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:dotted_border/dotted_border.dart' as db;

class ImagePickZone extends StatelessWidget{

  final String? path, fieldLabel;
  final bool? isDocument;
  final Function(String) onPathUpdate;

  const ImagePickZone(this.path, this.onPathUpdate, {this.fieldLabel, this.isDocument, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ImagePickerUtil.pickImage(isDocument: isDocument ?? false).then((value) {
              if (value != null) {
                onPathUpdate(value.path);
              }
            }).catchError((err) {
              Alert.toast(context, message: err.toString());
            });
          },
          child: Builder(
            builder: (c) {
              if (path == null) {
                return db.DottedBorder(
                    color: Theme.of(context).primaryColor,
                    borderType: db.BorderType.RRect,
                    radius: const Radius.circular(10),
                    child: Image.asset(
                      AssetConstants.imageNotFound,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ));
              } else {
                return CardFileImage(
                  imageString: path!,
                  size: const Size(200, 200),
                  radius: 10,
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(fieldLabel??"",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

}

class ImageBlobPickZone extends StatelessWidget{

  final Uint8List? blob;
  final String? fieldLabel;
  final Function(String) onPathUpdate;
  final bool? isDocument;

  const ImageBlobPickZone(this.blob, this.onPathUpdate, {this.fieldLabel, this.isDocument, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ImagePickerUtil.pickImage(isDocument: isDocument ?? false).then((value) {
              if (value != null) {
                onPathUpdate(value.path);
              }
            }).catchError((err) {
              Alert.toast(context, message: err.toString());
            });
          },
          child: Builder(
            builder: (c) {
              if (blob == null) {
                return db.DottedBorder(
                    color: Theme.of(context).primaryColor,
                    borderType: db.BorderType.RRect,
                    radius: const Radius.circular(10),
                    child: Image.asset(
                      AssetConstants.imageNotFound,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ));
              } else {
                return CardBlobImage(
                  size: const Size(200, 200),
                  radius: 10, imageBlob: blob!,
                  child: Center(
                    child: CustomIconButton(Icons.visibility, backgroundColor: Colors.grey[200]?.withOpacity(0.5), onPressed: (){

                    },),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(fieldLabel??"",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

}