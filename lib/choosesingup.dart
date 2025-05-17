import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled3/bissingup.dart';
import 'package:untitled3/usersingup.dart';
import 'package:untitled3/TrainersSingup.dart';

// صفحات وهمية لكل دور (يمكنك استبدالها بصفحاتك الفعلية)
class EmployerPage extends StatelessWidget {
  const EmployerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة صاحب العمل')),
      body: const Center(child: Text('مرحبًا بصاحب العمل!')),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة المستخدم')),
      body: const Center(child: Text('مرحبًا بالمستخدم!')),
    );
  }
}

class TrainerPage extends StatelessWidget {
  const TrainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة أخصائي التغذية/المدرب')),
      body: const Center(child: Text('مرحبًا بالأخصائي!')),
    );
  }
}

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة المتجر الإلكتروني')),
      body: const Center(child: Text('مرحبًا بالمتجر!')),
    );
  }
}

class choosesingup extends StatelessWidget {
  const choosesingup({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = [
      {'title': 'صاحب عمل', 'icon': FontAwesomeIcons.userTie},
      {'title': 'مستخدم', 'icon': FontAwesomeIcons.user},
      {'title': 'اخصائي تغذية/مدرب شخصي', 'icon': FontAwesomeIcons.dumbbell},
      {'title': 'متجر الكتروني', 'icon': Icons.store},
    ];

    // قائمة الصفحات المرتبطة بكل دور
    final pages = [
      Bissingup(), //بزنس
      Usersingup(), //مستخدم
      trainerssingup(), // مدربين
      StorePage(), //متاجر
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 96, 45),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 96, 45),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'img/logo.png', // ضع هنا مسار اللوغو (Path of the logo)
                  width: 300, // يمكنك تعديل العرض حسب الحاجة
                  height: 300, // يمكنك تعديل الارتفاع حسب الحاجة
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: roles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final icon = roles[index]['icon'];
                return ElevatedButton(
                  onPressed: () {
                    // الانتقال إلى الصفحة المرتبطة بالفهرس (index)
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => pages[index]),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E4D2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black26,
                    padding: EdgeInsets.zero,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon is IconData
                          ? Icon(icon, color: Colors.white, size: 40)
                          : FaIcon(
                              icon as IconData,
                              color: Colors.white,
                              size: 10,
                            ),
                      const SizedBox(height: 10),
                      Text(
                        roles[index]['title'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
