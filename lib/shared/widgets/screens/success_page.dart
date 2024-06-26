import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared.dart';

class SuccessPage extends StatefulWidget {
  final Function(BuildContext) onContinue;
  final String? message;
  final Widget Function(BuildContext)? widgetBelowButton;
  const SuccessPage({Key? key, required this.onContinue, this.message, this.widgetBelowButton}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBack:true,
      backgroundColor: Colors.white,
      noGradient: true,
      body: Container(
          padding: const EdgeInsets.all(10),

            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                SvgPicture.asset(
                  'assets/icons/check.svg',
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "SUCCESS!",
                  style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(widget.message??"Operation was successful",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    )),
                const Spacer(),

                Center(
                  child: AppTextButton(
                    buttonColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    loading: false,
                    width: MediaQuery.of(context).size.width-100,
                    label: "CONTINUE",
                    onPressed:()=> widget.onContinue(context),
                  ),
                ),
                if(widget.widgetBelowButton !=null)widget.widgetBelowButton!(context),
              ],
            ),
          ),
    );
  }
}
