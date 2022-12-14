import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../model/form.dart';
import '../model/response.dart';
import '../model/assessment.dart';

class Service {
  static final Service _instance = Service._internal();
  late String defaultPath;

  factory Service() {
    return _instance;
  }

  Service._internal() {
    defaultPath = "https://avaliacao-alunos-ft.herokuapp.com";
  }

  var client = http.Client();

  Future<Response> verifyCode(String code) async {
    bool successfull = false;
    try {
      final classResponse = await client.get(
        Uri.parse("$defaultPath/turmas/${code.trim()}"),
      );

      final subjectResponse = classResponse.statusCode == 200
          ? await client.get(
              Uri.parse(
                  "$defaultPath/disciplinas/${jsonDecode(classResponse.body)["codDisc"]}"),
            )
          : classResponse;

      successfull =
          classResponse.statusCode == 200 && subjectResponse.statusCode == 200;

      if (successfull) {
        Assessment classroom = Assessment.fromJson(
            jsonDecode(classResponse.body), jsonDecode(subjectResponse.body));
        return Response(successfull, classroom);
      } else {
        log("Turmas: [${classResponse.statusCode}] - ${classResponse.reasonPhrase}");
        log("Disciplinas: [${subjectResponse.statusCode}] - ${subjectResponse.reasonPhrase}");
        return Response(successfull);
      }
    } catch (e) {
      return Response(successfull);
    }
  }

  Future<Response> registerAssessment(Form form) async {
    try {
      final response = await client.post(
        Uri.parse("$defaultPath/formulario"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'codTurma': form.code,
          'dataIni': form.start.toString(),
          'dataFim': form.end.toString(),
          'questoes': form.questionsToJson()
        }),
      );

      bool successfull = response.statusCode == 200;
      log("Formulario: [${response.statusCode}] - ${response.reasonPhrase}");
      return Response(successfull);
    } catch (e) {
      log("Erro: ${e.toString()}}");
      return Response(false);
    }
  }
}
