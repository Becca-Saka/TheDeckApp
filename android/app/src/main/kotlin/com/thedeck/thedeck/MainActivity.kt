package com.thedeck.thedeck

import io.flutter.embedding.android.FlutterActivity
import android.app.NotificationManager
import android.content.Context
class MainActivity: FlutterActivity() {
    override fun onResume() {
        super.onResume()
        closeAllNotifications();
    }
    //To Remove notifications

    private fun closeAllNotifications() {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()
    }
}

