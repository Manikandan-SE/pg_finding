import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pg_finding/utils/index.dart';

import '../models/index.dart';

class AppServices {
  final dio = Dio();

  // var baseUrl =
  //     'https://eb57-2409-4072-38c-669d-c65-8701-c208-4612.ngrok-free.app';

  Future<String?> fetchBaseUrl() async {
    const String mockApiUrl =
        'https://674c12f354e1fca9290b94ac.mockapi.io/getBaseUrl';
    try {
      // Send HTTP GET request
      final response = await dio.get(mockApiUrl);

      if (response.statusCode == 200) {
        // Parse the response
        List<BaseUrlModel> data =
            baseUrlModelFromJson(json.encode(response.data));
        await setBaseUrl(data.first.baseUrl);
        return data.first.baseUrl;
      } else {
        print('Failed to fetch baseurl: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch baseurl: $e');
    }
    return null;
  }

  Future<int?> postUserMobileNumber({required String phoneNumber}) async {
    var baseUrl = getBaseUrl();

    var requestUrl = '$baseUrl/saveOrUpdate?phoneNumber=$phoneNumber';
    try {
      // Send HTTP GET request
      final response = await dio.post(requestUrl);

      if (response.statusCode == 200) {
        return await fetchUserId(
          phoneNumber: phoneNumber,
        );
      } else {
        print('Failed to postUserMobileNumber: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to postUserMobileNumber: $e');
    }
    return null;
  }

  Future<int?> fetchUserId({required String phoneNumber}) async {
    var baseUrl = getBaseUrl();
    var requestUrl = '$baseUrl/getUserId?phoneNumber=$phoneNumber';
    try {
      // Send HTTP GET request
      final response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        await setUserId('${data['userId']}');
        return data['userId'];
      } else {
        print('Failed to fetchUserId: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetchUserId: $e');
    }
    return null;
  }

  Future<List<FilterPgModel?>?> fetchFilterPG({
    String? tempBaseUrl,
    int? tempUserId,
    String? pgName,
    String? pgType,
    String? pgCategory,
    String? roomCategory,
    String? city,
    String? pgId,
  }) async {
    var baseUrl = tempBaseUrl ?? getBaseUrl();
    var userId = tempUserId != null ? '$tempUserId' : getUserId();

    var requestUrl =
        '$baseUrl/filtered?pgName=${pgName ?? ''.trim()}&pgType=${pgType ?? ''.trim()}&pgCategory=${pgCategory ?? ''.trim()}&roomCategory=${roomCategory ?? ''}&city=${city ?? ''.trim()}&userId=${userId ?? ''}&pgId=${pgId ?? ''.trim()}'
            .trim();

    try {
      // Send HTTP GET request
      final response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        List<FilterPgModel> data =
            filterPgModelFromJson(json.encode(response.data));
        return data;
      } else {
        print('Failed to fetchFilterPG: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to fetchFilterPG: $e');
    }
    return null;
  }

  Future<List<FilterPgModel?>?> fetchPopularPG({
    String? tempBaseUrl,
  }) async {
    var baseUrl = tempBaseUrl ?? getBaseUrl();

    var requestUrl = '$baseUrl/popular';
    try {
      // Send HTTP GET request
      final response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        List<FilterPgModel> data =
            filterPgModelFromJson(json.encode(response.data));
        return data;
      } else {
        print('Failed to fetchPopularPG: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to fetchPopularPG: $e');
    }
    return null;
  }

  Future<List<LocalityModel?>?> fetchLocality({
    String? tempBaseUrl,
  }) async {
    var baseUrl = tempBaseUrl ?? getBaseUrl();
    var requestUrl = '$baseUrl/Locality';
    try {
      // Send HTTP GET request
      final response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        List<LocalityModel> data =
            localityModelFromJson(json.encode(response.data));
        return data;
      } else {
        print('Failed to fetchLocality: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to fetchLocality: $e');
    }
    return null;
  }

  Future<List<SuggestionModel?>?> fetchSuggestion({
    String? param,
  }) async {
    var baseUrl = getBaseUrl();

    var requestUrl = '$baseUrl/search?param=$param';
    try {
      // Send HTTP GET request
      final response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        List<SuggestionModel> data =
            suggestionModelFromJson(json.encode(response.data));
        return data;
      } else {
        print('Failed to fetchSuggestion: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to fetchSuggestion: $e');
    }
    return null;
  }

  Future<List<FilterPgModel?>?> fetchSavedList() async {
    var baseUrl = getBaseUrl();
    var userId = getUserId();

    var requestUrl = '$baseUrl/saved?userId=$userId';

    try {
      // Send HTTP GET request
      final response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        List<FilterPgModel> data =
            filterPgModelFromJson(json.encode(response.data));
        return data;
      } else {
        print('Failed to fetchSavedList: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to fetchSavedList: $e');
    }
    return null;
  }

  Future<void> postSave({
    int? pgId,
    bool? isSaved,
  }) async {
    var baseUrl = getBaseUrl();
    var userId = getUserId();

    var requestUrl = '$baseUrl/save?pgId=$pgId&userId=$userId&saved=$isSaved';

    try {
      // Send HTTP GET request
      final response = await dio.post(requestUrl);

      if (response.statusCode == 200) {
      } else {
        print('Failed to postSave: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to postSave: $e');
    }
  }

  Future<void> postBookPg({
    int? pgId,
    String? booked,
    String? amount,
    String? transactionId,
  }) async {
    var baseUrl = getBaseUrl();
    var userId = getUserId();

    var requestUrl =
        '$baseUrl/book?pgId=$pgId&userId=$userId&booked=$booked&amount=$amount&transactionId=${transactionId ?? ''.trim()}';

    try {
      // Send HTTP GET request
      final response = await dio.post(requestUrl);

      if (response.statusCode == 200) {
      } else {
        print('Failed to postBookPg: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to postBookPg: $e');
    }
  }

  Future<List<BookingListModel?>?> fetchBookingList() async {
    var baseUrl = getBaseUrl();
    var userId = getUserId();

    var requestUrl = '$baseUrl/booking/get/byid?userId=$userId';

    try {
      // Send HTTP GET request
      final response = await dio.get(requestUrl);

      if (response.statusCode == 200) {
        List<BookingListModel> data =
            bookingListModelFromJson(json.encode(response.data));
        return data;
      } else {
        print('Failed to fetchBookingList: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to fetchBookingList: $e');
    }
    return null;
  }

  Future<void> patchCancelBookedpg({
    int? pgId,
    String? status,
  }) async {
    var baseUrl = getBaseUrl();
    var userId = getUserId();

    var requestUrl = '$baseUrl/update?pgId=$pgId&userId=$userId&status=$status';

    try {
      // Send HTTP GET request
      final response = await dio.put(requestUrl);

      if (response.statusCode == 200) {
      } else {
        print('Failed to patchCancelBookedpg: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to patchCancelBookedpg: $e');
    }
  }
}
