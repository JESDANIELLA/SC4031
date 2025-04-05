# SC4031 - IoT

## 1. Term Paper - TraceTogether BLE

## 2. Flutter-based Image Classification App with Flask Backend

Flutter-based mobile application designed for fruits image classification (10 groups). It uses a TensorFlow Lite (TFLite) model to perform inference and prediction on images uploaded via the app. The app supports gallery uploads and communicates with a Flask backend server for processing.

### Demo Video
https://youtu.be/xrEKxUjpwIY

### Setup

#### Flask Backend
- Run the Flask server in the root folder by executing the command:
```
$ python3 app.py
```
#### Flutter App
1. Install Dependencies
```
pip install -r requirements.txt

```
3. Clone the Repository
```
git clone https://github.com/JESDANIELLA/SC4031-.git
cd SC4031-/CourseProject
```

2.Install Dependencies
```
flutter pub get
```
3. Add Permissions to AndroidManifest.xml
```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```
4. Run the App
```
flutter run
```
=
