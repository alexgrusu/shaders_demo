import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shaders_demo/shader_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ShaderHandler shaderHandler;
  late Size size;

  void animate() async {
    Future.delayed(const Duration(milliseconds: 50), () async {
      if (shaderHandler.textures.isNotEmpty) {
        shaderHandler.textures.first.activate();
        shaderHandler.update();
      }
      animate();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      shaderHandler = ShaderHandler(
        size.width.toInt(),
        size.height.toInt(),
        MediaQuery.of(context).devicePixelRatio,
        (){setState(() {});}
      );
      shaderHandler.setup(context);
      animate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: Colors.black,
              child: Builder(builder: (BuildContext context) {
                if (kIsWeb) {
                  return !shaderHandler.textures.isNotEmpty?Container():HtmlElementView(viewType: shaderHandler.textures.first.textureId.toString());
                } else {
                  return shaderHandler.textures.isNotEmpty?Texture(textureId: shaderHandler.textures.first.textureId):Container();
                }
              })
            )
          ],
        ),
      ),
    );
  }
}
