import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jodhere/features/profile/presentation/cubit/profile_state.dart';
import 'package:jodhere/features/profile/data/repositories/profile_repository.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(const ProfileState());

  Future<void> fetchProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final profile = await _repository.fetchProfile();

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateProfile({
    String? phone,
    required String displayName,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final updatedProfile = await _repository.updateProfile(
        displayName: displayName,
        phone: phone,
      );

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: updatedProfile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}