import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String key;

  User({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.key,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'full_name': name,
      'email': email,
      'cell_number': phoneNumber,
      'password': password,
    };
  }
}

Future<void> submitData(User user) async {
  final url = Uri.parse('https://muhoko_form-1-q6650955.deta.app/form');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(user.toJson());

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    // Data submitted successfully
    print('Data submitted successfully');
  } else {
    // Error submitting data
    throw Exception('Failed to submit data: ${response.statusCode}');
  }
}

void main() async {
  // runApp(MyApp());
  print(Userdata);
  runApp(UserListScreen());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyForm(),
      routes: {
        '/users': (context) => UserListScreen(),
        // '/third': (context) => ThirdPage(),
      },
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Form'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text("Sign Up Form"),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please Enter Your Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: 'Enter your email'),
                  validator: (value) {
                    if ((value != null && value.isEmpty) ||
                        (value != null && value.contains('@'))) {
                      return 'Please Enter a Valid  Email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _keyController,
                  decoration: const InputDecoration(labelText: 'Key'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please Enter Your Key';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter the password',
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please Enter Your Password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      final user = User(
                        phoneNumber: _phoneNumberController.text,
                        email: _emailController.text,
                        name: _nameController.text,
                        password: _passwordController.text,
                        key: _keyController.text,
                      );

                      await submitData(user);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 192, 188, 188),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button background color
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Button border radius
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}

// Do something with the list of users
// Get a list of all items in the database
class Userdata {
  final String cellNumber;
  final String email;
  final String fullName;
  final String key;
  final String password;

  Userdata({
    required this.cellNumber,
    required this.email,
    required this.fullName,
    required this.key,
    required this.password,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
      cellNumber: json['cell_number'],
      email: json['email'],
      fullName: json['full_name'],
      key: json['key'],
      password: json['password'],
    );
  }
}

Future<List<Userdata>> fetchData() async {
  final response =
      await http.get(Uri.parse('https://muhoko_form-1-q6650955.deta.app/form'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Userdata.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<Userdata>> futureUserdata;

  @override
  void initState() {
    super.initState();
    futureUserdata = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Center(
        child: FutureBuilder<List<Userdata>>(
          future: futureUserdata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text(user.cellNumber),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
