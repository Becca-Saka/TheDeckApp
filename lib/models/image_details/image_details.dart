class ImageDetails {
  int index;
  bool onFirestore;
  bool onLocal;
  bool isImageRemoved;
  bool isImageUpdated;
  String? firebaseUrl;
  String? localUrl;

  ImageDetails({
    required this.index,
    this.onFirestore = false,
    this.onLocal = false,
    this.isImageRemoved = false,
    this.isImageUpdated = false,
    this.firebaseUrl,
    this.localUrl,
  });
}
