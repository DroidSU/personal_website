import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum UserRole { admin, user }

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final UserRole role;

  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.role = UserRole.user,
  });

  bool get isAdmin => role == UserRole.admin;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      role: data['role'] == 'admin' ? UserRole.admin : UserRole.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role == UserRole.admin ? 'admin' : 'user',
    };
  }

  @override
  List<Object?> get props => [uid, email, displayName, role];
}
