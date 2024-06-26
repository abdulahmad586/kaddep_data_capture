import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/shared/models/user_model.dart';

import '../../user-management.dart';

class AllUsers extends StatelessWidget {
  final UserType type;
  const AllUsers({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    List<UserModel> dataList = [
      sampleUser,
      sampleUser2,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == UserType.fieldAgent
              ? 'Field Agent'
              : type == UserType.wardCoordinator
                  ? 'Ward Coordinator'
                  : 'Users',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return SingleUserScreen(user: dataList[index]);
                              }),
                            );
                          },
                          child: UserListItem(data: dataList[index]));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
