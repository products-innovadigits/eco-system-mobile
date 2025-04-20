import 'dart:async';

import 'package:eco_system/helpers/text_helper.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/utility.dart';
import 'package:flutter/material.dart';

class Validator {
  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('ادخل البريد الإكتروني بشكل صحيح');
    }
  });
  var nameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink) {
      if (name.length > 2) {
        sink.add(name);
      } else {
        sink.addError('ادخل الاسم بشكل صحيح');
      }
    },
  );

  var number = StreamTransformer<String, String>.fromHandlers(
      handleData: (dynamic num, sink) {
    if (num.length > 9) {
      sink.add(num);
    } else {
      sink.addError('يجب ان يكون رقم الجوال من 10 خانات');
    }
  });

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 7) {
        sink.add(password);
      } else {
        sink.addError('يجب ان لا تقل كلمة المرور عن 8 خانات');
      }
    },
  );

  var confirmPassWordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 7) {
        sink.add(password);
      } else {
        sink.addError('تأكيد كلمة المرور خاطئ');
      }
    },
  );
}

class EmailValidator {
  static String? emailValidator(String? email) {
    if (email!.length < 10 || !email.contains("@")) {
      return allTranslations.text("please_enter_valid_email");
    }
    return null;
  }
}

class PasswordValidator {
  static String? passwordValidator(var password) {
    if (password!.length < 6) {
      return allTranslations.text("please_enter_valid_password");
    }
    return null;
  }
}

class PasswordConfirmationValidator {
  static String? passwordValidator(String? password, BuildContext context) {
    if (password!.length < 8) {
      return allTranslations.text("confirm_password");
    }
    // else if (!password
    //     .contains(context.read<RegisterBloc>().password.value)) {
    //   return allTranslations.text('confirmed_password_match_password');
    // }
    return null;
  }
}

class ChangePasswordConfirmationValidator {
  static passwordValidator(String? password, BuildContext context) {
    if (password!.length < 6) {
      return allTranslations.text("confirm_password");
    }
    // else if (password != context.read<PasswordBloc>().newPassword.value) {
    //   return allTranslations.text('confirmed_password_match_password');
    // }
    return null;
  }
}

class PhoneValidator {
  static String? phoneValidator(String? phone) {
    cprint(RegExp(Constants.PHONE_EXP).hasMatch(phone!.trim()));
    cprint(phone.length == 11);
    if (phone.length != 11 ||
        RegExp(Constants.PHONE_EXP).hasMatch(phone.trim()) == false) {
      return allTranslations.text("please_enter_valid_phone_number");
    }
    return null;
  }
}

class NameValidator {
  static String? nameValidator(var name) {
    if (name!.length < 2) {
      return allTranslations.text("please_enter_valid_user_name");
    }
    return null;
  }
}

class TitleValidator {
  static String? nameValidator(String? name) {
    if (name!.length < 2) {
      return allTranslations.text("please_enter_valid_title");
    } else if (name.contains('٠١٥') ||
        name.contains('٠١٢') ||
        name.contains('٠١١') ||
        name.contains('٠١٠') ||
        name.contains('015') ||
        name.contains('012') ||
        name.contains('011') ||
        name.contains('010') ||
        name.contains('http://') ||
        name.contains('https://')) {
      return allTranslations.text("please_enter_valid_title_without_phone");
    }
    return null;
  }
}

class DescriptionValidator {
  static String? descriptionValidator(String? name) {
    // String pattern =
    //     '^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z][0-9]{5}*\$';
    // String pattern = '[a-z]+^[0-9]{5}\$';
    // String pattern = '^[A-Z]{3}[A-Z]{3}[0-9]{4}\$';
    //  RegExp regExp = RegExp(pattern);
    //  if (!regExp.hasMatch(name.trim())) {
    //    print("RegExp Name : "+name);
    //    return allTranslations.text("please_enter_valid_description");
    //  }
    if (name!.length < 2) {
      return allTranslations.text("please_enter_valid_description");
    } else if (name.contains('٠١٥') ||
        name.contains('٠١٢') ||
        name.contains('٠١١') ||
        name.contains('٠١٠') ||
        name.contains('015') ||
        name.contains('012') ||
        name.contains('011') ||
        name.contains('010') ||
        name.contains('http://') ||
        name.contains('https://')) {
      return allTranslations
          .text("please_enter_valid_description_without_phone");
    }
    return null;
  }
}

class NoteValidator {
  static String? nameValidator(String? name) {
    if (name!.length < 2) {
      return allTranslations.text("please_enter_valid_description");
    }
    return null;
  }
}

class PriceValidator {
  static String? priceValidator(String? price) {
    double doublePrice = double.parse(price!);
    if (doublePrice < 1) {
      return allTranslations.text("please_enter_valid_price");
    }
    return null;
  }
}

class PriceToValidator {
  static String? priceValidator(
      String? price, String? stringPriceFrom, BuildContext context) {
    double priceTo = double.parse(price!);
    if (priceTo > 1) {
      double priceFrom = double.parse(stringPriceFrom!);
      if (priceTo < priceFrom) {
        return allTranslations.text("please_enter_valid_price");
      }
    } else {
      return allTranslations.text("please_enter_valid_price");
    }
    return null;
  }
}

class DiscountValidator {
  static String? discountValidator(String? discount) {
    if (discount?.isNotEmpty == true ||
        double.parse(discount ?? "0") > 100.00) {
      return allTranslations.text("please_enter_valid_discount");
    }
    return null;
  }
}

class LinkValidator {
  static String? linkValidator(String? link) {
    if (!link!.contains("http")) {
      return allTranslations.text("please_enter_valid_link");
    }
    return null;
  }
}
