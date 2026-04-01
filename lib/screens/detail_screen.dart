import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DetailScreen extends StatefulWidget {
  final String tenThuoc;

  DetailScreen({required this.tenThuoc});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TimeOfDay? selectedTime;
  Duration? countdown;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initNotification();
  }

  void initNotification() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await notificationsPlugin.initialize(
        InitializationSettings(android: androidSettings));

    tz.initializeTimeZones();
  }

  Future<void> scheduleNotification(TimeOfDay time) async {
    final now = DateTime.now();

    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      0,
      "Nhắc uống thuốc",
      widget.tenThuoc,
      tz.TZDateTime.from(scheduled, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          "id",
          "med",
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    startCountdown(scheduled);
  }

  void startCountdown(DateTime target) {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      final diff = target.difference(DateTime.now());

      setState(() {
        countdown = diff.isNegative ? Duration.zero : diff;
      });
    });
  }

  Future<void> pickTime() async {
    TimeOfDay? t = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());

    if (t != null) {
      setState(() => selectedTime = t);
      scheduleNotification(t);
    }
  }

  String format(Duration d) {
    return "${d.inHours}:${d.inMinutes % 60}:${d.inSeconds % 60}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tenThuoc)),
      body: Column(
        children: [
          ListTile(
            title: Text("Chọn giờ"),
            subtitle: Text(selectedTime == null
                ? "Chưa chọn"
                : selectedTime!.format(context)),
            onTap: pickTime,
          ),
          if (countdown != null)
            Text("⏳ ${format(countdown!)}"),
        ],
      ),
    );
  }
}