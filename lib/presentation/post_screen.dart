import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/data/report_repository.dart';
import 'package:hypester/presentation/webview.dart';
import 'package:hypester/presentation/widgets/source_name_widgets.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../data/models/post_model.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  final String keyword;

  const PostScreen({super.key, required this.post, required this.keyword});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  ReportRepository _reportRepository = GetIt.I.get();
  String selectedOption = 'Content of a sexual nature';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var titleLength = widget.post.title != null ? widget.post.title!.length : 0;
    var maxLines = 3;
    var toolBarHeight = 60.0;
    if (titleLength > 50) {
      maxLines = 4;
      toolBarHeight = 100.0;
    }
    if (titleLength > 100) {
      maxLines = 5;
      toolBarHeight = 120.0;
    }
    if (titleLength > 150) {
      maxLines = 6;
      toolBarHeight = 140.0;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: toolBarHeight,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              _handlePopupItemClick(value, context);
            },
            elevation: 1,
            itemBuilder: (BuildContext context) {
              return {'Share', 'Report'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      Icon(
                        choice == 'Share' ? Icons.ios_share : Icons.report_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(choice),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
        title: (widget.post.title != null)
            ? Text(
                widget.post.title!,
                style: const TextStyle(fontSize: 18),
                maxLines: maxLines,
              )
            : null,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: ListView(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //const SizedBox(height: 8),
                if (widget.post.imageUrl != '' && widget.post.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.post.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey[500],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (widget.post.imageUrl != '' && widget.post.imageUrl != null) SizedBox(height: 15),
                if (widget.post.body != null && !widget.post.isHtml)
                  Text(
                    widget.post.body!,
                    style: const TextStyle(fontSize: 15),
                    //softWrap: false,
                  ),
                if (widget.post.body != null && widget.post.isHtml)
                HtmlWidget(
                  widget.post.body!,
                  textStyle: const TextStyle(fontSize: 15),
                  //onTapUrl: (url) => Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(post: widget.feed.posts[index]))),


                ),
                if (widget.post.isGallery) _buildGallery(widget.post.galleryUrls!),
                SizedBox(height: 8),
                Text(
                  DateFormat('HH:mm dd.MM.yyyy').format(widget.post.date),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SourceNameWidget(title: widget.post.sourceName),
                    if (widget.post.channel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.only(right: 5),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          widget.post.channel!,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const Spacer(),
                    if (widget.post.views != null && widget.post.views! > 0) ...[
                      const Icon(Icons.remove_red_eye_outlined, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        widget.post.views.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 5),
                    ],
                    const Icon(
                      Icons.favorite_outline,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.post.likes.toString(),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                if (widget.post.numComments > 0) _buildRedditComments(),
              ]),
            ],
          )),
    );
  }

  void _handlePopupItemClick(String value, BuildContext context) {
    switch (value) {
      case 'Report':
        showGeneralDialog(
            context: context,
            pageBuilder: (context, anim1, anim2) => Container(),
            barrierColor: Colors.black.withOpacity(0.5),
            barrierDismissible: true,
            barrierLabel: '',
            transitionDuration: const Duration(milliseconds: 200),
            transitionBuilder: (context, anim1, anim2, child) {
              return StatefulBuilder(builder: (context, setState) {
                return Transform.scale(
                  scale: anim1.value,
                  child: Opacity(
                    opacity: anim1.value,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      title: Text('Report'),
                      //content: Text('Are you sure you want to report this post?'),
                      content: SizedBox(
                        width: 300,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            Text('Choose a reason for the report:'),
                            ListTile(
                              title: Text('Content of a sexual nature'),
                              leading: Radio(
                                value: 'Content of a sexual nature',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Violent or repulsive scenes'),
                              leading: Radio(
                                value: 'Violent or repulsive scenes',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Verbal abuse or intolerance'),
                              leading: Radio(
                                value: 'Verbal abuse or intolerance',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Harassment or bullying'),
                              leading: Radio(
                                value: 'Harassment or bullying',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Harmful or dangerous actions'),
                              leading: Radio(
                                value: 'Harmful or dangerous actions',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('False information'),
                              leading: Radio(
                                value: 'False information',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Cruelty towards children'),
                              leading: Radio(
                                value: 'Cruelty towards children',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Terrorism propaganda'),
                              leading: Radio(
                                value: 'Terrorism propaganda',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Spam or false information'),
                              leading: Radio(
                                value: 'Spam or false information',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Violation of the law'),
                              leading: Radio(
                                value: 'Violation of the law',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Other'),
                              leading: Radio(
                                value: 'Other',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _reportRepository.saveReport(widget.post.date, widget.post.sourceName, widget.post.linkToOriginal!, widget.post.id, selectedOption);
                            Navigator.of(context).pop();
                          },
                          child: Text('Report'),
                        ),
                      ],
                    ),
                  ),
                );
              });
            });
        break;
      case 'Share':
        Share.share(widget.post.linkToOriginal!);
        break;
    }
  }

  Widget _buildGallery(List<String> imageUrls) {
    return Column(
      children: [
        const SizedBox(height: 15),
        for (var imageUrl in imageUrls)
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey[500],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRedditComments() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                        post: Post(
                            title: widget.post.title,
                            relinkUrl: widget.post.linkToOriginal,
                            numComments: widget.post.numComments,
                            id: widget.post.id,
                            sourceName: widget.post.sourceName,
                            date: widget.post.date,
                            linkToOriginal: widget.post.linkToOriginal),
                      )));
            },
            child: Text('View comments (${widget.post.numComments})'),
          ),
        ),
      ],
    );
  }
}
