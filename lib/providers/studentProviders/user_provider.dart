import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/studentModels/couponModels/PurchasedCoupon.dart';
import '../../models/studentModels/couponModels/Coupon.dart';

class UserProvider with ChangeNotifier {
  String _id = FirebaseAuth.instance.currentUser.uid;
  String _name = '';
  int _points = 500;
  List<String> _purchasedCouponsId = [];
  List<PurchasedCoupon> _purchasedCoupons = [];
  StreamSubscription _subscription = null;
  StreamSubscription _couponsSubscription = null;

  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((userSnapshot) {
      if (userSnapshot != null) {
        this._id = userSnapshot.uid;
        getUserData();
      }
    });
  }

  Future<void> getUserData() async {
    this._subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(this._id)
        .snapshots()
        .listen((event) {
      final userData = event.data();

      List<dynamic> myPurchasedCoupons = userData['purchased_coupons'];
      this._name = userData['username'];
      this._points = userData['points'];
      this._purchasedCouponsId =
          myPurchasedCoupons.map((c) => c.toString()).toList();
      notifyListeners();
      getPurchasedCoupons();
    });
  }

  void logout() {
    this._id = null;
    if (this._subscription != null) {
      this._subscription.cancel();
    }
    if (this._couponsSubscription != null) {
      this._couponsSubscription.cancel();
    }
    FirebaseAuth.instance.signOut();
  }

  void addUserPoints(int points) {
    this._points = this._points + points;
    FirebaseFirestore.instance
        .collection('users')
        .doc(this._id)
        .update({'points': this._points});
    notifyListeners();
  }

  void buyCoupon(Coupon coupon) {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('purchasedCoupons').doc();
    docRef.set({
      'couponId': coupon.id,
      'userId': this._id,
      'datePurhcased': new DateTime.now(),
      'used': false,
    });
    this._points = this._points - coupon.points;
    this._purchasedCouponsId.add(docRef.id);
    FirebaseFirestore.instance.collection('users').doc(this._id).update({
      'points': this._points,
      'purchased_coupons': this._purchasedCouponsId,
    });
    notifyListeners();
    getPurchasedCoupons();
  }

  void useCoupon(String purchasedCouponId) {
    FirebaseFirestore.instance
        .collection('purchasedCoupons')
        .doc(purchasedCouponId)
        .update({
      'used': true,
    });
    // FirebaseFirestore.instance.collection('users').doc(this._id).update({
    //   'purchased_coupons': this._purchasedCouponsId,
    // });
    notifyListeners();
    getPurchasedCoupons();
  }

  void getPurchasedCoupons() {
    if (_couponsSubscription != null) {
      this._couponsSubscription.cancel();
    }
    List<PurchasedCoupon> purchasedCoupons = [];
    if (_purchasedCouponsId.isNotEmpty) {
      _couponsSubscription = FirebaseFirestore.instance
          .collection('purchasedCoupons')
          .where('userId', isEqualTo: this._id)
          .snapshots()
          .listen((event) {
        event.docs.forEach((doc) {
          Map<String, dynamic> json = doc.data();
          purchasedCoupons.add(PurchasedCoupon.fromJson(json, doc.id));
        });
        this._purchasedCoupons = purchasedCoupons;
        notifyListeners();
      });
    }
  }

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  int get points {
    return _points;
  }

  bool get isAuth {
    return _name != '';
  }

  List<String> get myCouponsID {
    return [..._purchasedCouponsId];
  }

  List<PurchasedCoupon> get myPurchasedCoupons {
    return [..._purchasedCoupons];
  }

  List<PurchasedCoupon> getMyAvailablePurchasedCoupons() {
    List<PurchasedCoupon> availablePurchasedCoupons = [];
    _purchasedCoupons.forEach((c) {
      if (!c.used) {
        availablePurchasedCoupons.add(c);
      }
    });
    return availablePurchasedCoupons;
  }

  List<PurchasedCoupon> getMyUsedPurchasedCoupons() {
    List<PurchasedCoupon> usedPurchasedCoupons = [];
    _purchasedCoupons.forEach((c) {
      if (c.used) {
        usedPurchasedCoupons.add(c);
      }
    });
    return usedPurchasedCoupons;
  }
}