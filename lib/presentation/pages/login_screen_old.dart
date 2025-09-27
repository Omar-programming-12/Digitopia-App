import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  
  // TODO: fix this later
  Future<void> loginWithEmail() async {
    if(emailController.text.isEmpty || passwordController.text.isEmpty){
      print("please fill all fields");
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    
    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("login success");
      // navigate to home - will implement later
    } catch (e) {
      print("login failed: $e");
      // show error message
    }
    
    setState(() {
      isLoading = false;
    });
  }

  // google signin - not working properly yet
  Future<void> signInWithGoogle() async {
    print("google signin clicked");
    // TODO: implement google signin
    // having issues with configuration
  }
  
  void phoneLogin() {
    // will add phone auth later
    print("phone login not implemented yet");
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 60),

            /// البريد الإلكتروني
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                hintText: "أدخل بريدك الإلكتروني",
              ),
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),

            /// كلمة المرور
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "كلمة المرور",
                hintText: "أدخل كلمة المرور",
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),

            /// زر تسجيل الدخول بالبريد
            ElevatedButton(
              onPressed: isLoading ? null : loginWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: isLoading ? CircularProgressIndicator(color: Colors.white) : const Text("تسجيل الدخول"),
            ),

            const SizedBox(height: 16),
            const Text("أو", textAlign: TextAlign.center),
            const SizedBox(height: 8),

            /// زر تسجيل الدخول بجوجل
            SignInButton(
              Buttons.Google,
              text: "تسجيل الدخول باستخدام جوجل",
              onPressed: signInWithGoogle,
            ),

            const SizedBox(height: 16),

            /// رقم الهاتف
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "رقم الهاتف",
                hintText: "أدخل رقم هاتفك",
              ),
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: phoneLogin,
              child: const Text("تسجيل الدخول باستخدام رقم الهاتف"),
            ),

            const SizedBox(height: 20),

            /// زر الانتقال لصفحة التسجيل
            TextButton(
              onPressed: () {
                // TODO: create signup screen
                print("signup clicked");
              },
              child: const Text("ليس لديك حساب؟ سجل الآن"),
            ),
          ],
        ),
      ),
    );
  }
}