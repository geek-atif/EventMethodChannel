package com.atifqamar.event_channel

import android.annotation.SuppressLint
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class MainActivity: FlutterActivity() , MethodCallHandler , EventChannel.StreamHandler  {
    private val eventChannel = "count_handler_event"
    private val methodChannel = "count_handler_method"
    private var eventSink: EventSink? = null
    private var handler = Handler(Looper.getMainLooper())
    private var counter = 100
    private val TAG = "com.atifqamar.event_channel.MainActivity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler(this)
    }

    @SuppressLint("LongLogTag")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getCounter" -> {
                Log.d(TAG, "getCounter()")
                // every second send the time
                val r: Runnable = object : Runnable {
                    override fun run() {
                        handler.post {
                            Log.d(TAG, "getCounter() counter  $counter" )
                            eventSink?.success(counter)
                            counter ++
                        }
                        handler.postDelayed(this, 1000)
                    }
                }
                handler.postDelayed(r, 1000)

            }
            else -> { // Note the block
                print("No Method")
            }
        }
    }

    @SuppressLint("LongLogTag")
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen()" )
       this.eventSink = events
    }

    @SuppressLint("LongLogTag")
    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel()" )
        this.eventSink = null
    }
}
