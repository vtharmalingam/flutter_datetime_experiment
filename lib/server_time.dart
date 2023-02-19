import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Map timezoneNames2 = {
  0: 'UTC',
  10800000: 'Indian/Mayotte',
  3600000: 'Europe/London',
  7200000: 'Europe/Zurich',
  -32400000: 'Pacific/Gambier',
  -28800000: 'US/Alaska',
  -14400000: 'US/Eastern',
  -10800000: 'Canada/Atlantic',
  -18000000: 'US/Central',
  -21600000: 'US/Mountain',
  -25200000: 'US/Pacific',
  -7200000: 'Atlantic/South_Georgia',
  -9000000: 'Canada/Newfoundland',
  39600000: 'Pacific/Pohnpei',
  25200000: 'Indian/Christmas',
  36000000: 'Pacific/Saipan',
  18000000: 'Indian/Maldives',
  46800000: 'Pacific/Tongatapu',
  21600000: 'Indian/Chagos',
  43200000: 'Pacific/Wallis',
  14400000: 'Indian/Reunion',
  28800000: 'Australia/Perth',
  32400000: 'Pacific/Palau',
  19800000: 'Asia/Kolkata',
  16200000: 'Asia/Kabul',
  20700000: 'Asia/Kathmandu',
  23400000: 'Indian/Cocos',
  12600000: 'Asia/Tehran',
  -3600000: 'Atlantic/Cape_Verde',
  37800000: 'Australia/Broken_Hill',
  34200000: 'Australia/Darwin',
  31500000: 'Australia/Eucla',
  49500000: 'Pacific/Chatham',
  -36000000: 'US/Hawaii',
  50400000: 'Pacific/Kiritimati',
  -34200000: 'Pacific/Marquesas',
  -39600000: 'Pacific/Pago_Pago'
};



//Time
Map<int, String> timeZoneNames = {
  -240: 'America/Puerto_Rico',
  -180: 'America/Punta_Arenas',
  -120: 'Atlantic/South_Georgia',
  -60: 'Atlantic/Cape_Verde',
  0: 'Africa/Abidjan',
  60: 'Africa/Algiers',
  120: 'Africa/Blantyre',
  180: 'Africa/Asmara',
  240: 'Asia/Baku'
};

//This class helps to MAP local time (device time) to Server time
//That is required for cases like setting expiration time for pending orders
class ServerDateTime {
  late tz.TZDateTime dt;
  late String dt_str;
  int offset = 0;
  late Duration duration;

  String? timeZoneName = timeZoneNames[60];
  late tz.Location serverTimeZone;


  /**

    The constructor takes a parameter 'shouldAdjustTime'
        - true : (default) it prepares the object to alter the input time value (time value gets changed!)
        - false: prepares the object such that the given time value is not changed

      But in both true | false cases, the timezone get changed.

      Note:
      There is no interface to change the timezoneName.

   */

  ServerDateTime({bool shouldAdjustTime = true}) {
    tz.initializeTimeZones();

    serverTimeZone = tz.getLocation(timeZoneName!);
    DateTime d = DateTime.now();

    //Maps the current local time to Server time
    dt = tz.TZDateTime.from(d, serverTimeZone);

    //If you want to RETAIN the local time as is, but set a different timezone)
    if (!shouldAdjustTime) {
      //This offset is wrt UTC
      int gmt_offset = dt.timeZone.offset;

      //Local to Server MS difference
      offset =  DateTime.now().timeZoneOffset.inMilliseconds - gmt_offset;
    }
  }

  //Input comes in local DateTime!
  ServerDateTime toServerDateTime(DateTime ip_dt) {
    serverTimeZone = tz.getLocation(timeZoneName!);

    //This adjusts for server offset
    tz.TZDateTime newDateTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(serverTimeZone, ip_dt.millisecondsSinceEpoch +
        offset);

    dt = tz.TZDateTime.from(newDateTime, serverTimeZone);
    dt_str = dt.toString();

    return this;
  }

  tz.TZDateTime toTZDateTime (String ip_dt) {
    serverTimeZone = tz.getLocation(timeZoneName!);
    return tz.TZDateTime.parse(serverTimeZone, ip_dt);
  }

  //Input comes in local DateTime!
  // ServerDateTime toServerDateTime2 (String ip_dt) {
  //
  //   serverTimeZone = tz.getLocation(timeZoneName!);
  //   dt = tz.TZDateTime.parse(serverTimeZone, ip_dt);
  //   dt_str = dt.toString();
  //
  //   return this;
  // }

}