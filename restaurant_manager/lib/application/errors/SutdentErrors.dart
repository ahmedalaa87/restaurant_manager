import 'package:restaurant_manager/application/errors/BaseError.dart';

class StudentErrorMessage {
  static const String studentNotFound = "Student not found";
  static const String studentAlreadyMarkedAsAbsent = "Student is already marked as absent";
  static const String studentAlreadyMarkedAsStayer = "Student is already marked as stayer";
  static const String studentIsNotMarkedAsAbsent = "Student is not marked as absent";
  static const String studentIsNotMarkedAsStayer = "Student is not marked as stayer";
  static const String canNotUpdateStayersAtWeekends = "Can not update stayers at weekends";
  static const String canNotUpdateWeekAbsentsAtWeekends = "Can not updated week absents at weekends";
  static const String studentIsAlreadyMarkedAsWeekAbsent = "Student is already marked as week absent";
  static const String studentIsNotMarkedAsWeekAbsent = "Student isn't marked as week absent";
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

class CanNotUpdatedWeekAbsentsAtWeekendsError extends BaseError {
  CanNotUpdatedWeekAbsentsAtWeekendsError() : super(StudentErrorMessage.canNotUpdateWeekAbsentsAtWeekends);
}

class StudentIsNotMarkedAsWeekAbsentError extends BaseError {
  StudentIsNotMarkedAsWeekAbsentError() : super(StudentErrorMessage.studentIsNotMarkedAsWeekAbsent);
}

class StudentIsAlreadyMarkedAsWeekAbsentError extends BaseError {
  StudentIsAlreadyMarkedAsWeekAbsentError() : super(StudentErrorMessage.studentIsAlreadyMarkedAsWeekAbsent);
}