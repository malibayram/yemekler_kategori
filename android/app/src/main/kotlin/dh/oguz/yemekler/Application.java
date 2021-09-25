package dh.oguz.yemekler;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    // ...
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }


    @Override
    public void registerWith(PluginRegistry registry) {
        // https://stackoverflow.com/a/64293290/6378949
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(getApplicationContext()));
    }
    // ...
}