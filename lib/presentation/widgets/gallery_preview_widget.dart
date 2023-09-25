import 'package:flutter/material.dart';
class GalleryPreview extends StatelessWidget {
  final List<String> imageUrls;
  const GalleryPreview({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       for (var i = 0; i < imageUrls.length; i++)
      (i < 3)? Container(
           margin: const EdgeInsets.only(right: 5),
           child: ClipRRect(
             borderRadius: BorderRadius.circular(10),
             child: Image.network(
               imageUrls[i],
               width: MediaQuery.of(context).size.width * 0.23,
               height: MediaQuery.of(context).size.width * 0.23,
               fit: BoxFit.cover,
             ),
           ))
       : (i == 3) ?Container(
         margin: const EdgeInsets.only(right: 5),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(10),
           child: Container(
             width: 50,
             height: 50,
             color: Colors.grey[300],
             child: Center(
               child: Text(
                 '+${imageUrls.length - 3}',
                 style: TextStyle(fontSize: 20, color: Colors.grey[500]),
               ),
             ),
           ),
         ),
       ): Container(),

      ],
    );
  }
}
