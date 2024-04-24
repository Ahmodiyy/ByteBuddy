import 'dart:math';

import 'package:bytebuddy/features/auth/data/auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repo_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
@GenerateMocks([User])
@GenerateMocks([UserCredential])
void main() {
  late AuthRepo authRepo;
  late FirebaseAuth mockFirebaseAuth;
  late UserCredential mockUserCredential;
  late User mockUser;
  late String email;
  late String password;

  setUp(
    () {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();
      email = "test@example.com";
      password = "password123";
      authRepo = AuthRepo(mockFirebaseAuth);
    },
  );

  group(
    "testing for successful authentication",
    () {
      test("signUp creates user and sends verification email", () async {
        //Arrange
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .thenAnswer((invocation) => Future.value(mockUserCredential));
        when(mockUser.sendEmailVerification())
            .thenAnswer((realInvocation) => Future.value());
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final user = await authRepo.signUp(email: email, password: password);

        // Assert
        expect(user, isNotNull);
        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .called(1);
        verify(mockUser.sendEmailVerification()).called(1);
      });
      test("signIn signs in, reloads user and verifies user email", () async {
        //Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .thenAnswer((invocation) => Future.value(mockUserCredential));
        when(mockUser.reload()).thenAnswer((realInvocation) => Future.value());
        when(mockUser.emailVerified).thenReturn(true);
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final user = await authRepo.signIn(email: email, password: password);

        // Assert
        expect(user, isNotNull);
        verify(mockFirebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .called(1);
        verify(mockUser.reload()).called(1);
      });
      test("sendPasswordResetEmail sent email successfully", () async {
        //Arrange
        when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenAnswer((invocation) => Future.value());
        // Act
        await authRepo.sendPasswordResetEmail(email);

        // Assert
        verify(mockFirebaseAuth.sendPasswordResetEmail(email: email)).called(1);
      });
      test("signOut signOut current user", () async {
        //Arrange
        when(mockFirebaseAuth.signOut())
            .thenAnswer((invocation) => Future.value());
        // Act
        await authRepo.signOut();
        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
      });
      test("getCurrentUser return current logged in user", () {
        //Arrange
        when(mockFirebaseAuth.currentUser).thenAnswer((invocation) => mockUser);
        // Act
        final user = authRepo.getCurrentUser();
        // Assert
        expect(user, mockUser);
        verify(mockFirebaseAuth.currentUser).called(1);
      });
    },
  );
}
