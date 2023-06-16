import 'package:flutter/material.dart';

class PagePadding extends EdgeInsets{
  const PagePadding.pagepadding():super.symmetric(horizontal: 20.0,vertical: 10.0);
  const PagePadding.buttonpadding():super.only(left: 20.0, right: 20.0, bottom: 10.0);

  const PagePadding.all():super.all(15.0);
  const PagePadding.allmid():super.all(10.0);
  const PagePadding.alllow():super.all(5.0);



  const PagePadding.horizontalLow():super.symmetric(horizontal: 5.0);
  const PagePadding.horizontalMid():super.symmetric(horizontal: 10.0);

  


}