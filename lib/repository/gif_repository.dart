import 'dart:convert';
import 'package:http/http.dart' as http;

class GifRepository{
  //variavel nullable para buscar os giffs
  //para trazer os gif's e fazer as comparaçoes
  // a variavel tem que ser do tipo nullable.
  String? search;

  //variavel para saltar a quantidade de gif's
  int offset = 0;

  Future<Map> getGifs() async {
    http.Response response;

    //Para a variável _search ser verificada como null ela precisa ser Nullable
    if (search == null || search!.isEmpty) {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=f7ToaKTLTCKGcdMevenFOg5aN1r0hmqq&limit=20&rating=g"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=f7ToaKTLTCKGcdMevenFOg5aN1r0hmqq&q=$search&limit=19&offset=$offset&rating=g&lang=pt"));
    }

    return jsonDecode(response.body);
  }

}