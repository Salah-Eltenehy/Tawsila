import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../shared/end-points.dart';
import 'cubit/SeachCubit.dart';
import 'cubit/SearchStates.dart';

class TestMe extends StatefulWidget {
  var language = "";
  var id = "";
  TestMe({super.key ,required this.language,required this.id});
  @override
  _TestMeState createState() => _TestMeState(language: language, id: id);
}

class _TestMeState extends State<TestMe> {
  var language = "";
  var id = "";
  _TestMeState({required this.language,required this.id});
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [];
  double rate = 3.0;
  Widget commentChild(data,viewCarCubit) {
    return ListView(
      children: <Widget>[
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                        radius: 50,
                        backgroundImage: CommentBox.commentImageParser(
                            imageURLorPath: data[i]['reviewerAvatar'])),
                  ),
              ),
              title: Text(
                "${data[i]['reviewerFirstName']} ${data[i]['reviewerLastName']}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['content']),
              trailing: Column(
                children: [
                  SizedBox(height: 10,),
                  Text(data[i]['updatedAt'], style: TextStyle(fontSize: 10)),
                  RatingBar.builder(
                    itemCount: 5,
                    allowHalfRating: true,
                    initialRating:  double.parse(data[i]['rating']),
                    ignoreGestures: true,
                    itemSize: 20,
                    itemBuilder: (context, index) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                  },
                  onRatingUpdate: (rating) {},
                ),
                ]
              )
            ),
          ),
        button(viewCarCubit.offset, viewCarCubit.totlCount),
        SizedBox(height: 70,)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:  (BuildContext context) => SearchCubit()..getUserById(id)
        ..getUserReviewsById(id),
      child: BlocConsumer<SearchCubit, SearchStates>(
        builder: (context, state) {
          var viewCarCubit = SearchCubit.get(context);
          filedata = viewCarCubit.reviews;
          return Scaffold(
            appBar: AppBar(
              title: Text("Comment Page"),
              backgroundColor: Colors.blue,
            ),
            body: Container(
              child: CommentBox(
                userImage: CommentBox.commentImageParser(
                    imageURLorPath: "assets/img/userpic.jpg"),
                labelText: 'Write a comment...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                sendButtonMethod: () {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);
                    setState(() {
                      var value = {
                        'reviewerFirstName': viewCarCubit.tokenInfo[USERFNAME],
                        "reviewerLastName":  viewCarCubit.tokenInfo[USERFNAME],
                        'reviewerAvatar':
                        'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                        'content': commentController.text,
                        "createdAt": DateFormat('dd-MM-yyyyTkk:mm').format(DateTime.now()),
                        "updatedAt": DateFormat('dd-MM-yyyyTkk:mm').format(DateTime.now()),
                        "rating" : rate.toString()
                      };
                      filedata.insert(0, Map<String, String>.from(value));
                    });
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    print("Not validated");
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
                child: Container(
                  child: Stack(
                    children: [
                      commentChild(filedata,viewCarCubit),
                      Positioned(
                          bottom: 0,
                          child: Container(
                            color: Colors.blue,
                            child: RatingBar.builder(
                              initialRating: rate,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.only(right: 45,left: 5),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {
                                rate = value;
                                print(rate);
                              },
                            )
                          )
                      )
                    ]
                  )
                ),
              ),
            ),
          );
        },
        listener: (context, state) {  },
      ),
    );
  }

  Widget button(var offset,var total){
    if(offset<total){
      return IconButton(onPressed: (){},
          icon: Icon(
            Icons.expand_more
          )
      );
    }
    else {
      return SizedBox(height: 2,);
    }
  }
}
