import 'package:flutter_test/flutter_test.dart';
import 'package:power_saving/core/errors/failures.dart';
import 'package:power_saving/core/utils/result.dart';
import 'package:power_saving/features/auth/model/login.dart';

void main() {
  group('Enterprise Monadic Result Tests', () {
    test('Result.success holds expected value and folds correctly', () {
      final user = User(
        empCode: '123',
        empName: 'علي مجاهد',
        groupId: 1,
        groupName: 'المديرون',
        isActive: true,
        username: 'alimegahed',
      );

      final Result<User> result = Result.success(user);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);

      result.fold(
        (data) {
          expect(data.empName, equals('علي مجاهد'));
          expect(data.username, equals('alimegahed'));
        },
        (failure) {
          fail('Should not enter failure path');
        },
      );
    });

    test('Result.failure holds failure info and folds correctly', () {
      const failure = NetworkFailure('لا يوجد اتصال بالإنترنت', statusCode: 503);
      final Result<User> result = Result.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);

      result.fold(
        (data) {
          fail('Should not enter success path');
        },
        (failInfo) {
          expect(failInfo.message, equals('لا يوجد اتصال بالإنترنت'));
          expect(failInfo.statusCode, equals(503));
        },
      );
    });
  });
}
