import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/Components.dart';
import '../home-page/HomePage.dart';
import '../signup/cubit/SignUpCubit.dart';
import '../signup/cubit/SignUpStates.dart';

class SettingsScreen extends StatelessWidget {
  var language;

  SettingsScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SignUpCubit()
        ..setLanguage(l: language)
        ..readJson('settings'),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var signUpCubit = SignUpCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                leading: IconButton(
                  onPressed: () {
                    navigateAndFinish(context: context, screen: EditProfilePageState(language: language));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: ListView(
                      children: [
                        Text(
                          "${signUpCubit.items['settings']??''}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "${signUpCubit.items['account']??''}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(
                          height: 15,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                            child: Text("العربية")),
                                        SizedBox(height: 10,),
                                        TextButton(
                                            onPressed: () {
                                              language = "English";
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (BuildContext context) => SettingsScreen(language: language)));
                                            },
                                            child: Text("English")),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600]
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {},
                        child: Text(
                            "${signUpCubit.items['signout']??''}",
                            style: TextStyle(
                                fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
                      ),
                  )
                      ]
                  )
              ),
            );
          }
      ),
    );
  }
}

// class EditProfilePage extends StatefulWidget {
//   var language = "";
//   EditProfilePage({super.key ,required this.language});
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState(language: language,);
// }


class EditProfilePageState extends StatelessWidget{
  bool hidePassword = true;

  var language = "";
  EditProfilePageState({required this.language});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit()..setLanguage(l: language)..readJson('SignUp'),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
      listener: (context, state) {},
      builder: (context, state) {
      var signUpCubit = SignUpCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              navigateAndFinish(context: context, screen: HomePageScreen(language: language));
            },
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
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Text(
                  "${signUpCubit.items['profile']??''}",
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
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
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                // image: NetworkImage(
                                //   "link returned from server",
                                // )
                                image: AssetImage('assets/images/owner.png'),
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
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                //upload photo
                              },

                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget> [
                    Flexible(
                      child:TextField(
                          decoration: InputDecoration(
                            labelText: signUpCubit.items['Fname']??"",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // hintText: "first name returned from server"
                            hintText: "user",
                            hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            )
                        ),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    Flexible(
                      child:TextField(
                        decoration: InputDecoration(
                          labelText: signUpCubit.items['Lname']??"",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          // hintText: "last name returned from server"
                          hintText: "name",
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: signUpCubit.items['email']??"",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // hintText: "email returned from server"
                      hintText: "joe@example.com",
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: signUpCubit.items['phone']??"",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // hintText: "phone returned from server"
                      hintText: "+201234567891",
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: signUpCubit.items['city']??"",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // hintText: "email returned from server"
                      hintText: "alexandria",
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                        onPressed: (){
                          navigateAndFinish(context: context, screen: HomePageScreen(language: language));
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
                      onPressed: () {  },
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
                )
              ],
            ),
          ),
        ),
      );
      }
      ),
    );
  }
}