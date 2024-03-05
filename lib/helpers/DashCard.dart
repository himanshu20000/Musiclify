import 'package:flutter/material.dart';

import 'package:musiclify/models/DashCardModel.dart';

class DashCard extends StatelessWidget {
  const DashCard({super.key, required this.cardModel});
  final CardModel cardModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        CircleAvatar(
          radius: size.height * 0.06,
          backgroundImage: Image.network(
            cardModel.songImg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.amber,
            ),
          ).image,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text(
          cardModel.artistName,
          maxLines: 2,
          // overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: size.height * 0.02,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
