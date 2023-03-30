import 'package:flutter/material.dart';

class LoadIndicator extends StatelessWidget {
  const LoadIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.4),
          const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.5,
          ),

        ],
      ),
    );
  }
}