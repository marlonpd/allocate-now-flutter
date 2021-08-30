import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DriveHelper {
  late GoogleSignInAccount currentUser;

// Specify the permissions required at login
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      DriveApi.driveFileScope,
    ],
  );

  static init(BuildContext buildContext) async {
    DriveHelper driveHelper = DriveHelper();

    driveHelper._googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      driveHelper.currentUser = account!;
    });
    await driveHelper._googleSignIn.signInSilently();

    return driveHelper;
  }

  // google sign in
  Future<Null> handleSignIn() async {
    await _googleSignIn.signIn();
  }

  Future handleSignOut() async {
    await _googleSignIn.signOut();
  }

  // Upload a file to Google Drive.
  Future uploadFile(BuildContext buildContext) async {
    if (currentUser == null) {
      launchPage(buildContext, WelcomePage());
      return;
    }

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DatabaseHelper.dataBaseName);

    //
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new drive.DriveApi(client);

    var localFile = new io.File(path);
    var media = new drive.Media(localFile.openRead(), localFile.lengthSync());
    drive.File driveFile = new drive.File()
      ..title = DatabaseHelper.dataBaseName;
    return (await api.files.insert(
      driveFile,
      uploadMedia: media,
    ))
        .id;
  }

  // Upload a file to Google Drive.
  Future deleteFile(BuildContext buildContext, drive.File file) async {
    if (currentUser == null) {
      launchPage(buildContext, WelcomePage());
      return;
    }

    //
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new drive.DriveApi(client);

    await api.files.delete(file.id);
  }

// Download a file from Google Drive.
  Future downloadFile(BuildContext buildContext, drive.File file) async {
    if (currentUser == null) {
      launchPage(buildContext, WelcomePage());
      return false;
    }

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DatabaseHelper.dataBaseName);

    performDriveRequest(
      buildContext: buildContext,
      file: io.File(path),
      headers: await currentUser.authHeaders,
      url: file.downloadUrl ?? '',
    );

    return true;
    //
  }

  Future<List<File>> getAllFiles(BuildContext buildContext) async {
    if (currentUser == null) {
      launchPage(buildContext, WelcomePage());
      return [];
    }
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new drive.DriveApi(client);

    return (await api.files.list()).items;
  }

  Future performDriveRequest(
      {@required BuildContext buildContext,
      @required io.File file,
      @required Map<String, String> headers,
      @required String url}) async {
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));

    headers.forEach((k, v) {
      request.headers.set(k, v);
    });

    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      var _downloadData = List<int>();
      response.listen((d) => _downloadData.addAll(d), onDone: () {
        file.writeAsBytes(_downloadData).then((v) {
          showDistivityDialog(buildContext,
              actions: [
                getButton('Refresh', onPressed: () {
                  MyApp.dataModel = null;
                  DistivityRestartWidget.restartApp(buildContext);
                })
              ],
              title: 'Calendars and events downloaded', stateGetter: (ctx, ss) {
            return getText(
                'Your calendars and your events from your last saved file from drive are now on your device');
          });
        });
      });
    } else {
      return null;
    }
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
