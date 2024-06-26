import 'package:flutter/material.dart';

import 'sub-widgets.dart';

class UserCard extends StatelessWidget {
  const UserCard(
      {Key? key,
      required this.profilePic,
      required this.username,
      this.address = '',
      this.aor = '',
      this.email = '',
      this.lastLogin = "-"})
      : super(key: key);

  final String profilePic;
  final String username;
  final String address;
  final String aor;
  final String email;
  final String lastLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardImage(
              imageString: profilePic,
              size: const Size(100, 100),
              radius: 15,
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "Reporter",
                      style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 230,
                      child: Text(
                        "Address: $address",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                    Text(
                      "Email: $email",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Last login: $lastLogin",
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ));
  }
}
