import 'package:dotenv/dotenv.dart' show env;
import 'package:ews/Core/ExchangeService.dart';
import 'package:ews/Enumerations/ExchangeVersion.dart';
import 'package:ews/Enumerations/TraceFlags.dart';
import 'package:ews/Http/WebCredentials.dart';

WebCredentials primaryUserCredential = WebCredentials(env["USER_NAME"], env["USER_PASSWORD"], null);
WebCredentials secondaryUserCredential =
    WebCredentials(env["USER_NAME_SECONDARY"], env["USER_PASSWORD_SECONDARY"], null);
WebCredentials wrongUserCredential = WebCredentials("user", "password", null);

ExchangeService prepareExchangeService(WebCredentials credentials,
    [requestedExchangeVersion = ExchangeVersion.Exchange2007_SP1]) {
  return ExchangeService.withVersion(requestedExchangeVersion)
    ..Url = Uri.parse("https://outlook.office365.com/ews/exchange.asmx")
    ..Credentials = credentials
    ..TraceFlags = [TraceFlags.EwsRequest, TraceFlags.EwsResponse]
    ..TraceEnabled = true;
}
