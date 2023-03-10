import 'package:buscador_de_gifs/pages/home_page.dart';
import 'package:flutter/material.dart';

//https://api.giphy.com/v1/gifs/trending?api_key=f7ToaKTLTCKGcdMevenFOg5aN1r0hmqq&limit=25&rating=g

//https://api.giphy.com/v1/gifs/search?api_key=f7ToaKTLTCKGcdMevenFOg5aN1r0hmqq&q=dogs&limit=25&offset=75&rating=g&lang=pt

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        //Deixando a borda da pesquisa branca
        inputDecorationTheme: const InputDecorationTheme(
          //quando inativa fica braca
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),

          //quando ativa fica branca
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ), //OutlineInputBorder
        ), //InputDecorationTheme
      ), //ThemeData
    ), //MaterialApp
  );
}
