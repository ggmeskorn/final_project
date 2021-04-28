import 'package:google_maps_flutter/google_maps_flutter.dart';

class Coffee {
  String id;
  String petsName;
  String address;
  String description;
  String thumbNail;
  LatLng locationCoords;

  Coffee(
      {this.id,
      this.petsName,
      this.address,
      this.description,
      this.thumbNail,
      this.locationCoords});
}

final List<Coffee> coffeeShops = [
  Coffee(
      petsName: 'น้อง',
      address: '',
      description: '',
      locationCoords: LatLng(16.4587249, 102.8027422),
      thumbNail: 'assets/images/pel.jpg'),
  Coffee(
      petsName: 'แพนด้า',
      address: 'กังสดาง',
      description: 'ชุมชน ',
      locationCoords: LatLng(16.4587249, 102.8027422),
      thumbNail: 'assets/images/newsdog.jpg'),
  Coffee(
      petsName: 'เก้ง',
      address: 'Oricafe',
      description: 'ร้านกาแฟ ',
      locationCoords: LatLng(16.4587249, 102.8027422),
      thumbNail: 'assets/images/newsdog.jpg'),
  Coffee(
      petsName: 'หมูตูบ',
      address: 'NpPack',
      description: 'หอพัก',
      locationCoords: LatLng(16.4587249, 102.8027422),
      thumbNail: 'assets/images/pel.jpg'),
  Coffee(
      petsName: 'Moshi',
      address: 'NpPack',
      description: 'หอพัก',
      locationCoords: LatLng(16.4587249, 102.8027422),
      thumbNail: 'assets/images/pel.jpg'),
  Coffee(
      petsName: 'กวาง',
      address: 'NpPack',
      description: 'หอพัก',
      locationCoords: LatLng(16.4587249, 102.8027422),
      thumbNail: 'assets/images/pel.jpg'),
  Coffee(
      petsName: 'ดำ',
      address: 'NpPack',
      description: 'หอพัก',
      locationCoords: LatLng(16.4591619, 102.8225225),
      thumbNail: 'assets/images/pel.jpg'),
  Coffee(
      petsName: 'หมีหวาน',
      address: 'NpPack',
      description: 'หอพัก',
      locationCoords: LatLng(16.4587249, 102.8027422),
      thumbNail: 'assets/images/pel.jpg'),
  // Coffee(
  //     petsName: 'Everyman Espresso',
  //     address: '301 W Broadway',
  //     description: 'Compact coffee',
  //     locationCoords: LatLng(40.721622, -74.004308),
  //     thumbNail: 'assets/images/newsdog.jpg')
];
