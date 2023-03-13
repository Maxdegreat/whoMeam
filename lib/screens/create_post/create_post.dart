import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whomeam/models/post_model.dart';
import 'package:whomeam/repository/file_picker.dart';
import 'package:whomeam/repository/open_ai_repo.dart';

class CreatePost extends StatefulWidget {
  static const String routeName = "createpost";
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const CreatePost());
  }

  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool canGenerate = false;
  final TextEditingController _promptController = TextEditingController();
  Post post = Post.empty();
  FilePickerWM fileManager = FilePickerWM();
  List<File> files = [];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              "Make New Art",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    FilePickerWM.pickFile().then((value) {
                      if (value != null) {
                        files.add(value);
                      }
                    });
                  },
                  icon: const Icon(Icons.file_upload_sharp)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.download))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  generateTf(context),
                  const SizedBox(
                    height: 7,
                  ),
                  TextButton(
                      onPressed: () {
                        post = Post.empty();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Start over",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      )),
                  if (post.dalleArtUrls.isNotEmpty) ...[
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: PageView.builder(
                        itemCount: post.dalleArtUrls.length,
                        itemBuilder: (context, index) {
                          return post.dalleArtUrls.isNotEmpty
                              ? Image.network(post.dalleArtUrls[index])
                              : const SizedBox.shrink();
                        },
                      ),
                    )
                  ] else ...[
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      color: Colors.grey[300],
                      child: const Center(
                          child: Text(
                        "Import Selfies to animate OR type text to use DALL-E's API to generate an image",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      )),
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row generateTf(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Align(
                alignment: Alignment.center,
                child: TextField(
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        canGenerate = true;
                      });
                    } else {
                      setState(() {
                        canGenerate = false;
                      });
                    }
                  },
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 18),
                  expands: false,
                  autocorrect: true,
                  controller: _promptController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "define your new art",
                    hintStyle: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              try {
                if (_promptController.text.isNotEmpty &&
                    post.dalleArtUrls.isEmpty) {
                  context
                      .read<OpenaiRepo>()
                      .createImage(prompt: _promptController.text)
                      .then((value) {
                    if (value.created > 0) {
                      for (var i in value.data) {
                        var temp = List<String>.from(post.dalleArtUrls);
                        temp.add(i.url);
                        post = post.copyWith(dalleArtUrls: temp);
                        setState(() {});
                      }
                    }
                  });
                  // add to the app state post
                }
              } catch (e) {
                log("error in CreatePost: $e");
              }
            },
            child: Text(
              "Generate",
              style: canGenerate
                  ? Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Theme.of(context).colorScheme.primary)
                  : Theme.of(context).textTheme.caption,
            ))
      ],
    );
  }
}
