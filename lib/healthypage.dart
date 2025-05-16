import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled3/Bmical.dart';
import 'package:untitled3/IdealWeightCal.dart';

class Healthypage extends StatefulWidget {
  const Healthypage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Healthypage createState() => _Healthypage();
}

class _Healthypage extends State<Healthypage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, String> _dailyPlans = {};
  TextEditingController _planController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _planController.text = _dailyPlans[selectedDay] ?? '';
    });
  }

  void _savePlan() {
    if (_selectedDay != null && _planController.text.isNotEmpty) {
      setState(() {
        _dailyPlans[_selectedDay!] = _planController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFAAAAAA),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Text(
              " تطورك الصحي  ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "IBMPlexSansArabic",
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
          backgroundColor: Color(0xFF0B5022),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16),
                  child: Text(
                    "حاسبات",
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                              offset: Offset(1, 1))
                        ]),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BmiCalculator()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 20,
                      backgroundColor: Color(0xFFAAAAAA),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Image.asset(
                      "img/calc1.jpeg",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IdealWeightCalculator()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 20,
                      backgroundColor: Color.fromRGBO(170, 170, 170, 1),
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Image.asset(
                      "img/calc2.jpeg",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(
                width: 30,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "  حاسبة احتياجك اليومي من السعرات",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B5022),
                          shadows: [
                            Shadow(
                                color: Color(0xFF0B5022),
                                blurRadius: 5,
                                offset: Offset(1, 1))
                          ]),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 70,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "  حاسبة الوزن المثالي ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B5022),
                          shadows: [
                            Shadow(
                                color: Color(0xFF0B5022),
                                blurRadius: 5,
                                offset: Offset(1, 1))
                          ]),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              )
            ]),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Container(
                  child: Image.asset(
                    "img/healthy.png",
                    width: 400,
                    height: 200,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.black),
                defaultTextStyle: TextStyle(color: Colors.black),
                todayDecoration: BoxDecoration(
                  color: Color(0xFF0B5022).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF0B5022),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.black),
                weekendStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            if (_selectedDay != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _planController,
                      decoration: InputDecoration(
                        labelText:
                            'خطتك اليومية ليوم ${_selectedDay!.day}/${_selectedDay!.month}',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _savePlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0B5022),
                      ),
                      child: Text(
                        'حفظ الخطة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (_dailyPlans[_selectedDay] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Text(
                              ' الهدف:',
                              style: TextStyle(
                                  backgroundColor: Colors.black,
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ' ${_dailyPlans[_selectedDay]}',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ])),
        ));
  }
}
