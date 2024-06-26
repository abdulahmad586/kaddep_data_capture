import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class SingleUserScreen extends StatelessWidget {
  final UserModel user;
  const SingleUserScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBack: true,
      backgroundColor: Colors.white,
      noGradient: true,
      body: SafeArea(child: UserCard(user: user)),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: CardImage(imageString: user.pictureUrl, size: Size(100,100),radius: 100,),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text('${user.firstName} ${user.lastName}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading:
                  Icon(Icons.phone, color: Theme.of(context).primaryColor),
              title: Text(user.phoneNumber),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(Icons.location_city,
                  color: Theme.of(context).primaryColor),
              title: Text(user.lga),
            ),
          ),
          if (user.ward != null)
            Card(
              child: ListTile(
                leading: Icon(Icons.account_balance,
                    color: Theme.of(context).primaryColor),
                title: Text('${user.ward}'),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
