import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/tutorial-videos/tutorial-videos.dart';

class VideosListScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideosListCubit>(
      create: (_)=> VideosListCubit(VideosListState()),
      child: BlocBuilder<VideosListCubit, VideosListState>(
        builder: (context,state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Tutorial Videos"),),
            body: Column(children: [
              Expanded(
                child: ListView.builder(
                    itemCount: Videos.tutorialVideos.length,
                    itemBuilder: (context, index){
                      final videoStatus = state.videoStatuses?[Videos.tutorialVideos[index].id] ?? "New";
                      return Card(
                        child: RawMaterialButton(
                          onPressed: ()=>NavUtils.navTo(context, AppVideoPlayer(Videos.tutorialVideos[index]), onReturn: (){
                            context.read<VideosListCubit>().updateStatus(Videos.tutorialVideos[index].id, "Watched");
                          }),
                          child: GenericListItem(
                            verticalPadding: 10,
                            leading: Container(height: 80,width: 80, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))), child:  Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Icon(Icons.play_circle, color: Theme.of(context).primaryColor,), const SizedBox(height:5), Text("00:59", style: Theme.of(context).textTheme.bodySmall,)],),),
                            label: Videos.tutorialVideos[index].title,
                            desc: Videos.tutorialVideos[index].description,
                            desc2: videoStatus,

                          ),
                        ),
                      );
                    }),
              )
            ],),
          );
        }
      ),
    );
  }

}