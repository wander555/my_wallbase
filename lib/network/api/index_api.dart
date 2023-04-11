import '../http/base_api.dart';
import '../service/custom_service.dart';

class IndexApi extends BaseApi {
  @override
  String path() {
    return "/search";
  }

  @override
  RequestMethod method() {
    return RequestMethod.get;
  }

  @override
  String serviceKey() {
    return customServiceKey;
  }
}
