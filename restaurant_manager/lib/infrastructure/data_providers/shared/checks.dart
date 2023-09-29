import 'package:jwt_decode/jwt_decode.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/utils.dart';


bool checkTokenIntegrity(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  return !_checkIfTokenIsExpired(payload);
}

bool _checkIfTokenIsExpired(Map<String, dynamic> payload) {
  return payload["exp"] + 60 < getCurrentTimeStamp();
}