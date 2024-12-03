package com.example.price_checker;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class ScannerBroadcastReceiver extends BroadcastReceiver {
    private MainActivity mainActivity;

    // Constructor to receive MainActivity reference
    public ScannerBroadcastReceiver(MainActivity activity) {
        this.mainActivity = activity;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if ("nlscan.action.SCANNER_RESULT".equals(intent.getAction())) {
            String barcode = intent.getStringExtra("SCAN_BARCODE1");
            if (mainActivity != null) {
                mainActivity.sendBarcodeToFlutter(barcode); // Send barcode to Flutter
            }
        }
    }
}