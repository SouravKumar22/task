import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class Details extends StatefulWidget {
  var img;
  Details(this.img);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  var pickedFile;
  var image_asset;
  var responseResult;
  @override
  void initState() {
    image_asset = widget.img;
    print("Image Asset: $image_asset");
    user_profile();
    // TODO: implement initState
    super.initState();
  }

  user_profile() async {
    // setState(() {
      pickedFile = await _saveNetworkImageToFile(image_asset);
    // });
    print("Picked File: ${pickedFile}");
  }

  Future<dynamic> _saveNetworkImageToFile(String imageUrl) async {
    print("hello");

    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/image.png');
    await file.writeAsBytes(response.bodyBytes);
    print(file.path);
    return file;
  }

  Future<void> Upload_Details(String pickedFilePath)  async {
    try {
      String fname = _fname.text.trim();
      String lname = _lname.text.trim();
      String mail = _email.text.toString().trim();
      String phone = _phone.text.toString().trim();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("http://dev3.xicom.us/xttest/savedata.php"),
      );
      var user_image = await http.MultipartFile.fromPath(
          'user_image', pickedFilePath);
      request.files.add(user_image);
      request.fields['first_name'] = fname;
      request.fields['last_name'] = lname;
      request.fields['email'] = mail;
      request.fields['phone'] = phone;
      try{
        final response = await request.send();
        final responseData = await http.Response.fromStream(response);
        if(responseData.statusCode==200){
          final Map<String, dynamic> responseDataResult = json.decode(responseData.body);
          print("Response: ${responseDataResult}");
          responseResult = responseDataResult["message"];
          var snackBar = SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.black,
            content: Text('${responseResult.toString()}....',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white
              ),),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }catch(e){
        print(e);
      }
    }
    catch (error) {
      // Handle other errors appropriately
      throw Exception('Failed to upload details: $error}');
    }
  }


  final _formKey = GlobalKey<FormState>();
  var imgNUll=false;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Details Screen",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontStyle: FontStyle.normal
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            Container(
              alignment: Alignment.center,
                child: Image.network("$image_asset",
                  errorBuilder: (context,object,e){
                    print("errrrr:");
                    print(object);
                    print(e);
                    // setState(() {
                      imgNUll=true;
                    // });
                    return Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(30.0),
                      color: Colors.grey,
                      // width: 100,
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
                  },)),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Column 1 for headings
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 55,
                      child: Text("First Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 55,
                      child: Text("Last Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 55,
                      child: Text("Email",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 55,
                      child: Text("Phone",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ],
                ),
                //Column 2 for values
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 55,
                        width: w/2,
                        child: TextFormField(
                          controller: _fname,
                          validator: (value){
                            print("$value");
                            // final RegExp _nameRegex = RegExp('[a-zA-Z]'); // Regex for name validation
                            return value!.isNotEmpty?RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value!)?"Only alphabets allowed":null:"Enter Name";
                          },
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontStyle: FontStyle.normal
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey,
                                  width: 2
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  width: 2
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 55,
                        width: w/2,
                        child: TextFormField(
                          controller: _lname,
                          validator: (value){
                          print("$value");
                          // final RegExp _nameRegex = RegExp('[a-zA-Z]'); // Regex for name validation
                          return value!.isNotEmpty?RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value!)?"Only alphabets allowed":null:"Enter Last Name";
                        },
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontStyle: FontStyle.normal
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey,
                                  width: 2
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  width: 2
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 55,
                        width: w/2,
                        child: TextFormField(
                          controller: _email,
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                            null : "Invalid Email";
                          },
                          onChanged: (val){
                            setState(() {
                              _email.text=val;
                            });
                          },
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontStyle: FontStyle.normal
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey,
                                  width: 2
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  width: 2
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 55,
                        width: w/2,
                        child: TextFormField(
                          validator: (value){
                          print("$value");
                          if(value!.length!=10){
                            return "Phone Number should be of 10 digits.";
                          }
                          // final RegExp _nameRegex = RegExp('[a-zA-Z]'); // Regex for name validation
                          return value!.isNotEmpty?RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value!)?null:"Only Numbers allowed":"Enter Phone Number";
                        },
                          controller: _phone,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontStyle: FontStyle.normal
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey,
                                  width: 2
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  width: 2
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.centerRight,
              child: Container(
                width: w/3,
                height: 60,
                margin: EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate() && imgNUll==false){
                        Upload_Details(pickedFile.path);
                      }else{
                        const snackBar = SnackBar(
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.black,
                          content: Text('Invalid Details :(',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            ),),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    style:ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.black
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0), // Set the border radius
                      ),
                    ),
                    child:  Text('Submit',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
              ),
            ),

            SizedBox(height: 50,)
          ],
        ),
      ),

    );
  }
}
