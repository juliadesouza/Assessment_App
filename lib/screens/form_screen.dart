import 'package:assessment_app/constants/colors.dart';
import 'package:assessment_app/database/form_database.dart';
import 'package:assessment_app/logic/form/form_bloc.dart' as form_bloc;
import 'package:assessment_app/model/question.dart';
import 'package:assessment_app/screens/answers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/question_widget.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.code}) : super(key: key);

  final String code;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int _currentStep = 0;

  _stepState(int step, Question question) {
    if (_currentStep != step && question.answer != "") {
      return CustomStepState.complete;
    } else {
      return CustomStepState.editing;
    }
  }

  List<CustomStep> _steps(questions) {
    List<CustomStep> arr = [];

    for (int i = 0; i < questions.length; i++) {
      arr.add(CustomStep(
          title: Text(questions[i].number.toString().padLeft(2, '0')),
          content: QuestionWidget(question: questions[i]),
          state: _stepState(i, questions[i]),
          isActive: _currentStep == i));
    }

    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("AVALIAÇÃO",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: BlocProvider(
            create: (context) => form_bloc.FormBloc(FormDatabase(widget.code))
              ..add(const form_bloc.LoadQuestions()),
            child: BlocConsumer<form_bloc.FormBloc, form_bloc.FormState>(
                builder: (context, state) {
              if (state is form_bloc.QuestionsLoaded) {
                return CustomStepper(
                    type: CustomStepperType.horizontal,
                    steps: _steps(state.questions),
                    currentStep: _currentStep,
                    onStepTapped: (step) => setState(() => _currentStep = step),
                    onStepContinue: () {
                      setState(() {
                        if (_currentStep < _steps(state.questions).length - 1) {
                          _currentStep += 1;
                        }
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (_currentStep > 0) {
                          _currentStep -= 1;
                        }
                      });
                    },
                    controlsBuilder:
                        (BuildContext context, CustomControlsDetails controls) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                                width: 120,
                                child: (_currentStep != 0)
                                    ? ElevatedButton(
                                        onPressed: controls.onStepCancel,
                                        style: ElevatedButton.styleFrom(
                                            primary: kLightGrey),
                                        child: const Text(
                                          'Voltar',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(
                                height: 40,
                                width: 120,
                                child: (_currentStep ==
                                        _steps(state.questions).length - 1)
                                    ? ElevatedButton(
                                        onPressed: () {
                                          BlocProvider.of<form_bloc.FormBloc>(
                                                  context)
                                              .add(form_bloc.VerifyAnswers());
                                        },
                                        child: const Text(
                                          'Finalizar',
                                          style: TextStyle(fontSize: 18),
                                        ))
                                    : ElevatedButton(
                                        onPressed: controls.onStepContinue,
                                        child: const Text(
                                          'Próximo',
                                          style: TextStyle(fontSize: 18),
                                        )),
                              ),
                            ]),
                      );
                    });
              }
              return Container();
            }, listener: (context, state) {
              if (state is form_bloc.FormCompleted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnswersScreen(
                              code: widget.code,
                            )));
              }

              if (state is form_bloc.FormIncompleted) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "ERRO",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: kBlue),
                        ),
                        content: Text(
                          state.message,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kBlue,
                                      fontSize: 18))),
                        ],
                      );
                    });
              }
            })));
  }
}
