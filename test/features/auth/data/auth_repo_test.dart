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
@GenerateMocks([UserCredential])
void main() {
  late AuthRepo authRepo;
  late FirebaseAuth mockFirebaseAuth;
  late UserCredential mockUserCredential;
  late User mockUser;
  late String email;
  late String password;
  late String invalidEmail;
  late String weakPassword;

  setUp(
    () {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();
      email = "test@example.com";
      password = "password123";
      invalidEmail = "test.com";
      weakPassword = "pass";
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

  group(
    "testing for unsuccessful authentication",
    () {
      test("signUp throws exception on FirebaseAuthError", () async {
        // Arrange
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: email, password: weakPassword))
            .thenThrow(FirebaseAuthException(code: 'weak-password'));

        // Act & Assert
        expect(authRepo.signUp(email: email, password: weakPassword),
            throwsA(isA<FirebaseAuthException>()));
        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: email, password: weakPassword))
            .called(1);
      });
      test("signIn throws exception on FirebaseAuthException", () async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));

        // Act & Assert
        expect(authRepo.signIn(email: email, password: password),
            throwsA(isA<FirebaseAuthException>()));
        verify(mockFirebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .called(1);
      });
      test("sendPasswordResetEmail throws exception on FirebaseAuthException",
          () async {
        // Arrange
        when(mockFirebaseAuth.sendPasswordResetEmail(email: invalidEmail))
            .thenThrow(FirebaseAuthException(code: 'invalid-email'));

        // Act & Assert
        expect(authRepo.sendPasswordResetEmail(invalidEmail),
            throwsA(isA<FirebaseAuthException>()));
        verify(mockFirebaseAuth.sendPasswordResetEmail(email: invalidEmail))
            .called(1);
      });
      test("signOut throws exception on FirebaseAuthException", () async {
        // Arrange
        when(mockFirebaseAuth.signOut())
            .thenThrow(FirebaseAuthException(code: 'some-error-code'));

        // Act & Assert
        expect(authRepo.signOut(), throwsA(isA<FirebaseAuthException>()));
        verify(mockFirebaseAuth.signOut()).called(1);
      });
      test("getCurrentUser returns null if no user is logged in", () {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final user = authRepo.getCurrentUser();

        // Assert
        expect(user, isNull);
        verify(mockFirebaseAuth.currentUser).called(1);
      });
    },
  );
}
