import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:solutionchallenge/components/lists/base_grid.dart';

import '../components/avatar.dart';
import '../models/user.dart' as user_model;
import '../utils/firebase_getter.dart';

class ProfilePage extends StatefulWidget {
  final String profileID;

  const ProfilePage({Key? key, required this.profileID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Future<Uint8List?>? _ppicFut;
  user_model.User? profile;

  Future<void> downloadProfile() async {
    profile = await getUser("/User/${widget.profileID}");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ppicFut = ppicDownload(widget.profileID);
    downloadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await downloadProfile();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FirebaseAvatar(
                      radius: 30,
                      ppicFut: _ppicFut,
                      nameFut: profile?.name,
                    ),
                    const SizedBox(width: 10),
                    FutureBuilder(
                      builder: (context, snapshot) {
                        if (profile == null ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const Text("Loading...");
                        } else if (snapshot.hasError) {
                          return const Text("Error");
                        } else {
                          return Text(profile!.name);
                        }
                      },
                      future: _ppicFut,
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                expandedHeight: MediaQuery.of(context).size.height * 0.1,
                child: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.list_alt,
                        color: Colors.blue,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.bookmark_border,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              pinned: true,
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (profile == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Error"));
                      } else {
                        return BaseGrid(
                          userId: profile!.id,
                        );
                      }
                    },
                    // const BaseGrid()
                  ),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (profile == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Error"));
                      } else {
                        return BaseGrid(
                          userId: widget.profileID,
                        );
                      }
                    },
                    // const BaseGrid()
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.expandedHeight,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        child != oldDelegate.child;
  }
}
