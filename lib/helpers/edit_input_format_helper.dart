import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:eco_system/core/app_core.dart';
import 'package:eco_system/core/app_notification.dart';

import 'styles.dart';

class CurrencyInputFormatter extends TextInputFormatter {


  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (newValue.text.length <= 2) {
      double value = double.parse(newValue.text);

      final formatter = NumberFormat.currency(locale: 'en', decimalDigits: 0 ,);

      String newText = formatter.format(value);

      return newValue.copyWith(
          text: newText,
          selection: new TextSelection.collapsed(offset: newText.length));
    } else {
      AppCore.showSnackBar(notification: AppNotification(message: "Maximum text 2 characters exceeded",backgroundColor: Styles.IN_ACTIVE,borderColor: Styles.DARK_RED,iconName: "fill-close-circle"));
      return newValue.copyWith(text: oldValue.text);
    }
  }
}

//
class DaysInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (int.parse(newValue.text) <= 30) {

      return newValue.copyWith(text: newValue.text);
    } else {
      return newValue.copyWith(text: oldValue.text);
    }
  }
}
class PercentageInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (int.parse(newValue.text) <= 100) {

      return newValue.copyWith(text: newValue.text);
    } else {
      return newValue.copyWith(text: oldValue.text);
    }
  }
}
//
// class DiscountInputFormatter extends TextInputFormatter {
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.selection.baseOffset == 0) {
//       print(true);
//       return newValue;
//     }
//     if (newValue.text.length <= 4) {
//       if(!newValue.text.contains('%')){
//         return newValue.copyWith(text: newValue.text + "%");
//       }else{
//         return newValue.copyWith(text: newValue.text);
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Maximum text 3 characters exceeded");
//       return newValue.copyWith(text: oldValue.text);
//     }
//   }
// }
//
// class DescriptionInputFormatter extends TextInputFormatter {
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (RegExp("^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF\d{5,10}a-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF\d{5,10}a-zA-Z-_]*\$").hasMatch(newValue.text)) {
//       return newValue.copyWith(text: newValue.text);
//     } else {
//       Fluttertoast.showToast(msg: "Please enter text only");
//       return newValue.copyWith(text: oldValue.text);
//     }
//   }
// }
//
// // class LinkInputFormatter extends TextInputFormatter {
// //
// //   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
// //     if(newValue.selection.baseOffset == 0){
// //       print(true);
// //       return newValue;
// //     }
// //     return newValue.copyWith(text: "https://www.${newValue.text}.com");
// //   }
// // }
//
// class DescriptionFormatter extends TextInputFormatter {
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.text.length <= 150) {
//       return newValue.copyWith(text: newValue.text);
//     } else {
//       Fluttertoast.showToast(msg: "Maximum text 150 characters exceeded");
//       return newValue.copyWith(text: oldValue.text);
//     }
//   }
// }
//
// class TitleFormatter extends TextInputFormatter {
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.text.length <= 35) {
//       return newValue.copyWith(text: newValue.text);
//     } else {
//       Fluttertoast.showToast(msg: "Maximum text 35 characters exceeded");
//       return newValue.copyWith(text: oldValue.text);
//     }
//   }
// }
//
// class NoteFormatter extends TextInputFormatter {
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.text.length <= 30) {
//       return newValue.copyWith(text: newValue.text);
//     } else {
//       Fluttertoast.showToast(msg: "Maximum text 25 characters exceeded");
//       return newValue.copyWith(text: oldValue.text);
//     }
//   }
// }
