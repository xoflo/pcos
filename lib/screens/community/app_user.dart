class AppUser {
  late final String id;

  late final String name;

  late final String token;

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
