import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class ItemsPurchasedEditor extends StatefulWidget {
  final String? category;
  final Function({required String itemsList, required Uint8List receipt}) onSave;

  const ItemsPurchasedEditor(this.onSave, {this.category, super.key});

  @override
  State<StatefulWidget> createState() {
    return _ItemsPurchasedEditorState();
  }
}

class _ItemsPurchasedEditorState extends State<ItemsPurchasedEditor> {
  String? photoPath;
  GlobalKey<FormState> formKey = GlobalKey();

  String? message;

  String? itemsList;

  void updateError(String error) {
    setState(() {
      message = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                "Add Items Purchased",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 20),
              AppTextField(
                validator: (text) =>
                text == null || text.isEmpty ? "Field is required" : null,
                labelText: "Items list",
                keyboardType: TextInputType.text,
                onChange: (s) => setState(() => itemsList = s),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  ImagePickZone(photoPath, (path) {
                    setState(() {
                      photoPath = path;
                    });
                  }, fieldLabel: "Capture receipt showing items mentioned", isDocument: true),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                      message ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.red),
                    )),
              ),
              AppTextButton(
                  label: "Next",
                  buttonColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width -100,
                  onPressed: () async{
                    if (photoPath == null) {
                      updateError("Please capture receipt");
                      return;
                    }

                    widget.onSave(
                        itemsList: itemsList!, receipt: await FileUtils.imageToBlob(photoPath!));
                  })
            ],
          ),
        ),
      ),
    );
  }
}