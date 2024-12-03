package com.example.price_checker;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "scanner_channel";
    private MethodChannel methodChannel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize the MethodChannel
        methodChannel = new MethodChannel(
                getFlutterEngine().getDartExecutor().getBinaryMessenger(),
                CHANNEL
        );
    }

    // Non-static method to send barcode to Flutter
    public void sendBarcodeToFlutter(String barcode) {
        if (methodChannel != null) {
            methodChannel.invokeMethod("onBarcodeScanned", barcode);
        }
    }
}