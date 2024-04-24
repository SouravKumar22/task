import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int offset = 0;
  List<String> imageUrls = [];
  bool set = true;

  @override
  void initState() {
    fetchData(offset);
    super.initState();
  }


  Future<void> fetchData(int offset) async {
    try {
      final url = Uri.parse('http://dev3.xicom.us/xttest/getdata.php');
      final response = await http.post(
        url,
        body: {'user_id': '108', 'offset': offset.toString(), 'type': 'popular'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> images = data['images'];
      
        setState(() {
          if(images.length==0){
            set = false;
            showBar(context);
          }
          imageUrls.addAll(images.map((image) => image['xt_image'].toString()));
      
      
        });
      
      } else {
        throw Exception('Failed to load images');
      }
    } on Exception catch (e) {
      // TODO
    }
  }
  showBar(context){
    const snackBar = SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.black,
      content: Text('This is the last Image. No more Images to load.',
        style: TextStyle(
            fontSize: 14,
            color: Colors.white
        ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loadMoreImages(context) {
    try {
      if(offset==0){
        offset = 1;
      }
        fetchData(offset++);
    } on Exception catch (e) {
      
    }
    // Adjust the offset as needed for pagination
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text('Images'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap:true,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            final imageUrl = imageUrls[index];
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=> Details(imageUrl)));
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.network(imageUrl,
                        errorBuilder: (context,object,e){
                      print("errrrr:");
                      print(object);
                      print(e);
                      return Container(
                        padding: EdgeInsets.all(30.0),
                        color: Colors.grey,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50,),
                            Icon(Icons.error_outline_outlined,
                              size: 100,),
                            SizedBox(height: 20,),
                            Text("$object",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            ),
                            SizedBox(height: 80,),

                          ],
                        ),
                      );
                },
                )
              ),
            );
          },
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            largeSizeConstraints:
              BoxConstraints.tightFor(
                width: MediaQuery.of(context).size.width/2+50,
                height: 50,
              )
          ),
        ),
        child: FloatingActionButton.large(
          backgroundColor: Colors.white,
          elevation: 10,
          onPressed: (){
            if(set==false){
              const snackBar = SnackBar(
                duration: Duration(seconds: 3),
                backgroundColor: Colors.black,
                content: Text('This is the last Image. No more Images to load.',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else{
              loadMoreImages(context);
            }
          },
          tooltip: 'Load More',
          child: Text("  Click here to Load more Images  ",
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.normal
          ),),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
