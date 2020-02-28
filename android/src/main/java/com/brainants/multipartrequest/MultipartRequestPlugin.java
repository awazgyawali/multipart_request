package com.brainants.multipartrequest;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.AsyncTask;

import java.util.ArrayList;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


public class MultipartRequestPlugin implements MethodCallHandler {
    static MethodChannel channel;
    Activity activity;

    public static void registerWith(Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), "multipart_request");
        MultipartRequestPlugin multipartRequestPlugin = new MultipartRequestPlugin();
        multipartRequestPlugin.activity = registrar.activity();
        channel.setMethodCallHandler(multipartRequestPlugin);
    }

    @SuppressLint("StaticFieldLeak")
    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("multipartRequest")) {
            final Map<String, Object> arguments = call.arguments();
            final String url = (String) arguments.get("url");
            final Map<String, String> headers = (Map<String, String>) arguments.get("headers");
            final Map<String, String> fields = (Map<String, String>) arguments.get("fields");
            final ArrayList<Object> files = (ArrayList<Object>) arguments.get("files");

            new AsyncTask<Void, Void, Void>() {
                @SuppressWarnings("unchecked")
                @Override
                protected Void doInBackground(Void... voids) {
                    try {
                        new MultipartRequest().sendMultipartRequest(url, headers, fields, files, new ProgressRequestBody.Listener() {
                            @Override
                            public void onProgress(final int progress) {
                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("progress", progress + "");
                                    }
                                });
                            }

                            @Override
                            public void onComplete(final String response) {
                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("complete", response);
                                    }
                                });
                            }

                            @Override
                            public void onError() {
                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        channel.invokeMethod("error", "");
                                    }
                                });
                            }
                        });
                    } catch (Exception e) {
                        e.printStackTrace();
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                channel.invokeMethod("error", "");
                            }
                        });
                    }
                    return null;
                }
            }.execute();


            result.success("Aba request garincha");
        } else {
            result.notImplemented();
        }
    }
}
