import 'package:dartz/dartz.dart';
import 'package:restaurant_manager/application/errors/BaseError.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';

abstract class IStudentService {
  Future<Either<BaseError, List<StudentModel>>> getStudents(int page);

  Future<Either<BaseError, List<StudentModel>>> queryStudents(String query);

  Future<Either<BaseError, void>> markStudentAsAbsent(int id);

  Future<Either<BaseError, void>> markStudentAsStayer(int id);

  Future<Either<BaseError, void>> unMarkStudentAsAbsent(int id);

  Future<Either<BaseError, void>> unMarkStudentAsStayer(int id);

  Future<Either<BaseError, void>> markStudentAsWeekAbsent(int id);

  Future<Either<BaseError, void>> unMarkStudentAsWeekAbsent(int id);
}