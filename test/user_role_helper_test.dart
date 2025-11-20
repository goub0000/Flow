import 'package:flutter_test/flutter_test.dart';
import 'package:flow_edtech/core/constants/user_roles.dart';

void main() {
  group('UserRoleHelper', () {
    test('getRoleName returns correct string for each role', () {
      expect(UserRoleHelper.getRoleName(UserRole.student), 'student');
      expect(UserRoleHelper.getRoleName(UserRole.institution), 'institution');
      expect(UserRoleHelper.getRoleName(UserRole.parent), 'parent');
      expect(UserRoleHelper.getRoleName(UserRole.counselor), 'counselor');
      expect(UserRoleHelper.getRoleName(UserRole.recommender), 'recommender');
      expect(UserRoleHelper.getRoleName(UserRole.superAdmin), 'superadmin');
      expect(UserRoleHelper.getRoleName(UserRole.regionalAdmin), 'regionaladmin');
      expect(UserRoleHelper.getRoleName(UserRole.contentAdmin), 'contentadmin');
      expect(UserRoleHelper.getRoleName(UserRole.supportAdmin), 'supportadmin');
      expect(UserRoleHelper.getRoleName(UserRole.financeAdmin), 'financeadmin');
      expect(UserRoleHelper.getRoleName(UserRole.analyticsAdmin), 'analyticsadmin');
    });

    test('fromString correctly parses role names', () {
      expect(UserRoleExtension.fromString('student'), UserRole.student);
      expect(UserRoleExtension.fromString('institution'), UserRole.institution);
      expect(UserRoleExtension.fromString('parent'), UserRole.parent);
      expect(UserRoleExtension.fromString('counselor'), UserRole.counselor);
      expect(UserRoleExtension.fromString('recommender'), UserRole.recommender);
      expect(UserRoleExtension.fromString('superadmin'), UserRole.superAdmin);
      expect(UserRoleExtension.fromString('regionaladmin'), UserRole.regionalAdmin);
      expect(UserRoleExtension.fromString('contentadmin'), UserRole.contentAdmin);
      expect(UserRoleExtension.fromString('supportadmin'), UserRole.supportAdmin);
      expect(UserRoleExtension.fromString('financeadmin'), UserRole.financeAdmin);
      expect(UserRoleExtension.fromString('analyticsadmin'), UserRole.analyticsAdmin);

      // Test default case
      expect(UserRoleExtension.fromString('unknown'), UserRole.student);
      expect(UserRoleExtension.fromString(''), UserRole.student);
    });

    test('getRoleName and fromString are symmetric', () {
      for (final role in UserRole.values) {
        final roleName = UserRoleHelper.getRoleName(role);
        final parsedRole = UserRoleExtension.fromString(roleName);
        expect(parsedRole, role);
      }
    });
  });
}