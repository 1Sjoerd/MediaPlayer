package com.example.media_player

import android.os.Bundle
import android.app.PictureInPictureParams
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import cl.puntito.simple_pip_mode.PipCallbackHelperActivityWrapper

class MainActivity: PipCallbackHelperActivityWrapper() {
    private val CHANNEL = "com.example.media_player"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "enterPipMode") {
                enterPipMode()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun enterPipMode() {
        val params = PictureInPictureParams.Builder()
            .build()
        Log.d("PiP", "Attempting to enter PiP mode")
        enterPictureInPictureMode(params)
    }
}
