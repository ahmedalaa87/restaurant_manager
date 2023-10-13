class InvalidAccessTokenException implements Exception {}

class InvalidRefreshTokenException implements Exception {}

class ServerException implements Exception {}

class WrongEmailOrPasswordException implements Exception {}

class MealNotFoundException implements Exception {}

class StudentNotFoundException implements Exception {}

class StudentIsAlreadyAbsentTodayException implements Exception {}

class CanNotUpdateStayersAtWeekendsException implements Exception {}

class StudentIsAlreadyMarkedAsStayerException implements Exception {}

class StudentIsNotAbsentTodayException implements Exception {}

class StudentIsNotMarkedAsAStayerException implements Exception {}

class MealTypeNotFoundException implements Exception {}

class MealWithTypeAlreadyCreatedTodayException implements Exception {}

class AddStudentToMealBadRequestException implements Exception {
  final String message;
  AddStudentToMealBadRequestException(this.message);
}

class WrongPasswordException implements Exception {}

class StudentIsAlreadyMarkedAsWeekAbsentException implements Exception {}

class StudentIsNotMarkedAsWeekAbsentException implements Exception {}

class CanNotUpdateWeekAbsentsAtWeekendsException implements Exception {}