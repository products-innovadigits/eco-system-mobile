import 'package:flutter/material.dart';
class CustomErrorWidget extends StatelessWidget {
  final String? error;
  const CustomErrorWidget({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline , color: Colors.red, size: 12,),
          const SizedBox(width: 5,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(error! , style: const TextStyle(color: Colors.red ,fontWeight: FontWeight.w400, fontSize: 12),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
