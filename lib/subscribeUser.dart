import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled3/userTrainDes.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  // بيانات نموذجية للاشتراكات
  final List<Subscription> subscriptions = [
    Subscription(
      type: 'نادي رياضي',
      name: 'نادي الفتح',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 45)),
      imageUrl: "img/logo.png", // استبدل بمسار صورةك
      remainingDays: 45,
      active: true,
    ),
    Subscription(
      type: 'مدرب شخصي',
      name: 'أحمد محمد',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      imageUrl: "img/logo.png", // استبدل بمسار صورةك
      remainingDays: 30,
      active: true,
    ),
    Subscription(
      type: 'أخصائي تغذية',
      name: 'د. سارة عبدالله',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().subtract(const Duration(days: 5)),
      imageUrl: "img/logo.png", // استبدل بمسار صورةك
      remainingDays: 0,
      active: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAAAAA),
      appBar: AppBar(
          backgroundColor: Color(0xFF0B5022),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Text('اشتراكاتي',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "IBMPlexSansArabic",
                )),
            SizedBox(
              width: 30,
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اشتراكاتك النشطة',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "IBMPlexSansArabic",
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1))
                  ]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  return SubscriptionCard(subscription: subscriptions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Subscription {
  final String type;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final int remainingDays;
  final bool active;

  Subscription({
    required this.type,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.remainingDays,
    required this.active,
  });
}

class SubscriptionCard extends StatelessWidget {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController allweekdayHoursController =
      TextEditingController();
  final TextEditingController priceMonthController = TextEditingController();
  final TextEditingController price3MonthsController = TextEditingController();
  final TextEditingController priceYearController = TextEditingController();
  final Subscription subscription;

  SubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');

    return Card(
      color: Color(0xFFAAAAaa),
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: subscription.active
                        ? Colors.green[100]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subscription.active ? 'نشط' : 'منتهي',
                    style: TextStyle(
                      color: subscription.active ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        subscription.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subscription.type,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0B5022),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      AssetImage(subscription.imageUrl), // استخدام AssetImage
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'تاريخ البدء',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic"),
                    ),
                    Text(dateFormat.format(subscription.startDate)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تاريخ الانتهاء',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic"),
                    ),
                    Text(dateFormat.format(subscription.endDate)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الأيام المتبقية',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic"),
                    ),
                    Text(
                      '${subscription.remainingDays} يوم',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!subscription.active)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GymProfileViewScreen(
                            cityController: cityController,
                            areaController: areaController,
                            allweekdayHoursController:
                                allweekdayHoursController,
                            priceMonthController: priceMonthController,
                            price3MonthsController: price3MonthsController,
                            priceYearController: priceYearController,
                            facilities: [], // Pass an empty list for now
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0B5022),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'تجديد الاشتراك',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic"),
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
