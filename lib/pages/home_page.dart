import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import '../repository/gif_repository.dart';
import 'gif_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 final gifRepository = GifRepository();

  @override
  void initState() {
    super.initState();

    gifRepository.getGifs().then((map) {
      print(map);
    });
  }
  
  Future<void> compartilharGiff(String link) async {
    await FlutterShare.share(
      title: 'Compartilhar Gif',
      linkUrl: link,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        //Pegando a imagen do site de giff para colocar no appBar do aplicativo
        title: Image.asset("assets/images/site_gifs.gif"),
        centerTitle: true,
      ), //AppBar
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,

              //Para pesquisarmos as imagens
              onSubmitted: (text) {
                setState(() {
                  gifRepository.search = text;

                  //caso seja pesquisado outro titulo de gif's
                  //temos que resetar o offset para recarregar novamente.
                  gifRepository.offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: gifRepository.getGifs(),
              builder: (context, snapshop) {
                switch (snapshop.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,

                      //Para que o CircularProgressIndicator funcione na tela
                      //é preciso adicionar o onSubmited no TextField
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshop.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshop);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    //Como foi definido o limit=19 pois na url estava 20
    //para que sobre um espaço no final diminuimos 1
    //na url caso nao esteja pesquisando
    //retorna data.length senao retorna data.length+1.
    if (gifRepository.search == null) {
      return data.length;
    } else {

      //Para o botão Carregar mais...
      //Aparecer após as 19 imagens
      //a variavel data.length não pode retornar
      //data.length++ tem que ser data.length+1;
      return data.length+1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      //contando a Lista de gifs usando o_getCount
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (gifRepository.search == null || index < snapshot.data["data"].length)
        {
          //Para aceitar clique na tela usaremos o GestureDetector.
          return GestureDetector(
            //Para as imagens aparecer mais suaves
            //Usaremos o FadeInImage.memoryNetwork
            child: FadeInImage.memoryNetwork(

              //Colocando uma imagen transparente
              placeholder: kTransparentImage,

              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              //Altura para aimagen
              height: 300.0,
              fit: BoxFit.cover,
            ), //FadeInImage.memoryNetwork

             onTap: () {

            //Abrindo outra tela ao clicar no gif
             Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GifPage(gifData: snapshot.data["data"][index]))
                        ); //Navigator.push
            },

            //Compartilhando o giff.
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        } else {
          return GestureDetector(
            onTap: () {
              setState(() {
                //Para carregar mais 19 imagens
                //como editamos a url que trazia 20 gifs para trazer
                //19 com isso alocamos um espaço para o botão carregar mais.
                gifRepository.offset += 19;
              });
            },
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70,
                ),

                Text(
                  'Carregar mais...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ), //TextStyle
                ) //Text
              ],
            ),  //Column
          ); //GestureDetector
        }
      },
    ); //GridView.builder
  }
}