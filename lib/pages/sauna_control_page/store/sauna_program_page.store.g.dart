// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_program_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaProgramPageStore on _SaunaProgramPageStoreBase, Store {
  late final _$_suggestedProgramResultAtom = Atom(
      name: '_SaunaProgramPageStoreBase._suggestedProgramResult',
      context: context);

  Result<List<Program>> get suggestedProgramResult {
    _$_suggestedProgramResultAtom.reportRead();
    return super._suggestedProgramResult;
  }

  @override
  Result<List<Program>> get _suggestedProgramResult => suggestedProgramResult;

  @override
  set _suggestedProgramResult(Result<List<Program>> value) {
    _$_suggestedProgramResultAtom
        .reportWrite(value, super._suggestedProgramResult, () {
      super._suggestedProgramResult = value;
    });
  }

  late final _$fetchSuggestedProgramsAsyncAction = AsyncAction(
      '_SaunaProgramPageStoreBase.fetchSuggestedPrograms',
      context: context);

  @override
  Future<void> fetchSuggestedPrograms() {
    return _$fetchSuggestedProgramsAsyncAction
        .run(() => super.fetchSuggestedPrograms());
  }

  late final _$updateSelectedProgramAsyncAction = AsyncAction(
      '_SaunaProgramPageStoreBase.updateSelectedProgram',
      context: context);

  @override
  Future<void> updateSelectedProgram(Program program) {
    return _$updateSelectedProgramAsyncAction
        .run(() => super.updateSelectedProgram(program));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
