package com.brainants.multipartrequest;

import android.util.Log;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;

import okhttp3.Headers;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class MultipartRequest {

    private static final MediaType MEDIA_TYPE_PNG = MediaType.parse("image/png");

    public void sendMultipartRequest(String url, Map<String, String> headers, Map<String, String> fields, ArrayList<Object> files, ProgressRequestBody.Listener listener) throws Exception {
        OkHttpClient client = new OkHttpClient();

        MultipartBody.Builder requestBodyBuilder = new MultipartBody.Builder().setType(MultipartBody.FORM);

        requestBodyBuilder = fullfillFields(requestBodyBuilder, fields);

        requestBodyBuilder = fullfillFiles(requestBodyBuilder, files);

        MultipartBody requestBody = requestBodyBuilder.build();

        ProgressRequestBody progressRequestBody = new ProgressRequestBody(requestBody, listener);

        Request.Builder requestBuilder = new Request.Builder()
                .url(url)
                .post(progressRequestBody);

        requestBuilder = fullfillHeaders(requestBuilder, headers);
        Request request = requestBuilder.build();


        Response response = client.newCall(request).execute();
        if (response.isSuccessful()) {
            listener.onComplete(response.body().string());
        } else {
            listener.onError();
            throw new IOException("Unexpected code " + response);
        }

    }

    private Request.Builder fullfillHeaders(Request.Builder request, Map<String, String> headers) {
        for (Map.Entry<String, String> entry : headers.entrySet()) {
            Log.d("Multipart", "Header " + entry.getKey() + " has value " + entry.getValue());
            request.addHeader(entry.getKey(), entry.getValue());
        }
        return request;
    }

    private MultipartBody.Builder fullfillFields(MultipartBody.Builder bodyBuilder, Map<String, String> fields) {
        for (Map.Entry<String, String> entry : fields.entrySet()) {
            bodyBuilder.addFormDataPart(
                    entry.getKey(), entry.getValue());
        }
        return bodyBuilder;
    }

    private MultipartBody.Builder fullfillFiles(MultipartBody.Builder bodyBuilder, ArrayList<Object> files) {
        for (int i = 0; i < files.size(); i++) {

            Map<String, String> file = (Map<String, String>) files.get(i);
            Log.d("Multipart", "File " + file.get("field") + " has value " + file.get("path"));

            String[] names = file.get("path").split("/");
            bodyBuilder.addFormDataPart(
                    file.get("field"), names[names.length-1],RequestBody.create(null, new File(file.get("path"))));


        }
        return bodyBuilder;
    }
}
