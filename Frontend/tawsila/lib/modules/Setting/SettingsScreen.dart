import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tawsila/modules/log-in/SignInScreen.dart';
import 'package:tawsila/shared/end-points.dart';
import 'package:toast/toast.dart';
import '../../shared/components/Components.dart';
import '../home-page/HomePage.dart';
import '../signup/cubit/SignUpCubit.dart';
import '../signup/cubit/SignUpStates.dart';
import 'dart:io';

class SettingsScreen extends StatelessWidget {
  var language = "";

  SettingsScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SignUpCubit()
        ..setLanguage(l: language)
        ..readJson('settings')..getUserInfo(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var signUpCubit = SignUpCubit.get(context);
            return Directionality(
              textDirection: signUpCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  leading: IconButton(
                    onPressed: () {
                      navigateAndFinish(context: context, screen: EditProfilePage(language: language,edit: false,));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: Container(
                    padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                    child: ListView(
                        children: [
                          Text(
                            "${signUpCubit.items['settings']??''}",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${signUpCubit.items['account']??''}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: (){
                              navigateTo(context: context, screen: EditProfilePage(language: language, edit: true));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${signUpCubit.items['edit profile']??''}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15,),
                          GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("${signUpCubit.items['language']??''}"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                language = "العربية";
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) => SettingsScreen(language: language)));
                                              },
                                              child: const Text("العربية")),
                                          const SizedBox(height: 10,),
                                          TextButton(
                                              onPressed: () {
                                                language = "English";
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) => SettingsScreen(language: language)));
                                              },
                                              child: const Text("English")),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("${signUpCubit.items['close']??''}")),
                                      ],
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${signUpCubit.items['language']??''}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                navigateAndFinish(context: context, screen: SignInScreen(language: language));
                              },
                              child: Text(
                                  "${signUpCubit.items['signout']??''}",
                                  style: const TextStyle(
                                      fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
                            ),
                          )
                        ]
                    )
                ),
              ),
            );
          }
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  var language = "";
  bool edit;
  EditProfilePage({super.key ,required this.language,required this.edit});
  @override
  EditProfilePageState createState() => EditProfilePageState(language: language,edit: this.edit,);
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class EditProfilePageState extends State<EditProfilePage>{
  bool edit = true;
  var fName = "";
  var lName = "";
  var email = "";
  var phone = "";
  var city = "";
  var language = "";
  String img64="";
  // "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";
  // "data:image/jpeg;base64,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";
  PickedFile _imageFile = PickedFile("");
  final ImagePicker _picker = ImagePicker();
  var textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black
  );
  EditProfilePageState({required this.language, required this.edit });
  @override
  Widget build(BuildContext context)  {
    return BlocProvider(
      create: (context) => SignUpCubit()..setLanguage(l: language)
        ..readJson('SignUp')..intiateUserInfo()..getUserInfo(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var signUpCubit = SignUpCubit.get(context);
            return Directionality(
              textDirection: signUpCubit.language == "English" ? TextDirection.ltr: TextDirection.rtl,
              child: Scaffold(
                appBar: bar(context,),
                body: Container(
                  padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: [
                        header(context, signUpCubit),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 10))
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _imageFile.path==""? avatar(signUpCubit) : FileImage(File(_imageFile.path)),//NetworkImage('${signUpCubit.usersInfo['avatar']}'),
                                    )
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      color: Colors.blue,
                                    ),
                                    child: profile(signUpCubit),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Flexible(
                              child:TextField(
                                enableInteractiveSelection: edit, // will disable paste operation
                                focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                                style: textStyle,
                                onChanged: (value){
                                  fName = value;
                                },
                                decoration: InputDecoration(
                                  labelText: signUpCubit.items['Fname']??"",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  // hintText: "first name returned from server"
                                  hintText: "${signUpCubit.usersInfo['firstName']}",

                                  hintStyle: textStyle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15,),
                            Flexible(
                              child:TextField(
                                enableInteractiveSelection: edit, // will disable paste operation
                                focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                                onChanged: (value){
                                  lName = value;
                                },
                                style: textStyle,
                                decoration: InputDecoration(
                                  labelText: signUpCubit.items['Lname']??"",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  // hintText: "last name returned from server"
                                  hintText: "${signUpCubit.usersInfo['lastName']}",
                                  hintStyle: textStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          enableInteractiveSelection: edit, // will disable paste operation
                          focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                          style: textStyle,
                          onChanged: (value){
                            email = value;
                          },
                          decoration: InputDecoration(
                              labelText: signUpCubit.items['email']??"",
                              prefixIcon: const Icon(Icons.email),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              // hintText: "email returned from server"
                              hintText: "${signUpCubit.tokenInfo[USEREMAIL]}",
                              hintStyle: textStyle
                          ),
                        ),
                        TextField(
                          enableInteractiveSelection: edit, // will disable paste operation
                          focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                          keyboardType: TextInputType.phone,
                          onChanged: (value){
                            phone = value;
                          },
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: signUpCubit.items['phone']??"",
                              prefixIcon: const Icon(Icons.phone),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              // hintText: "phone returned from server"
                              hintText: "${signUpCubit.usersInfo['phoneNumber']}",
                              hintStyle: textStyle
                          ),
                        ),
                        TextField(
                          enableInteractiveSelection: edit, // will disable paste operation
                          focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                          onChanged: (value){
                            city = value;
                          },
                          style: textStyle,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.location_city),
                            labelText: signUpCubit.items['city']??"",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // hintText: "email returned from server"
                            hintText: "alexandria",
                            hintStyle: textStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        buttons(context, signUpCubit),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
  Text header(BuildContext context,var signUpCubit){
    if(edit) {
      return Text(
        "${signUpCubit.items['edit profile']??''}",
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      );
    }
    return Text(
      "${signUpCubit.items['profile']??''}",
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    );
  }


  AppBar bar(BuildContext context){
    if(edit){
      return AppBar(
        elevation: 1,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              navigateTo(
                  context: context, screen: SettingsScreen(language: language));
            }
        ),
      );
    }
    return AppBar(
      elevation: 1,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            navigateAndFinish(
                context: context, screen: HomePageScreen(language: language));
          }
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SettingsScreen(language: language)));
          },
        ),
      ],
    );
  }
  Row buttons(BuildContext context,var signUpCubit){
    ToastContext toast = ToastContext();
    if(edit) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: (){
              navigateAndFinish(context: context, screen: SettingsScreen(language: language));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
                "${signUpCubit.items['cancel']??""}",
                style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 2.2,
                    color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              bool error = false;
              if(email != "" ){
                if((!EmailValidator.validate(email, true))) {
                  error = true;
                  toast.init(context);
                  Toast.show("${signUpCubit.items['emailError']??""}",
                      duration: Toast.lengthShort, backgroundColor: Colors.red
                  );
                }
              }
              if(!error && (phone != "")){
                if(phone.length != 13) {
                  error = true;
                  toast.init(context);
                  Toast.show("${signUpCubit.items['phoneError']??""}",
                      duration: Toast.lengthShort, backgroundColor: Colors.red
                  );
                }
              }
              if(!error&& (email!="" || phone!="" || fName != "" || lName != "" || city != "" ||  img64!="")){
                Map<String, dynamic> query = {
                  "email": email==""? "${signUpCubit.tokenInfo[USEREMAIL]}" : email,
                  "firstName": fName==""? "${signUpCubit.usersInfo['firstName']}":fName,
                  "lastName": lName ==""? "${signUpCubit.usersInfo['lastName']}":lName,
                  "phoneNumber": phone==""?"${signUpCubit.usersInfo['phoneNumber']}":phone,
                  "avatar": img64==""?null:img64,
                  "hasWhatsapp": true
                };
                signUpCubit.updeteUserInfo(query: query, context: context);
              }
              else if(!error){
                navigateAndFinish(context: context, screen: SettingsScreen(language: language));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 50),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              "${signUpCubit.items['save']??""}",
              style: const TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.2,
                  color: Colors.white),
            ),

          )
        ],
      );
    } else {
      return Row();
    }
  }
  Widget bottomSheet(BuildContext context,var signUpCubit) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "${signUpCubit.items['choosePicture']??""}",
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton(onPressed: () {takePhoto(ImageSource.camera);}, child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.camera),
                Text("${signUpCubit.items['camera']??""}"),
              ],
            )),
            const SizedBox(width: 50,),
            TextButton(onPressed: () {takePhoto(ImageSource.gallery);}, child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.image),
                Text("${signUpCubit.items['gallery']??""}"),
              ],
            )),
          ])
        ],
      ),
    );
  }
  ImageProvider avatar(var signUpCubit){
    if(signUpCubit.usersInfo['avatar'] != ""){
      return NetworkImage('${signUpCubit.usersInfo['avatar']}');
    }
    else{
      return AssetImage('assets/images/owner.png');
    }
  }
  Widget? profile(var signUpCubit){
    if(edit){
      return  IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          //upload photo
          showModalBottomSheet(
            context: context,
            builder: (builder) => bottomSheet(context,signUpCubit),
          );
        },

      );
    }
    else {
      return null;
    }
  }
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
    final bytes = File(_imageFile.path).readAsBytesSync();
    img64 = base64Encode(bytes);
    //print("2222222222222222222222222222222222222222222222222222222222222222222222");
    print(img64);
    //print("22222222222222222222222222222222222222222222222222222222222222222222222");
  }
}
