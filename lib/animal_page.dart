import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnimalPage extends StatefulWidget {
  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  String selectedAnimal = '';
  String selectedGender = '';
  String selectedProtectionStatus = '';
  String selectedRegion = '';
  List<String> regions = [
    '서울',
    '부산',
    '대구',
    '인천',
    '광주',
    '대전',
    '울산',
    '세종',
    '경기',
    '강원',
    '충북',
    '충남',
    '전북',
    '전남',
    '경북',
    '경남',
    '제주',
  ];
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('발견한 동물을 등록해요!'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 38),
            GestureDetector(
              onTap: () async {
                final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
              },
              child: Container(
                width: 250,
                height: 250,
                color: Colors.green,
                child: Center(
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : Text(
                    '동물 이미지',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '어떤 동물인가요?',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 16),
                AnimalButton(
                  text: '강아지',
                  isSelected: selectedAnimal == '강아지',
                  onPressed: () {
                    setState(() {
                      selectedAnimal = '강아지';
                    });
                  },
                ),
                SizedBox(width: 8),
                Text('강아지'),
                SizedBox(width: 16),
                AnimalButton(
                  text: '고양이',
                  isSelected: selectedAnimal == '고양이',
                  onPressed: () {
                    setState(() {
                      selectedAnimal = '고양이';
                    });
                  },
                ),
                SizedBox(width: 8),
                Text('고양이'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '성별',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 16),
                GenderButton(
                  text: '수컷',
                  isSelected: selectedGender == '수컷',
                  onPressed: () {
                    setState(() {
                      selectedGender = '수컷';
                    });
                  },
                ),
                SizedBox(width: 8),
                Text('수컷'),
                SizedBox(width: 16),
                GenderButton(
                  text: '암컷',
                  isSelected: selectedGender == '암컷',
                  onPressed: () {
                    setState(() {
                      selectedGender = '암컷';
                    });
                  },
                ),
                SizedBox(width: 8),
                Text('암컷'),
                SizedBox(width: 16),
                GenderButton(
                  text: '몰라요',
                  isSelected: selectedGender == '몰라요',
                  onPressed: () {
                    setState(() {
                      selectedGender = '몰라요';
                    });
                  },
                ),
                SizedBox(width: 8),
                Text('몰라요'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '임시 보호중 여부',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 16),
                ProtectionStatusButton(
                  text: '예',
                  isSelected: selectedProtectionStatus == '예',
                  onPressed: () {
                    setState(() {
                      selectedProtectionStatus = '예';
                    });
                  },
                ),
                SizedBox(width: 8),
                Text('예'),
                SizedBox(width: 16),
                ProtectionStatusButton(
                  text: '아니요',
                  isSelected: selectedProtectionStatus == '아니요',
                  onPressed: () {
                    setState(() {
                      selectedProtectionStatus = '아니요';
                    });
                  },
                ),
                SizedBox(width: 8),
                Text('아니요'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '지역 선택',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 16),
                RegionRectangularButton(
                  selectedRegion: selectedRegion,
                  regions: regions,
                  onChanged: (String? value) {
                    setState(() {
                      selectedRegion = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                if (_selectedImage != null) {
                  // 이미지를 Firebase Storage에 업로드
                  final storage = FirebaseStorage.instance;
                  final Reference storageReference = storage.ref().child(
                      'animal_images/${DateTime.now().millisecondsSinceEpoch}${_selectedImage!.path.split('/').last}');
                  await storageReference.putFile(_selectedImage!);

                  // 업로드한 이미지의 URL을 가져오기
                  final String imageUrl = await storageReference.getDownloadURL();

                  // Firestore에 데이터 추가
                  await FirebaseFirestore.instance.collection('animals').add({
                    'animal_type': selectedAnimal,
                    'gender': selectedGender,
                    'protection_status': selectedProtectionStatus,
                    'region': selectedRegion,
                    'image_url': imageUrl,
                  });

                  print('동물 등록 정보:');
                  print('동물 종류: $selectedAnimal');
                  print('성별: $selectedGender');
                  print('임시 보호 여부: $selectedProtectionStatus');
                  print('지역: $selectedRegion');
                  print('이미지 URL: $imageUrl');
                }
              },
              child: Text('등록'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const AnimalButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        child: Center(
          child: isSelected
              ? Icon(
            Icons.check,
            size: 18,
            color: Colors.blue,
          )
              : null,
        ),
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const GenderButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        child: Center(
          child: isSelected
              ? Icon(
            Icons.check,
            size: 18,
            color: Colors.blue,
          )
              : null,
        ),
      ),
    );
  }
}

class ProtectionStatusButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const ProtectionStatusButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        child: Center(
          child: isSelected
              ? Icon(
            Icons.check,
            size: 18,
            color: Colors.blue,
          )
              : null,
        ),
      ),
    );
  }
}

class RegionRectangularButton extends StatelessWidget {
  final String selectedRegion;
  final List<String> regions;
  final ValueChanged<String?> onChanged;

  const RegionRectangularButton({
    required this.selectedRegion,
    required this.regions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final selectedValue = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text('지역 선택'),
              children: regions.map((String value) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, value);
                  },
                  child: Text(value),
                );
              }).toList(),
            );
          },
        );
        if (selectedValue != null) {
          onChanged(selectedValue);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
      ),
      child: Text(selectedRegion.isEmpty ? '지역 선택' : selectedRegion),
    );
  }
}
