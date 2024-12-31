  /// post
  Future ParentLogin({var email, var password}) async {
    try {
      Map data = {
        "email": email,
        "password": password,
      };
      final response = await dioClient.post(
          "${BaseUrl.baseUrl}auth/sign_in?email=$email&password=$password",
          data: data);
      if (response.statusCode == 200) {
        print(response.statusCode);
        return response;
      }else if(response.statusCode == 401){
        AppUtils.errorSnackBar('${response.data['errors'][0]??"Enter Valid Credentials"}');
      }
    } catch (e) {
      if (e is DioError) {
        signInController.Loading.value = false;
        AppUtils.errorSnackBar('Enter Valid Credentials');
      }
    }
  }

  /// get
  Future Students() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      dioClient.options.headers["uid"] = prefs.getString('uid').toString();
      dioClient.options.headers["client"] = prefs.getString('client');
      dioClient.options.headers["access-token"] = prefs.getString('token');

      final response = await dioClient.get(
        "${BaseUrl.baseUrl}current-user-details",
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        return response;
      }
    } catch (e) {
      if (e is DioError) {
        AppUtils.errorSnackBar('Unable to load contents ');
      }
    }
  }

// controller logic
  notifications()async{
    isLoading.value = true;
    update();
    var response = await API().Notifications();
    if(response.statusCode == 200){
      notificationsList = response.data['notifications'];
       unreadNotifications = List<Map<String, dynamic>>.from(response.data['notifications'])
          .where((notification) => notification['read_at'] == null)
          .toList();
      print(unreadNotifications.length);
      isLoading.value = false;
      update();
    }else{
      print("Error");
      isLoading.value = false;
      update();

    }
  }

// snackbar
  class AppUtils{
  static SnackbarController successSnackbar(String msg) {
    return Get.snackbar(
      "Success!",
      msg,
      // "Login Successfully",
      icon: const Icon(Icons.verified_user, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: successColor,
      borderRadius: 20.sp,
      margin: EdgeInsets.all(15.sp),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
  }