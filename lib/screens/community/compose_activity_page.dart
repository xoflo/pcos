import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// A page to compose a new [Activity]/post.
///
/// - feed: "user"
/// - verb: "post"
/// - object: "text data"
/// - data: media
///
/// [More information](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart) on activities.
class ComposeActivityPage extends StatefulWidget {
  ComposeActivityPage({Key? key, required this.onAddActivity})
      : super(key: key);

  final Function onAddActivity;

  @override
  State<ComposeActivityPage> createState() => _ComposeActivityPageState();
}

class _ComposeActivityPageState extends State<ComposeActivityPage> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _isPosting = false;
  Map<String, Object>? _uploadedMedia;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /// "Post" a new activity to the "user" feed group.
  Future<void> _post() async {
    if (!_isPosting) {
      _isPosting = true;

      if (_textEditingController.text.isEmpty) {
        _isPosting = false;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot post an empty message')));
      }

      await context.feedBloc.onAddActivity(
        feedGroup: 'public',
        verb: 'post',
        object: _textEditingController.text,
        to: [FeedId.id('public:all')],
        data: _uploadedMedia,
      );

      _uploadedMedia = null;
      context.feedUploadController.clear();

      Navigator.pop(context);

      widget.onAddActivity();
    }
  }

  // Pick an image from the gallery and upload it to Stream CDN.
  Future<void> _pickAndUploadMedia() async {
    // Only allow one media upload
    if (_uploadedMedia == null) {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 600,
        maxWidth: 300,
        imageQuality: 70,
      );

      if (image != null) {
        await context.feedUploadController
            .uploadImage(AttachmentFile(path: image.path));

        final media =
            context.feedUploadController.getMediaUris()?.toExtraData();
        if (media != null) {
          setState(() {
            _uploadedMedia = media;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cancelled image selection')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('Compose'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ActionChip(
              label: const Text(
                'Post',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              backgroundColor: backgroundColor,
              onPressed: _post,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: new ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        controller: _textEditingController,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        maxLines: null,
                        style: TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                            hintText: "What's on your mind",
                            border: InputBorder.none),
                      ),
                    )),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _pickAndUploadMedia,
                    icon: Icon(
                      Icons.collections,
                      color: _uploadedMedia != null
                          ? Colors.grey
                          : backgroundColor,
                    ),
                  ),
                  Text(
                    'Photo/Camera',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              if (_uploadedMedia != null)
                UploadListCore(
                  uploadController: context.feedUploadController,
                  loadingBuilder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  uploadsErrorBuilder: (error) =>
                      Center(child: Text(error.toString())),
                  uploadsBuilder: (context, uploads) {
                    return SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: uploads.length,
                        itemBuilder: (context, index) => FileUploadStateWidget(
                            fileState: uploads[index],
                            onRemoveUpload: (attachment) {
                              return context.feedUploadController
                                  .removeUpload(attachment);
                            },
                            onCancelUpload: (attachment) {
                              return context.feedUploadController
                                  .cancelUpload(attachment);
                            },
                            onRetryUpload: (attachment) async {
                              return context.feedUploadController
                                  .uploadImage(attachment);
                            }),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
