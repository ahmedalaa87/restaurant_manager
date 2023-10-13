import 'package:dartz/dartz.dart';
import 'package:restaurant_manager/application/errors/BaseError.dart';
import 'package:restaurant_manager/application/errors/SutdentErrors.dart';
import 'package:restaurant_manager/application/services/students/IStudentService.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';
import 'package:restaurant_manager/infrastructure/data_providers/StudentsDataProvider.dart';
import 'package:restaurant_manager/infrastructure/network_status/network_status.dart';

import '../../../infrastructure/auth/AuthInfo.dart';
import '../../../infrastructure/data_providers/shared/exceptions.dart';
import '../../errors/AuthErrors.dart';
import '../../errors/GeneralErrors.dart';

class StudentService implements IStudentService {
  final IStudentDataProvider studentDataProvider;
  final INetworkStatus networkStatus;

  StudentService({required this.studentDataProvider, required this.networkStatus});

  @override
  Future<Either<BaseError, List<StudentModel>>> getStudents(int page) async {
    if (!await networkStatus.isConnected()) {
    return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
    return Left(InvalidAccessTokenError());
    }

    try {
    List<StudentModel> students = await studentDataProvider.getStudents(page);

    return Right(students);
    } on ServerException {
    return Left(ServerError());
    } on InvalidRefreshTokenException {
    return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
    return Left(InvalidAccessTokenError());
    }
  }

  @override
  Future<Either<BaseError, void>> markStudentAsAbsent(int id) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      await studentDataProvider.markStudentAsAbsent(id);

      return const Right(null);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on StudentNotFoundException {
      return Left(StudentNotFoundError());
    } on StudentIsAlreadyAbsentTodayException {
      return Left(StudentAlreadyMarkedAsAbsentError());
    }
  }

  @override
  Future<Either<BaseError, void>> markStudentAsStayer(int id) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      await studentDataProvider.markStudentAsStayer(id);

      return const Right(null);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on StudentNotFoundException {
      return Left(StudentNotFoundError());
    } on StudentIsAlreadyMarkedAsStayerException {
      return Left(StudentAlreadyMarkedAsStayerError());
    } on CanNotUpdateStayersAtWeekendsException {
      return Left(CanNotUpdateStayersAtWeekendsError());
    }
  }

  @override
  Future<Either<BaseError, List<StudentModel>>> queryStudents(String query) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      List<StudentModel> students = await studentDataProvider.queryStudents(query);

      return Right(students);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    }
  }

  @override
  Future<Either<BaseError, void>> unMarkStudentAsAbsent(int id) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      await studentDataProvider.unMarkStudentAsAbsent(id);

      return const Right(null);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on StudentNotFoundException {
      return Left(StudentNotFoundError());
    } on StudentIsNotAbsentTodayException {
      return Left(StudentIsNotMarkedAsAbsentError());
    }
  }

  @override
  Future<Either<BaseError, void>> unMarkStudentAsStayer(int id) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      await studentDataProvider.unMarkStudentAsStayer(id);

      return const Right(null);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on StudentNotFoundException {
      return Left(StudentNotFoundError());
    } on StudentIsNotMarkedAsAStayerException {
      return Left(StudentIsNotMarkedAsStayerError());
    } on CanNotUpdateStayersAtWeekendsException {
      return Left(CanNotUpdateStayersAtWeekendsError());
    }
  }

  @override
  Future<Either<BaseError, void>> markStudentAsWeekAbsent(int id) async {
    if (!await networkStatus.isConnected()) {
    return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
    return Left(InvalidAccessTokenError());
    }

    try {
    await studentDataProvider.markStudentAsWeekAbsent(id);

    return const Right(null);
    } on ServerException {
    return Left(ServerError());
    } on InvalidRefreshTokenException {
    return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
    return Left(InvalidAccessTokenError());
    } on StudentNotFoundException {
    return Left(StudentNotFoundError());
    } on StudentIsAlreadyMarkedAsWeekAbsentException {
    return Left(StudentIsAlreadyMarkedAsWeekAbsentError());
    } on CanNotUpdateWeekAbsentsAtWeekendsException {
    return Left(CanNotUpdatedWeekAbsentsAtWeekendsError());
    }
  }

  @override
  Future<Either<BaseError, void>> unMarkStudentAsWeekAbsent(int id) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      await studentDataProvider.unMarkStudentAsWeekAbsent(id);

      return const Right(null);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on StudentNotFoundException {
      return Left(StudentNotFoundError());
    } on StudentIsNotMarkedAsWeekAbsentException {
      return Left(StudentIsNotMarkedAsWeekAbsentError());
    } on CanNotUpdateWeekAbsentsAtWeekendsException {
      return Left(CanNotUpdatedWeekAbsentsAtWeekendsError());
    }
  }
  
}