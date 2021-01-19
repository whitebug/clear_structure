import 'package:clear_structure/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_structure/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clear_structure/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:clear_structure/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10.0),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: NumberTrivia(
                        text: state.trivia.text,
                        number: state.trivia.number,
                      ),
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  }
                  return MessageDisplay(message: 'Unexpected error');
                },
              ),
              SizedBox(height: 20.0),
              // Bottom half
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}

