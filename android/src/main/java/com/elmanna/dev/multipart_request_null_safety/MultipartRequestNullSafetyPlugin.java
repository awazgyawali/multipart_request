package com.elmanna.dev.multipart_request_null_safety;

import androidx.annotation.NonNull;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import java.util.ArrayList;
import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/** MultipartRequestNullSafetyPlugin */
public class MultipartRequestNullSafetyPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  Context context;
  Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "multipart_request_null_safety");
    channel.setMethodCallHandler(this);
  }

   @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
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
                if(activity != null) {
                  activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                      channel.invokeMethod("progress", progress + "");
                    }
                  });
                }
              }

              @Override
              public void onComplete(final String response) {
                if(activity != null) {
                  activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                      channel.invokeMethod("complete", response);
                    }
                  });
                }
              }

              @Override
              public void onError() {
                if(activity != null) {
                  activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                      channel.invokeMethod("error", "");
                    }
                  });
                }
              }
            });
          } catch (Exception e) {
            e.printStackTrace();
            if(activity != null) {
              activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                  channel.invokeMethod("error", "");
                }
              });
            }
          }
          return null;
        }
      }.execute();


      result.success("Aba request garincha");
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onDetachedFromActivity() {
//    System.out.print("i got deattached!!");
//    TODO("Not yet implemented")
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
//    System.out.print("igot reattached!!");
//    TODO("Not yet implemented")
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
//    System.out.print("am attached!!");
    activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
//    System.out.print("deattached for config changes!!");
//    TODO("Not yet implemented")
  }
}
