enum ReviewStatusDocument {
  pending,
  approved,
  invalid;

  static ReviewStatusDocument toEnum(String value) {
    switch (value) {
      case "approved":
        return ReviewStatusDocument.approved;
      case "invalid":
        return ReviewStatusDocument.invalid;
      case "pending":
        return ReviewStatusDocument.pending;
      default:
        return ReviewStatusDocument.invalid;
    }
  }
}
