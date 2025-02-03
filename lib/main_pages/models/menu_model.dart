import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/main_pages/widgets/menu_card.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';

class MenuModel{
  final String? title ;
  final String? imageName ;
  final GestureTapCallback? onTap ;
  final bool? isLogout ;

  MenuModel( this.imageName , this.title, this.onTap , {this.isLogout = false});

  static List<MenuModel> generateModelList(){
    List<MenuModel> models = [
      MenuModel("my_profile", allTranslations.text('my_profile') , (){
        CustomNavigator.push(Routes.PROFILE);
        // Fluttertoast.showToast(msg: "Still Working On It");
      }),
      MenuModel("self_service", allTranslations.text('self_service'), (){
      }),
      // }),
      MenuModel("find_user", allTranslations.text('find_user'), (){
      }),
      MenuModel("contact_us", allTranslations.text('contact_us'), (){
      }),
      MenuModel("setting-2", allTranslations.text('setting'), ()async{
        String currentLang = await allTranslations.getPreferredLanguage();
        String lang = currentLang == 'ar' ? 'en': 'ar';
        allTranslations.setNewLanguage(lang, true);
        allTranslations.setPreferredLanguage(lang);
      }),
      // MenuModel("geofence", allTranslations.text('geofence'), (){
      //   CustomNavigator.push(Routes.GEOFENCE);
      // }),
      // MenuModel("beacons", allTranslations.text('beacons'), (){
      //   CustomNavigator.push(Routes.BEACONS);
      // }),
  //    MenuModel("active_hours", allTranslations.text('active_hours'), (){}),
      // MenuModel("requests", allTranslations.text('requests'), (){}),
      // MenuModel("change_lang", allTranslations.text('change_lang'), (){}),
      MenuModel("logout", allTranslations.text('logout'), (){
        SharedHelper.sharedHelper!.logout();
      } , isLogout: true),
    ];
    return  models;
  }

  static List<Widget> generateMenuCards(){
    List<MenuCard> cards = [];
    generateModelList().forEach((model) {
      cards.add(MenuCard(model: model,));
    });
    return cards ;
  }
}