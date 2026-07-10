// lib/services/session_service.dart

class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  // ── Fields shown on the profile screen ────────────────────────────────────
  String? accessToken;
  String? firstName;   // "Super"
  String? lastName;    // "Admin"
  String? email;       // "superadmin@elevate.org"
  String? phone;       // "Not provided"
  String? gender;      // "Male"
  String? hub;         // "Not assigned"
  String? role;        // "Super Admin"
  String? status;      // "Active"
  String? memberStatus;// "Enrolled"

  // ── Helpers ────────────────────────────────────────────────────────────────
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  String get initials {
    final f = firstName?.isNotEmpty == true ? firstName![0].toUpperCase() : '';
    final l = lastName?.isNotEmpty  == true ? lastName![0].toUpperCase()  : '';
    return '$f$l'.isNotEmpty ? '$f$l' : '?';
  }

  bool get isLoggedIn => accessToken != null;

  // ── Populate from login API response ──────────────────────────────────────
  void saveFromLoginResponse(Map<String, dynamic> data) {
    accessToken  = data['token']         as String?
                ?? data['accessToken']   as String?
                ?? data['access_token']  as String?;

    final user = data['user'] as Map<String, dynamic>?;
    final src  = user ?? data; // some backends nest under 'user', some don't

    firstName    = src['firstName']    as String?
                ?? src['first_name']   as String?;
    lastName     = src['lastName']     as String?
                ?? src['last_name']    as String?;
    email        = src['email']        as String?;
    phone        = src['phone']        as String?
                ?? src['phoneNumber']  as String?;
    gender       = src['gender']       as String?;
    hub          = src['hub']          as String?;
    role         = src['role']         as String?;
    status       = src['status']       as String?;
    memberStatus = src['memberStatus'] as String?
                ?? src['member']       as String?;
  }

  // ── Clear on logout ────────────────────────────────────────────────────────
  void clear() {
    accessToken  = null;
    firstName    = null;
    lastName     = null;
    email        = null;
    phone        = null;
    gender       = null;
    hub          = null;
    role         = null;
    status       = null;
    memberStatus = null;
  }
}
