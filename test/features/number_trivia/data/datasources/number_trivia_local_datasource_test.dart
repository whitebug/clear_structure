import 'dart:convert';

import 'package:clear_structure/core/error/exceptions.dart';
import 'package:clear_structure/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clear_structure/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences '
      'when is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException'
      'when there is no cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(null))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(predicate((e) => e is CacheException)));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 1,
    );

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJson = json.encode(tNumberTriviaModel.toJson());
        verify(
          mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJson),
        );
      },
    );
  });
}
