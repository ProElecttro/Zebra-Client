import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String name = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) => _validateNotEmpty(value, "Name"),
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) => _validateNotEmpty(value, "Email"),
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                validator: _validatePassword,
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                child: const Text("Register"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement Google Sign-In logic
                },
                child: const Text("Sign up with Google"),
              ),
              const SizedBox(height: 20),
              AdManagerBannerAd(),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _registerUser() {
    // Implement user registration logic
  }
}

class AdManagerBannerAd extends StatefulWidget {
  @override
  State createState() => AdManagerBannerAdState();
}

class AdManagerBannerAdState extends State<AdManagerBannerAd> {
  late BannerAd _ad;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: 'your-admob-banner-ad-id',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: AdWidget(ad: _ad),
      width: _ad.size.width.toDouble(),
      height: _ad.size.height.toDouble(),
    );
  }
}
