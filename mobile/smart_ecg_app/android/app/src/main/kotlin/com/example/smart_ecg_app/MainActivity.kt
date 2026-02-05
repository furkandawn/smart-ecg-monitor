package com.example.smart_ecg_app // Ensure this matches your package name!

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.view.WindowManager
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            // Android 8.1 and newer
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            // Older Android versions
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
    }
}