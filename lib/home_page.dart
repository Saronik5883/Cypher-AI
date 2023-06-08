import 'package:allen/feature_box.dart';
import 'package:allen/openai_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = "";
  final OpenAIService openAIService = OpenAIService();
  final flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;

  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {

    });
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);

  }

  @override
  void dispose(){
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController = TextEditingController();
    final FocusNode _textFocusNode = FocusNode();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Cyber", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("-AI", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
          ],
        )),
        //leading: const Icon(Icons.menu),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Virtual Assistant picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 110,
                      width: 110,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/virtualAssistant.png"),
                        //fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            //chat bubble
            FadeInLeft(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.circular(0),
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                        generatedContent == null? "Good Morning, what task can I do for you" : generatedContent!,
                                style: TextStyle(
                                  fontFamily: "Cera Pro",
                                  fontSize: generatedContent == null? 25 : 18,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                )
                            ),
                  ),
                ),

            ),

            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  alignment: Alignment.centerLeft,
                  child: const Text("Here are a few things that I can do",
                    style: TextStyle(
                      fontFamily: "Cera Pro",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            //features list
            if(generatedImageUrl != null)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: FeatureBox(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      headerText: "ChatGPT",
                      descriptionText: "A smater way to stay organized and informed with ChatGPT",
                      headerColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: FeatureBox(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      headerText: "Dall-E 2",
                      descriptionText: "Get inspired and stay creative with your personal assistant powered by Dall-E",
                      headerColor: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay * 2),
                    child: FeatureBox(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      headerText: "Smart Voice Assistant ",
                      descriptionText: "Get the best out of both worlds with a voice assitant",
                      headerColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),

                ],
              ),
            ),
            Visibility(
                visible: generatedContent != null && generatedImageUrl != null,
                child: SizedBox(height: 50,)),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //a border for the textfield
                      focusNode: _textFocusNode,
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: "Type a message",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final speech = await openAIService.isArtPromptAPI(_textEditingController.text);
                      _textEditingController.clear();
                      if(speech.contains('https')){
                        generatedImageUrl = speech;
                        generatedContent = null;
                      }else{
                        generatedImageUrl = null;
                        generatedContent = speech;
                        await systemSpeak(speech);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if(await speechToText.hasPermission && speechToText.isNotListening){
                        await startListening();
                      }else if(speechToText.isListening){
                        final speech = await openAIService.isArtPromptAPI(lastWords);
                        if(speech.contains('https')){
                          generatedImageUrl = speech;
                          generatedContent = null;
                        }else{
                          generatedImageUrl = null;
                          generatedContent = speech;
                          await systemSpeak(speech);
                          setState(() {});
                        }
                        await stopListening();
                      }else{
                        initSpeechToText();
                      }
                    },
                    child: Icon(speechToText.isListening? Icons.stop : Icons.mic),
                  )
                ],
              ),
            ),

          ]

        ),
      ),
      //bottom app bar which has a text field and a send button and a floating action button
    );
  }
}
