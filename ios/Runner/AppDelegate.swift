import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate  , FlutterStreamHandler {
    
    private static var CHANNEL_NAME = "count_handler_method";
    private static var EVENT_NAME = "count_handler_event";
    private var handler = DispatchQueue.main
    var timer = Timer()
    // Declare our eventSink, it will be initialized later
    private var eventSink: FlutterEventSink?
    private var counter = 100
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      //1
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      //2
      let eventChannel = FlutterEventChannel(name: "count_handler_event", binaryMessenger: controller.binaryMessenger)
      eventChannel.setStreamHandler(self)
      //3
      let methodChannel = FlutterMethodChannel(name: "count_handler_method",binaryMessenger: controller.binaryMessenger)
      //4
      prepareMethodHandler(methodChannel: methodChannel)
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  
 private func prepareMethodHandler(methodChannel: FlutterMethodChannel) {
        
        // 5
     methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            // 6
            if call.method == "getCounter" {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.eventSink!(self.counter)
                    self.counter = self.counter+1
                })
            }
            else {
                
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
    }
    
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen......")
        self.eventSink = eventSink
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("onCancel......")
        eventSink = nil
        return nil
    }


}
