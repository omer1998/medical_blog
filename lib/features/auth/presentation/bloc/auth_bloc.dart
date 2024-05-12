import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final UserStateUseCase _userStateUseCase;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required SignUpUseCase signUpUseCase,
      required SignInUseCase signInUseCase,
      required UserStateUseCase userStateUseCase,
      required AppUserCubit appUserCubit})
      : _signUpUseCase = signUpUseCase,
        _signInUseCase = signInUseCase,
        _userStateUseCase = userStateUseCase,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);

    on<SignInEvent>(_onSignIn);
    on<UserStateEvent>(_onUserState);
  }

  void _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final either = await _signUpUseCase(event.data);
    either.fold((f) {
      return emit(AuthFailure(f.message));
    }, (user) {
      return emit(AuthSuccess(user));
    });
  }

  void _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final either = await _signInUseCase(event.data);
    either.fold((l) => emit(AuthFailure(l.message)), (user) {
      // _appUserCubit.updateUser(user);
      // emit(AuthSuccess(user));
      _emitAuthSuccess(emit, user);
    });
  }

  void _onUserState(UserStateEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final either = await _userStateUseCase(event.noParams);
    either.fold((l) => emit(AuthFailure(l.message)), (r) {
      if (r != null) {
        return _emitAuthSuccess(emit, r);
      } else {
        // mean user == null ==> which mean the user is logged out
        // we need to update the app user state
        _appUserCubit.updateUser(null);
        return emit(AuthFailure("User is null ..."));
      }
    });
  }

  void _emitAuthSuccess(Emitter<AuthState> emit, UserEntity user) {
    _appUserCubit.updateUser(user);
    return emit(AuthSuccess(user));
  }
}
