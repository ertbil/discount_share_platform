import 'package:flutter/material.dart';
import 'package:solutionchallenge/constants/strings/error_strings.dart';


class ErrorView extends StatelessWidget {
  final Object error;

  const ErrorView({Key? key,  required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.4),
            const Icon(Icons.error, color: Colors.red, size: 60),
             Text(ErrorStrings.errorOccurredWithMessage + error.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.5,
            ),


          ],
        ),
      ),
    );
  }
}