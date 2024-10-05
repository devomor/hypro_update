import 'package:flutter/foundation.dart';
import 'package:flutter_hypro/controller/pusher_config_controller.dart';
import 'package:flutter_hypro/notification_service/notification_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  // final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  Rx<String> log = 'output:\n'.obs;
  List<dynamic> logList = [];
  RxInt eventCount = 0.obs;

  NotificationService notificationService = NotificationService();

  // Initialize GetStorage
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    notificationService.initialiseNotification();
    // Load logList from GetStorage when the controller is initialized
    Get.find<PusherConfigController>().getPusherConfig().then((value) {
      if (box
          .hasData('${Get.find<PusherConfigController>().message!.channel}')) {
        logList =
            (box.read('${Get.find<PusherConfigController>().message!.channel}')
                    as List)
                .obs;
      }
      initializePusher();
      triggerEventAutomatically(); // Automatically trigger the event when the app starts
    });
  }

  void clearAllData() {
    logList.clear(); // Clear the logList
    GetStorage().remove(
        '${Get.find<PusherConfigController>().message!.channel}'); // Remove the data from GetStorage
    eventCount.value = 0; // Reset eventCount to 0
    update(); // Trigger an update to refresh the UI
  }

  // void logMessage(String text, {bool addToLogList = false}) {
  //   if (kDebugMode) {
  //     print("LOG: $text");
  //   }
  //   if (addToLogList) {
  //     final logEntry = "$text\n";
  //     logList.add(logEntry); // Add log message to the list
  //     // Save logList to GetStorage whenever it's updated
  //     box.write('logList', logList.toList());
  //     update(); // Trigger an update to refresh the UI
  //   }
  // }

  // void logMessage(String text, {bool addToLogList = false}) {
  //   if (kDebugMode) {
  //     print("LOG: $text");
  //   }
  //
  //   if (addToLogList) {
  //     final timestamp = DateFormat('MMMM d, yyyy h:mm a').format(DateTime.now());
  //
  //     // Remove spaces and line breaks from the text
  //     final cleanedText = text.replaceAll(RegExp(r'\s+'), '');
  //
  //     final logEntry = "$cleanedText\n$timestamp\n"; // Add a line break before the formatted timestamp
  //
  //     logList.add(logEntry); // Add log entry to the list
  //
  //     // Save logList to GetStorage whenever it's updated
  //     box.write('logList', logList.toList());
  //     update(); // Trigger an update to refresh the UI
  //   }
  // }

  void logMessage(String text, {bool addToLogList = false}) {
    if (kDebugMode) {
      print("LOG: $text");
    }

    if (addToLogList) {
      final timestamp =
          DateFormat('MMMM d, yyyy h:mm a').format(DateTime.now());

      final cleanedText = text.replaceAll(RegExp(r'\s+'),
          ' '); // Remove all line breaks and replace with a space

      final logEntry = "$cleanedText\n$timestamp\n";

      logList.add(logEntry);
      box.write('${Get.find<PusherConfigController>().message!.channel}',
          logList.toList());
      update();

      // Display the cleaned text in the notification
      notificationService.scheduleNotification("Notification", cleanedText);
    }
  }

  void initializePusher() async {
    try {
      // await pusher.init(
      //   apiKey: '${Get.find<PusherConfigController>().message!.apiKey}',
      //   cluster: '${Get.find<PusherConfigController>().message!.cluster}',
      //   onConnectionStateChange: onConnectionStateChange,
      //   onError: onError,
      //   onSubscriptionSucceeded: onSubscriptionSucceeded,
      //   onEvent: onEvent,
      //   onSubscriptionError: onSubscriptionError,
      //   onDecryptionFailure: onDecryptionFailure,
      //   onMemberAdded: onMemberAdded,
      //   onMemberRemoved: onMemberRemoved,
      //   onSubscriptionCount: onSubscriptionCount,
      // );
      // await pusher.subscribe(
      //   channelName: '${Get.find<PusherConfigController>().message!.channel}',
      // );
      // await pusher.connect();
    } catch (e) {
      logMessage("ERROR: $e");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    logMessage("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    logMessage("onError: $message code: $code exception: $e");
  }

  // void onEvent(PusherEvent event) {
  //   final eventData = event.data.toString();
  //   final parsedData = jsonDecode(eventData); // Parse the event data JSON
  //   final text = parsedData["message"]["description"]["text"]
  //       as String; // Extract the "text" field
  //   if (kDebugMode) {
  //     print(text);
  //   }
  //   logMessage(text, addToLogList: true); // Log and add the text in the UI
  //   eventCount.value++;
  //   update(); // Trigger an update to refresh the UI
  //
  //   // Display a local notification when a pusher event is received
  //   notificationService.scheduleNotification("Notification", text);
  // }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    logMessage("onSubscriptionSucceeded: $channelName data: $data");
    // final me = pusher.getChannel(channelName)?.me;
    // logMessage("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    logMessage("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    logMessage("onDecryptionFailure: $event reason: $reason");
  }

  // void onMemberAdded(String channelName, PusherMember member) {
  //   logMessage("onMemberAdded: $channelName user: $member");
  // }

  // void onMemberRemoved(String channelName, PusherMember member) {
  //   logMessage("onMemberRemoved: $channelName user: $member");
  // }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    logMessage(
        "onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

  void triggerEventAutomatically() async {
    try {
      await Future.delayed(const Duration(
          seconds: 2)); // Delay for 2 seconds before triggering the event
      // pusher.trigger(PusherEvent(
      //   channelName: '${Get.find<PusherConfigController>().message!.channel}',
      //   eventName: '${Get.find<PusherConfigController>().message!.event}',
      // ));
    } catch (e) {
      logMessage("ERROR: $e", addToLogList: true);
    }
  }
}
