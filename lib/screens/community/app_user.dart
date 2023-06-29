//ignore: public_member_api_docs
class AppUser {
  //ignore: public_member_api_docs

  //ignore: public_member_api_docs
  late final String id;

  //ignore: public_member_api_docs
  late final String name;

  //ignore: public_member_api_docs
  late final String token;

  //ignore: public_member_api_docs
  Map<String, Object> get data {
    final parts = name.split(' ');
    return {
      'first_name': parts[0],
      'last_name': parts[1],
      'full_name': name,
    };
  }
}

const appUsers = [];
