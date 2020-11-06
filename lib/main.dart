import 'package:easy_web_view_example/easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Web View Example',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final htmlContent = '''
<html>
  <head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
  </head>
  <body>
    <div id="summernote"></div>
    <script>
    window.onload = function () {
      \$('#summernote').summernote({
        minHeight: ${screenSize.height * 0.64},
        maxHeight: ${screenSize.height * 0.64},
        tabsize: 2,
        callbacks: {
          onChange: function() {
            \$('#html-content').text(\$('#summernote').summernote('code'));
            
            window.parent.postMessage(\$('#summernote').summernote('code'), '*');
            if (window.Test != null) {
              window.Test.postMessage(\$('#summernote').summernote('code'));
            }
          }
        },
        toolbar: [
          ['style', ['style']],
          ['font', ['bold', 'underline', 'clear']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture']],
          ['view', ['codeview']]
        ]
      });
    }
    </script>
    <div id="html-content" style="display: none"></div>
  </body>
</html>
''';

    String htmlText = '';
    // GlobalKey<State> _key = GlobalKey();

    /*
      final regularExpression = r'<div id="html-content" style="display: none">(.*?)</div>';
      var htmlContent = '<div id="html-content" style="display: none"><p>Teste</p><p>Teste</p><p><span style="background-color: rgb(255, 255, 0);">Teste</span></p><p><img style="width: 42px;" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACoAAAAwCAYAAABnjuimAAAABHNCSVQICAgIfAhkiAAAABl0RVh0U29mdHdhcmUAZ25vbWUtc2NyZWVuc2hvdO8Dvz4AAABPSURBVFiF7c7BCQAhEACx8/rveW3Bx4AISQVZMzPfA/7bgVOiNdGaaE20JloTrYnWRGuiNdGaaE20JloTrYnWRGuiNdGaaE20JloTrYnWNk+2BFydzgMKAAAAAElFTkSuQmCC" data-filename="Square.png"><span style="background-color: rgb(255, 255, 0);"><br></span></p><p><span style="background-color: rgb(255, 255, 0);"><br></span><br></p></div>'.trim();

      print(RegExp(regularExpression).allMatches(htmlContent).first.group(1));
    */

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            final focusScope = FocusScope.of(context);
            if (!focusScope.hasPrimaryFocus) {
              focusScope.unfocus();
            }
          },
          child: LayoutBuilder(
            builder: (_, viewportConstraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    child: Column(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: Text('HTML Content'),
                                  content: Text(htmlText),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(dialogContext)
                                            .pop(); // Dismiss alert dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('SHOW HTML CONTENT'),
                        ),
                        Center(
                          child: SizedBox(
                            height: screenSize.height * 0.84,
                            width: double.infinity,
                            child: EasyWebView(
                              src: htmlContent,
                              isHtml: true,
                              onLoaded: () {},
                              crossWindowEvents: [
                                CrossWindowEvent(
                                    name: 'Test',
                                    eventAction: (eventMessage) {
                                      print(eventMessage);
                                      htmlText = eventMessage;
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
