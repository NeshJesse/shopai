// feature_upvote_page.dart
import 'package:flutter/material.dart';
import 'package:shopai/baselayout.dart';

class FeatureUpvotePage extends StatefulWidget {
  @override
  _FeatureUpvotePageState createState() => _FeatureUpvotePageState();
}

class _FeatureUpvotePageState extends State<FeatureUpvotePage> {
  List<Feature> features = [
    Feature(name: 'Feature 1', threshold: 300),
    Feature(name: 'Feature 2', threshold: 250),
    Feature(name: 'Feature 3', threshold: 150),
    // Add more features here
  ];

  void _voteFeature(int index) {
    setState(() {
      if (!features[index].hasVoted) {
        features[index].votes++;
        features[index].hasVoted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBar: AppBar(
        title: Text('Feature Upvote'),
      ),
      child: ListView.builder(
        itemCount: features.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(features[index].name),
              subtitle: Text(
                  '${features[index].votes}/${features[index].threshold} votes'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_upward),
                onPressed: () => _voteFeature(index),
                color: features[index].hasVoted ? Colors.grey : Colors.blue,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Feature {
  final String name;
  int votes;
  final int threshold;
  bool hasVoted;

  Feature({
    required this.name,
    this.votes = 0,
    required this.threshold,
    this.hasVoted = false,
  });
}
