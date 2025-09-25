enum KycStatus {
  submitted,
  approved,
  rejected,
  waiting;

  static KycStatus convertStringToEnum(String value) {
    switch (value) {
      case 'submitted':
        return KycStatus.submitted;
      case 'approved':
        return KycStatus.approved;
      case 'waiting':
        return KycStatus.waiting;
      case 'rejected':
      default:
        return KycStatus.rejected;
    }
  }
}
