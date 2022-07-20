import 'package:app_scrapping/Offre.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScrapJob',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'ScrapJob'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> titles = [];
  List<String> descriptions = [];
  List<String> logo = [];
  List<String> contrat = [];
  List<String> urlImages = [];
  final controller = TextEditingController();
  late String link;
  int page = 1;
  final _advancedDrawerController = AdvancedDrawerController();
  void incrementCounter() {
    getWebsiteData();
    setState(() {
      page++;
    });
  }

  void decrementCounter() {
    getWebsiteData();
    setState(() {
      if(page > 1) {
        page--;
      }
    });
  }

  void resetCounter() {
    getWebsiteData();
    setState(() {
      page = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    getWebsiteData();
  }

  Future getWebsiteData () async {

    link = 'https://www.portaljob-madagascar.com/emploi/liste/secteur/informatique-web/page/$page';
    var url = Uri.parse(link);
    var response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    debugPrint(link);
    final titles = html
        .querySelectorAll('aside.contenu_annonce > h3 > a > strong')
        .map((e) => e.innerHtml.trim())
        .toList();

    final logo = html
        .querySelectorAll('aside.contenu_annonce > h4')
        .map((e) => e.innerHtml.trim())
        .toList();

    final contrat = html
        .querySelectorAll('aside.contenu_annonce > h5')
        .map((e) => e.innerHtml.trim())
        .toList();

    final descriptions = html
        .querySelectorAll('aside.contenu_annonce > a')
        .map((e) => e.innerHtml.trim())
        .toList();

    final urlImages = html
        .querySelectorAll('aside.date_annonce > div:nth-child(2) > a > img')
        .map((e) => e.innerHtml.trim())
        .toList();

    setState(() {
      this.titles = titles;
      this.descriptions = descriptions;
      this.logo = logo;
      this.contrat = contrat;
      this.urlImages = urlImages;
    });
  }
  void searchOffre(String query) {
    final suggestions = titles.where((title) {
      final offresEmploi = title.toLowerCase();
      final input = query.toLowerCase();

      return offresEmploi.contains(input);
    }).toList();

    setState(() => titles = suggestions);
  }
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.green,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child:
      Scaffold(
        appBar: AppBar(
          title: const Text('Scrap Job',
          textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        actions: [
          ElevatedButton(onPressed: getWebsiteData,
              child: Icon(Icons.refresh)
          ),
        ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Offre d'emploie",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.teal)
                  ),
                ),

                onChanged: searchOffre,
              ),

            ),
            Expanded(
                child: ListView.builder(
                    itemCount: titles.length,
                    itemBuilder: (context, index) {
                      final title = titles[index];
                      final description = descriptions[index];
                      final logos = logo[index];
                      final contrats = contrat[index];
                      return Card(
                        elevation: 8,
                        color: Colors.white70,
                        shadowColor: Colors.grey[900],
                        child:
                          ListTile(
                            title: Text(title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.green[500],
                                  fontFamily: GoogleFonts.roboto().toString(),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(logos,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontFamily: GoogleFonts.roboto().toString(),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Offre(titles: title, logo: logos, contrat: contrats, description: description)),
                            ),
                          ),
                      );
                    }
                )
            ),
            Text('$page'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: decrementCounter,
                    child:  Icon(Icons.arrow_back_outlined)),
                ElevatedButton(onPressed: resetCounter,
                    child:  Icon(Icons.home)),
                ElevatedButton(onPressed: incrementCounter,
                    child:  Icon(Icons.arrow_forward)),
              ],
            ),
          ],
        ),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                  fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.bookmark),
                  title: Text('Save'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}








