import 'package:equatable/equatable.dart';

import 'home_follow_up_entity.dart';
import 'home_identity_entity.dart';

class HomeOverviewEntity extends Equatable {
  const HomeOverviewEntity({
    required this.identity,
    required this.today,
    required this.outstandingMinor,
    required this.openAccounts,
    required this.paymentsMinor,
    required this.withdrawalsMinor,
    required this.followUp,
  });
  final HomeIdentityEntity identity;
  final DateTime today;
  final int outstandingMinor;
  final int openAccounts;
  final int paymentsMinor;
  final int withdrawalsMinor;
  final List<HomeFollowUpEntity> followUp;
  @override
  List<Object?> get props => [
    identity,
    today,
    outstandingMinor,
    openAccounts,
    paymentsMinor,
    withdrawalsMinor,
    followUp,
  ];
}
