import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: SignInScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم التسجيل بنجاح")),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "حدث خطأ")),
        );
      }
      setState(() => isLoading = false);
    }
  }

  
  bool _googleSignInInitialized = false;

  // تهيئة GoogleSignIn
  Future<void> _initGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      clientId: '<YOUR_WEB_CLIENT_ID_IF_NEEDED>', // اكتب Web Client ID لو مطلوب
    );
    _googleSignInInitialized = true;
  }

  Future<void> signInWithGoogle() async {
    try {
      if (!_googleSignInInitialized) {
        await _initGoogleSignIn();
      }

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      // authenticate بدل signIn
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate(
        // في التوثيق الرسمي، `scopeHint` أو authorizeScopes ممكن يُستخدم لو عايز scopes إضافية
        scopeHint: ['email'],
      );

      if (googleUser == null) {
        // المستخدم لغى تسجيل الدخول
        return;
      }

      // بعد كده خذ authentication
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      // ملاحظة: في النسخة الجديدة، `accessToken` غالبًا ما يكون غير متاح مباشرة
      // لو المنصة تدعم، تقدر تستخدم authorizeScopes أو authorizationClient.authorizationForScopes
      final String? accessToken = (await googleUser.authorizationClient ?.authorizationForScopes(['email'])) as String?;

      if (idToken == null) {
        throw Exception('لا يوجد idToken');
      }

      // لو عايز تستخدم accessToken لو مش null
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      print("✅ تم تسجيل الدخول بجوجل بنجاح");
    } catch (e) {
      print("❌ خطأ في تسجيل الدخول بجوجل: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تسجيل حساب جديد"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          leading: const BackButton(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // الاسم الكامل
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value!.isEmpty ? 'أدخل اسمك الكامل' : null,
                ),
                const SizedBox(height: 16),

                // البريد الإلكتروني
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) => value!.contains('@') ? null : 'أدخل بريدًا صحيحًا',
                ),
                const SizedBox(height: 16),

                // كلمة المرور
                TextFormField(
                  controller: passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) => value!.length < 6 ? 'كلمة المرور قصيرة جدًا' : null,
                ),
                const SizedBox(height: 16),

                // تأكيد كلمة المرور
                TextFormField(
                  controller: confirmPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) =>
                      value != passController.text ? 'كلمتا المرور غير متطابقتين' : null,
                ),
                const SizedBox(height: 24),

                // زر التسجيل
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: _registerWithEmail,
                          child: const Text('تسجيل للدخول بالبريد الإلكتروني'),
                        ),
                      ),

                const SizedBox(height: 20),

                const Divider(thickness: 1),
                const Text('أو سجل باستخدام'),

                const SizedBox(height: 16),


                // التسجيل باستخدام Google
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.mail_outline),
                    label: const Text("التسجيل باستخدام جوجل"),
                    onPressed: signInWithGoogle,
                  ),
                ),
                const SizedBox(height: 10),

             
             
                // التسجيل برقم الهاتف (واجهة فقط)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.phone),
                    label: const Text("التسجيل باستخدام رقم الهاتف"),
                    onPressed: () {
                      // انتقل إلى صفحة التسجيل برقم الهاتف
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}