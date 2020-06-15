import 'package:url_launcher/url_launcher.dart';

class buttomFunctions {
  void launchWhatsapp() async {
    const whatsapp = 'https://wa.me/watsapp';
    if (await canLaunch(whatsapp)) {
      await launch(whatsapp);
    } else {
      throw 'Could not launch $whatsapp';
    }
  }

  void makeCall() async{
    const phonenumber = "tel:tel";

    if(await canLaunch(phonenumber)) {
      await launch(phonenumber);
    } else {
      throw 'Could not call';
    }
  }

  void createEmail() async{
    const emailaddress = 'mailto: email ?subject=Sample Subject&body=This is a Sample email';

    if(await canLaunch(emailaddress)) {
      await launch(emailaddress);
    }  else {
      throw 'Could not Email';
    }
  }
}