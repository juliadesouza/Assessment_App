import 'package:assessment_app/constants/colors.dart';
import 'package:assessment_app/logic/home/home_bloc.dart';
import 'package:assessment_app/model/assessment.dart';
import 'package:assessment_app/screens/info_screen.dart';
import 'package:assessment_app/screens/qrcode_screen.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Slide> slides = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 0
        ? MediaQuery.of(context).size.width
        : 412;
    double height = MediaQuery.of(context).size.height > 0
        ? MediaQuery.of(context).size.height
        : 869;
    return Scaffold(
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
          if (state is AuthenticatedCode) {
            Assessment classroom = state.assessment!;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InfoScreen(classroom: classroom)));
          }

          if (state is CodeError) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "ERRO",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: kBlue),
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

          if (state is Timeout) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Ops!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: kBlue),
                    ),
                    content: Text(
                      "Aguarde ${state.waitingTimeLeft} minutos antes de iniciar outra avalia????o.",
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

          if (state is Avaliable) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => QRCodeScreen(
                      blocContext: context,
                    )));
          }
        }, builder: (context, state) {
          if (state is UnauthenticatedCode) {
            return IntroSlider(
              slides: [
                Slide(
                    widgetTitle: const Text(
                      "AVALIA????O INSTUCIONAL DE DISCIPLINAS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    centerWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 0.35 * width,
                          height: 0.35 * height,
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 50, left: 50),
                          child: const Text(
                            "Avalie as disciplinas da FT em poucos minutos.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.05 * height, horizontal: 0.1 * width),
                          child: SizedBox(
                              height: 0.07 * height,
                              width: 0.1 * width,
                              child: ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<HomeBloc>(context)
                                      .add(VerifyTimeout());
                                },
                                child: const Text("LER QR CODE",
                                    style: TextStyle(
                                        color: kBackground,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal)),
                              )),
                        ),
                      ],
                    )),
                Slide(
                  widgetTitle: const Text(
                    "AVALIA????O",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  pathImage: 'assets/images/graph.png',
                  widthImage: 0.2 * width,
                  heightImage: 0.2 * height,
                  widgetDescription: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Avalie as disciplinas oferecidas na Faculdade de Tecnologia para que possamos aperfei??oar as condi????es e metodologias de ensino e aprendizagem.",
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                Slide(
                  widgetTitle: const Text(
                    "QUESTION??RIO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  pathImage: 'assets/images/likert.png',
                  widthImage: 0.2 * width,
                  heightImage: 0.2 * height,
                  widgetDescription: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                        textAlign: TextAlign.center,
                        "As primeiras quest??es s??o formadas por afirma????es e voc?? deve indicar o grau de concord??ncia com elas, ou se a afirma????o n??o se aplica para esta disciplina.",
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                Slide(
                  widgetTitle: const Text(
                    "QUESTION??RIO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  pathImage: 'assets/images/idea.png',
                  widthImage: 0.2 * width,
                  heightImage: 0.2 * height,
                  widgetDescription: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Ao final, voc?? ter?? um espa??o para indicar os aspectos positivos da disciplina e sugest??es para melhor??-la.",
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
                Slide(
                  widgetTitle: const Text(
                    "IMPORTANTE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  pathImage: "assets/images/important.png",
                  widthImage: 0.2 * width,
                  heightImage: 0.2 * height,
                  widgetDescription: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/question.png',
                            ),
                            title: const Text(
                              'Existem 26 quest??es neste question??rio.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/person.png',
                              ),
                              title: const Text(
                                'O question??rio ?? an??nimo.',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/id.png',
                            ),
                            title: const Text(
                              'O registro de suas respostas n??o cont??m nenhuma informa????o de identifica????o sobre voc??.',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              showNextBtn: false,
              showPrevBtn: false,
              showSkipBtn: false,
              showDoneBtn: false,
              backgroundColorAllSlides: kBackground,
              colorDot: kGrey,
              colorActiveDot: kBlue,
            );
          }

          if (state is Authenticating) {
            return Padding(
                padding: const EdgeInsets.all(70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(
                        color: kBlue,
                      ),
                    ),
                    Text("Autenticando o c??digo...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kBlue)),
                  ],
                ));
          }

          return SingleChildScrollView(child: Container());
        }),
      ),
    );
  }
}
