import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/shared/util/build_context_extension.dart';
import 'package:kaddep_data_capture/shared/widgets/sub-widgets/buttons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewCertificate extends StatelessWidget {
  const ViewCertificate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My certificate'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Share.shareXFiles([
                XFile('assets/certificate.pdf'),
              ], text: 'My Certificate');

              if (result.status == ShareResultStatus.success) {
                // ignore: use_build_context_synchronously
                context.showSnackBar('Thank you for sharing the picture!');
              }
            },
            icon: Icon(
              Icons.share,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.asset('assets/certificate.pdf'),
          ),
          const SizedBox(height: 15),
          Center(
            child: AppTextButton(
              buttonColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              loading: false,
              width: 310,
              label: "Download",
              icon: Icons.file_download_rounded,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: AppTextButton(
              buttonColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              loading: false,
              width: 310,
              label: "Email",
              icon: Icons.email_rounded,
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
                            // final String email =
                            //     emailController.text;
                            // Implement your send email functionality here
                            Navigator.of(context).pop();
                            // Show confirmation or proceed with the email sending logic
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
