import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//  wrong design 
// convert this widget to a way you can get benefit from it when you display case detail 
// e.x hide the ddx and anloy you can see the ddx after pressing of this Widget
// 2 parameter the title and the body (the answer)
class CaseViewCard extends ConsumerStatefulWidget {
  final String caseName;
  final String author;
  final String date;
  const CaseViewCard(
      {required this.caseName,
      required this.author,
      required this.date,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CaseViewCardState();
}

class _CaseViewCardState extends ConsumerState<CaseViewCard> {
  bool active = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          active = !active;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Color.fromARGB(255, 60, 26, 70),
          headerBuilder: (context, isExpanded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.caseName,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 20
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("By: ${widget.author}"), Text(widget.date)],
            ),
          ),
          isExpanded: active,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}
// }
// class CaseViewCard extends ConsumerWidget {
//   final String caseName;
//   final String author;
//   final String date;
//   const CaseViewCard({required this.caseName,required this.author,required this.date, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ExpansionPanelList(

//     )
// //     Card(
// //       color: Colors.purple[500],
// //       elevation: 5,
// //       shadowColor: Colors.black,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(15),
// //       ),
// //       child: ListTile(
// //         title: Text(caseName, style: Theme.of(context).textTheme.headlineMedium,),
// //         subtitle: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text("By: $author"),
// // Text(date)
// //           ],
// //         ),
// //       ),
// //     );
//   }
// }