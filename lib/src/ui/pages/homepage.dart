import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:news_application/src/bloc/bloc/news_bloc.dart';
import 'package:news_application/src/modal/article.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../modal/countrylist.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String country = 'us';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEDDBC7),
      body: MultiBlocProvider(providers: [
        BlocProvider(
            create: (context) =>
                NewsBloc()..add(Neweventstart(country: country)))
      ], child: SafeArea(child: buildbody(context))),
    );
  }

  Widget buildbody(BuildContext context) {
    return Column(
      children: [
        dropdown(context),
        searchbox(context),
        SizedBox(
          height: 20,
        ),
        BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return Center(
                  child: LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.black,
                      rightDotColor: Colors.white,
                      size: 200));
            } else if (state is NewsLoaded) {
              List<Article> datalist = state.newlist;
              return Expanded(
                  child: ListView.builder(
                      itemCount: datalist.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Article dataitem = datalist[index];

                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final uri = Uri.parse(dataitem.url);
                                    await launchUrl(uri);
                                  },
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      imageUrl: dataitem.urlToImage
                                                  .toString() ==
                                              'null'
                                          ? 'https://s.abcnews.com/images/US/wirestory_50644fb91216cf775e4a356e4f21cb9b_16x9_992.jpg'
                                          : dataitem.urlToImage,
                                      placeholder: (context, url) {
                                        return LoadingAnimationWidget.inkDrop(
                                            color: Colors.white, size: 25);
                                      },
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/notfound.jpg'))),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Column(children: [
                                    Text(
                                      dataitem.description.toString() == 'null'
                                          ? 'Not have more detial'
                                          : dataitem.description,
                                      maxLines: 3,
                                    )
                                  ]),
                                )
                              ],
                            ),
                          ),
                        );
                      }));
            } else {
              return Center(
                child: Text('Failed'),
              );
            }
          },
        )
      ],
    );
  }

  Widget dropdown(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        return Container(
          color: Color(0xffF9F5E7),
          padding: EdgeInsets.symmetric(vertical: 5),
          child: DropdownButton(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            underline: SizedBox(),
            iconSize: 30,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
            dropdownColor: Colors.blueGrey.shade100,
            menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
            isExpanded: true,
            onChanged: (value) {
              country = value.toString();

              setState(() {
                context.read<NewsBloc>().add(Neweventstart(country: country));
              });
            },
            value: country,
            items: item.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                      child: Text(
                    value.toUpperCase(),
                  )));
            }).toList(),
          ),
        );
      },
    );
  }

  Widget searchbox(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            setState(() {
              context.read<NewsBloc>().add(Neweventstart(keyword: value));
            });
          },
          decoration: InputDecoration(hintText: 'searchhere'),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
