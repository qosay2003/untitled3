import 'package:flutter/material.dart';

class Managesubscribers extends StatefulWidget {
  @override
  _managesubscribers createState() => _managesubscribers();
}

class _managesubscribers extends State<Managesubscribers> {
  // Controllers for the input fields
  TextEditingController nameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  TextEditingController idController = TextEditingController();

  // List to store subscribers in memory
  List<Map<String, String>> subscribers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAAAAAA),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- Header ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: const Color(0xFF0B5022),
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10),
                  // Title
                  Expanded(
                    child: Center(
                      child: Text(
                        'مشتركيني',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "IBMPlexSansArabic",
                        ),
                      ),
                    ),
                  ),
                  // Profile image
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('img/greenlogo.png'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // ---------------- Form ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'اضافة مشترك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "IBMPlexSansArabic",
                    ),
                  ),
                  SizedBox(height: 10),

                  // Name
                  _buildTextField(
                    controller: nameController,
                    label: 'الاسم',
                  ),

                  // Start date
                  _buildTextField(
                    controller: startDateController,
                    label: 'تاريخ بداية الاشتراك',
                    hint: '00/00/0000',
                  ),

                  // End date
                  _buildTextField(
                    controller: endDateController,
                    label: 'تاريخ نهاية الاشتراك',
                    hint: '00/00/0000',
                  ),

                  // Subscriber ID
                  _buildTextField(
                    controller: idController,
                    label: 'رقم المشترك',
                  ),

                  SizedBox(height: 10),

                  // Add button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate inputs
                        if (nameController.text.isEmpty ||
                            startDateController.text.isEmpty ||
                            endDateController.text.isEmpty ||
                            idController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                              'يرجى ملء جميع الحقول',
                              style: TextStyle(
                                fontFamily: "IBMPlexSansArabic",
                              ),
                            )),
                          );
                          return;
                        }

                        // Add subscriber to the list
                        setState(() {
                          subscribers.add({
                            'name': nameController.text,
                            'startDate': startDateController.text,
                            'endDate': endDateController.text, // Add end date
                            'id': idController.text,
                          });

                          // Clear input fields
                          nameController.clear();
                          startDateController.clear();
                          endDateController.clear();
                          idController.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                            'تم إضافة المشترك بنجاح',
                            style: TextStyle(
                              fontFamily: "IBMPlexSansArabic",
                            ),
                          )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B5022),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // ---------------- Data Table ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                color: Colors.grey[300],
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade600),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2), // Adjusted for new column
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    // Table header
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[400]),
                      children: [
                        _buildTableHeader('الاسم'),
                        _buildTableHeader('تاريخ البداية'),
                        _buildTableHeader('تاريخ النهاية'), // New header
                        _buildTableHeader('ID'),
                      ],
                    ),
                    // Dynamically generate table rows from subscribers list
                    ...subscribers.map((subscriber) {
                      return TableRow(
                        children: [
                          _buildTableCell(subscriber['name'] ?? ''),
                          _buildTableCell(subscriber['startDate'] ?? ''),
                          _buildTableCell(
                              subscriber['endDate'] ?? ''), // New cell
                          _buildTableCell(subscriber['id'] ?? ''),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Helper Widgets ----------

  // TextField Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: "IBMPlexSansArabic",
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  // Table Header Cell
  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "IBMPlexSansArabic",
            )),
      ),
    );
  }

  // Table Data Cell
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(child: Text(text)),
    );
  }
}
