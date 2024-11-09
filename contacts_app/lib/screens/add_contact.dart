import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  late TextEditingController _nameController, _numberController;
  String _typeSelected ='';

late DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.ref().child('Contacts');
  }


Widget _buildContactType(String title){

  return InkWell(

    child: Container(
      height: 40,
      width: 90,

      decoration: BoxDecoration(
        color: _typeSelected == title? Colors.green : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Center(child: Text(title, style: const TextStyle(fontSize: 18,
      color: Colors.white),
    ),),),

    onTap: (){
      setState(() {
        _typeSelected = title;
      });
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Contact'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Name',
                prefixIcon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(
                hintText: 'Enter Number',
                prefixIcon: Icon(
                  Icons.phone_iphone,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
           const SizedBox(height: 15,),
           SizedBox(
             height: 40,
             child: ListView(

               scrollDirection: Axis.horizontal,
               children: [
                 _buildContactType('Work'),
                 const SizedBox(width: 10),
                 
                 _buildContactType('Family'),
                 const SizedBox(width: 10),
                 _buildContactType('Friends'),
                 const SizedBox(width: 10),
                 _buildContactType('Others'),
               ],
             ),
           ),
           const SizedBox(height: 25,),
           Container(
             width: double.infinity,
             padding: const EdgeInsets.symmetric(horizontal: 10),
             child: ElevatedButton(onPressed: (){
               saveContact();
             }, child: null,),
             ),
          ],
        ),
      ),
    );
  }
  void saveContact(){

    String name = _nameController.text;
    String number = _numberController.text;

    Map<String,String> contact = {
      'name':name,
      'number': '+91 $number',
      'type': _typeSelected,
    };

    _ref.push().set(contact).then((value) {
      Navigator.pop(context);
    });


  }
}