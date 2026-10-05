import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/facility_tracking_entity.dart';

part 'facility_tracking_provider.g.dart';

/// Facility and attendant pins for the Facility Tracking map.
///
/// WHY hardcoded: the screen is built UI-first. Swap the body for the
/// `GET /partners/{id}/facility-map` use case once that is wired — the page
/// only depends on [FacilityTrackingEntity].
@riverpod
Future<FacilityTrackingEntity> facilityTracking(Ref ref) async {
  return const FacilityTrackingEntity(
    facilities: [
      FacilityPinEntity(
        id: 37,
        name: 'Brain Station 23',
        nameBn: 'ব্রেইন স্টেশন ২৩',
        address: '620 Rd Number 9, Dhaka',
        partnerName: 'Brainstation 23',
        lat: 23.8371638,
        lng: 90.3661021,
        status: FacilityPinStatus.active,
      ),
      FacilityPinEntity(
        id: 45,
        name: 'Brain Station Mirpur',
        nameBn: 'ব্রেইন স্টেশন মিরপুর',
        address: 'Mirpur DOHS, Dhaka',
        partnerName: 'Brainstation 23',
        lat: 23.8069,
        lng: 90.3687,
        status: FacilityPinStatus.active,
      ),
      FacilityPinEntity(
        id: 80,
        name: 'Dhanmondi',
        nameBn: 'ধানমণ্ডি',
        address: 'Road 27, Dhanmondi, Dhaka',
        partnerName: 'Brainstation 23',
        lat: 23.7461,
        lng: 90.3742,
        status: FacilityPinStatus.maintenance,
      ),
      FacilityPinEntity(
        id: 52,
        name: 'Najira Bazar, Puran Dhaka',
        nameBn: 'নাজিরা বাজার, পুরান ঢাকা',
        address: 'Najira Bazar, Old Dhaka',
        partnerName: 'Brainstation 23',
        lat: 23.7104,
        lng: 90.4074,
        status: FacilityPinStatus.active,
      ),
      FacilityPinEntity(
        id: 61,
        name: 'Tongi, Chankhar Pool',
        nameBn: 'টঙ্গী, চানখারপুল',
        address: 'Chankhar Pool, Tongi',
        partnerName: 'Brainstation 23',
        lat: 23.8917,
        lng: 90.4003,
        status: FacilityPinStatus.inactive,
      ),
      FacilityPinEntity(
        id: 79,
        name: 'Gazipur',
        nameBn: 'গাজীপুর',
        address: 'Gazipur Chowrasta',
        partnerName: 'Brainstation 23',
        lat: 24.0023,
        lng: 90.4264,
        status: FacilityPinStatus.active,
      ),
    ],
    staff: [
      StaffPinEntity(
        id: 137,
        uid: 'BS2552',
        name: 'AMIR-BS1968',
        phoneNumber: '01761443869',
        facilityId: 37,
        facilityName: 'Brain Station 23',
        facilityNameBn: 'ব্রেইন স্টেশন ২৩',
        status: StaffPinStatus.free,
        lat: 23.8372,
        lng: 90.3663,
      ),
      StaffPinEntity(
        id: 92,
        uid: 'BS2935',
        name: 'Jorina Begum',
        nameBn: 'জরিনা বেগম',
        phoneNumber: '01712345678',
        facilityId: 45,
        facilityName: 'Brain Station Mirpur',
        facilityNameBn: 'ব্রেইন স্টেশন মিরপুর',
        status: StaffPinStatus.working,
        lat: 23.8071,
        lng: 90.3690,
        address: 'Mirpur DOHS, Dhaka',
      ),
      StaffPinEntity(
        id: 98,
        uid: 'BS3011',
        name: 'Abu Bokor Attendant',
        nameBn: 'আবু বকর',
        phoneNumber: '01898765432',
        facilityId: 80,
        facilityName: 'Dhanmondi',
        facilityNameBn: 'ধানমণ্ডি',
        status: StaffPinStatus.working,
        lat: 23.7463,
        lng: 90.3745,
      ),
      StaffPinEntity(
        id: 104,
        uid: 'BS3120',
        name: 'Shahin Bashar',
        facilityId: 79,
        facilityName: 'Gazipur',
        facilityNameBn: 'গাজীপুর',
        status: StaffPinStatus.contractEnded,
        lat: 24.0021,
        lng: 90.4261,
      ),
    ],
  );
}
