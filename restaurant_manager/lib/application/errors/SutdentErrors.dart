import 'package:restaurant_manager/application/errors/BaseError.dart';

class StudentErrorMessage {
  static const String studentNotFound = "Student not found";
  static const String studentAlreadyMarkedAsAbsent = "Student is already marked as absent";
  static const String studentAlreadyMarkedAsStayer = "Student is already marked as stayer";
  static const String studentIsNotMarkedAsAbsent = "Student is not marked as absent";
  static const String studentIsNotMarkedAsStayer = "Student is not marked as stayer";
  static const String canNotUpdateStayersAtWeekends = "Can not update stayers at weekends";
}

class StudentAlreadyMarkedAsAbsentError extends BaseError {
  StudentAlreadyMarkedAsAbsentError() : super(StudentErrorMessage.studentAlreadyMarkedAsAbsent);
}

class StudentAlreadyMarkedAsStayerError extends BaseError {
  StudentAlreadyMarkedAsStayerError() : super(StudentErrorMessage.studentAlreadyMarkedAsStayer);
}

class StudentIsNotMarkedAsAbsentError extends BaseError {
  StudentIsNotMarkedAsAbsentError() : super(StudentErrorMessage.studentIsNotMarkedAsAbsent);
}

class StudentIsNotMarkedAsStayerError extends BaseError {
  StudentIsNotMarkedAsStayerError() : super(StudentErrorMessage.studentIsNotMarkedAsStayer);
}

class CanNotUpdateStayersAtWeekendsError extends BaseError {
  CanNotUpdateStayersAtWeekendsError() : super(StudentErrorMessage.canNotUpdateStayersAtWeekends);
}

class StudentNotFoundError extends BaseError {
  StudentNotFoundError() : super(StudentErrorMessage.studentNotFound);
}