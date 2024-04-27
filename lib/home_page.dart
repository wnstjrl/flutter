import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:untitled22/animal_page.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('유기동물 목록'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 38),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAllAnimalDetails(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.deepOrangeAccent,
                ),
                child: Text('찾아주세요', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(width: 22),
              ElevatedButton(
                onPressed: () {
                  print('발견했어요 버튼이 클릭되었습니다.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnimalPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.greenAccent,
                ),
                child: Text('발견했어요', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          SizedBox(height: 38),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('animals').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var items = snapshot.data?.docs ?? [];

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    var imageUrl = items[index]['image_url'];
                    var animalType = items[index]['animal_type'];
                    var gender = items[index]['gender'];
                    var protectionStatus = items[index]['protection_status'];
                    var region = items[index]['region'];

                    return GestureDetector(
                      onTap: () {
                        _showAnimalDetails(context, imageUrl, animalType, gender, protectionStatus, region);
                      },
                      child: Container(
                        color: Colors.yellow,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAnimalDetails(BuildContext context, String imageUrl, String animalType, String gender, String protectionStatus, String region) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Animal Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Animal Type: $animalType'),
              Text('Gender: $gender'),
              Text('Protection Status: $protectionStatus'),
              Text('Region: $region'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAllAnimalDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('All Animal Details'),
          content: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('animals').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var items = snapshot.data?.docs ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((animalData) {
                  var animalType = animalData['animal_type'];
                  var gender = animalData['gender'];
                  var protectionStatus = animalData['protection_status'];
                  var region = animalData['region'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Animal Type: $animalType'),
                      Text('Gender: $gender'),
                      Text('Protection Status: $protectionStatus'),
                      Text('Region: $region'),
                      SizedBox(height: 16.0),
                    ],
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}