import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

import 'view_certificate.dart';

class MyCertificate extends StatefulWidget {
  final UserType userType;
  const MyCertificate({super.key, required this.userType});

  @override
  State<MyCertificate> createState() => _MyCertificateState();
}

class _MyCertificateState extends State<MyCertificate> {
  final List<String> items = List.generate(10, (index) => 'Item $index');
  final Set<int> selectedItems = {};

  void toggleSelection(int index) {
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
      } else {
        selectedItems.add(index);
      }
    });
  }

  void selectAll() {
    setState(() {
      if (selectedItems.length == items.length) {
        selectedItems.clear();
      } else {
        selectedItems.clear();
        for (int i = 0; i < items.length; i++) {
          selectedItems.add(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered SMEs'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            widget.userType == UserType.lgaCoordinator
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Row(
                      children: [
                        const Text('Filter'),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_alt))
                      ],
                    ),
                  )
                : Container(),
            selectedItems.isEmpty
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: selectAll,
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_box_outlined,
                              color: selectedItems.length == items.length
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                            Text(
                              'Select All',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.file_download_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Send Email'),
                                    content: TextField(
                                      controller: TextEditingController(),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter email address',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Send',
                                          style: TextStyle(),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => NavUtils.navTo(
                      context,
                      const ViewCertificate(),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.withOpacity(0.3),
                      child: selectedItems.contains(index)
                          ? const Icon(
                              Icons.done,
                              color: Colors.red,
                            )
                          : IconButton(
                              onPressed: () => toggleSelection(index),
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                              ),
                            ),
                    ),
                    title: Text(
                      'John Doe',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: const Text('Micro'),
                    trailing: const Text(
                      'B',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: selectedItems.contains(index)
                        ? Theme.of(context).primaryColor.withOpacity(0.3)
                        : null,
                    onLongPress: () => toggleSelection(index),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
