import 'package:flutter/material.dart';
import 'package:urlxpose/Api/Network.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  String expandedUrl = "";
  Map<String, dynamic> threatInfo = {};

  void urlCheck(String url) async {
    setState(() {
      isLoading = true; // Start loading
      expandedUrl = "";
      threatInfo = {};
    });

    Network ob = Network();

    // Fetch Expanded URL
    String res = await ob.getExpandedUrl(shortUrl: url);
    print(res);

    // Fetch Threat Information
    Map<String, dynamic> result =
        await ob.checkUrlSafety(res != "Wrong URL" ? res : url);

    setState(() {
      isLoading = false; // Stop loading
      expandedUrl = res;
      threatInfo = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "URLXpose",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 35),
          Text('Enter the suspicious URL', style: TextStyle(fontSize: 17)),
          SizedBox(height: 15),
          Center(
            child: Container(
              width: width / 1.11,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: "Enter here.."),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    controller.clear();
                    expandedUrl = "";
                    threatInfo = {};
                  });
                },
                child: Container(
                  height: height / 14,
                  width: width / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent),
                  child: Center(
                    child: Text(
                      "Clear",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              InkWell(
                onTap: () {
                  if (controller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Empty URL'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    urlCheck(controller.text);
                  }
                },
                child: Container(
                  height: height / 14,
                  width: width / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Show CircularProgressIndicator while loading
          isLoading
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    // Expanded URL Display
                    if (expandedUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          expandedUrl == "Wrong URL"
                              ? "The Input URL is wrong"
                              : "The Expanded URL is \n$expandedUrl",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    SizedBox(
                      height: 25,
                    ),

                    // Threat Information
                    if (threatInfo.containsKey("matches"))
                      Column(
                        children: threatInfo["matches"].map<Widget>((match) {
                          return Column(
                            children: [
                              Text(
                                "Threat Type: ${match["threatType"]}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              Text(
                                "Platform Type: ${match["platformType"]}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              SizedBox(height: 5),
                            ],
                          );
                        }).toList(),
                      )
                    else if (expandedUrl.isNotEmpty &&
                        expandedUrl != "Wrong URL")
                      Text(
                        "The URL is not marked as malicious",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
