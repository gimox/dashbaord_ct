import 'package:isar_community/isar.dart';

part 'merge_webex_user.g.dart';

@collection
class MergeWebexUser {
  Id id = Isar.autoIncrement;

  @Index()
  String? meetingNumber;

  String? meetingName;

  @Index()
  String? conferenceId;

  @Index()
  String? userName;

  @Index()
  String? email;

  String? location;

  DateTime? joinDate;

  DateTime? startTime;

  DateTime? endTime;

  int? duration;

  String? os;

  String? browser;

  String? localIp;

  String? publicIp;

  double? joinMeetingTime;

  double? voipReceivingAvgPacketLoss;

  double? voipAvgLatency;

  double? tcpPercentage;

  double? udpPercentage;

  bool? isCmr;

  bool? isSharing;

  bool? isRecord;

  double? videoMinutes;

  String? client;

  String? clientVersion;

  String? mediaNode;

  String? connection;

  String? hardware;

  String? camera;

  String? microphone;

  String? speaker;

  double? voipMaxLatency;

  double? voipReceivingMaxPacketLoss;

  double? voipSendingAvgPacketLoss;

  double? voipSendingMaxPacketLoss;

  double? voipReceivingAvgJitter;

  double? voipReceivingMaxJitter;

  double? voipSendingAvgJitter;

  double? voipSendingMaxJitter;

  double? videoAvgLatency;

  double? videoMaxLatency;

  double? videoReceivingAvgPacketLoss;

  double? videoReceivingMaxPacketLoss;

  double? videoSendingAvgPacketLoss;

  double? videoSendingMaxPacketLoss;

  double? videoReceivingAvgJitter;

  double? videoReceivingMaxJitter;

  double? videoSendingAvgJitter;

  double? videoSendingMaxJitter;

  double? cpuAppAvg;

  double? cpuAppMax;

  double? cpuSysAvg;

  double? cpuSysMax;

  bool? virtualBackgroundUsed;

  bool? hostIndicator;

  bool? isCohost;

  String? clientType;

  String? subClientType;

  String? clientBrowserDetails;

  String? videoQuality;

  String? voipQuality;

  String? country;

  String? state;

  String? city;

  @Index()
  int? platformId;

  String? userMatch;

  @Index()
  int? courseId;

  bool? completeCourse;

  DateTime? lastSyncedAt;

  MergeWebexUser();

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str.toUpperCase() == 'NA' || str.toUpperCase() == 'NULL') return null;
    return double.tryParse(str.replaceAll(',', '.'));
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    final str = value.toString().trim();
    if (str.isEmpty || str.toUpperCase() == 'NA' || str.toUpperCase() == 'NULL') return null;
    return int.tryParse(str);
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    final str = value.toString().trim().toUpperCase();
    if (str == 'Y' || str == 'TRUE' || str == '1' || str == 'YES') return true;
    if (str == 'N' || str == 'FALSE' || str == '0' || str == 'NO') return false;
    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str.toUpperCase() == 'NA' || str.toUpperCase() == 'NULL') return null;
    return DateTime.tryParse(str);
  }

  factory MergeWebexUser.fromJson(Map<String, dynamic> json) {
    final item = MergeWebexUser();
    if (json['id'] != null) {
      if (json['id'] is num) {
        item.id = (json['id'] as num).toInt();
      } else {
        item.id = int.tryParse(json['id'].toString()) ?? Isar.autoIncrement;
      }
    }

    item.meetingNumber = json['MEETING_NUMBER']?.toString() ?? json['meeting_number']?.toString();
    item.meetingName = json['MEETING_NAME']?.toString() ?? json['meeting_name']?.toString();
    item.conferenceId = json['CONFERENCE_ID']?.toString() ?? json['conference_id']?.toString();
    item.userName = json['USER_NAME']?.toString() ?? json['user_name']?.toString();
    item.email = json['EMAIL']?.toString() ?? json['email']?.toString();
    item.location = json['LOCATION (DEPRECATED)']?.toString() ?? json['location']?.toString();

    item.joinDate = _parseDate(json['JOIN_DATE'] ?? json['join_date']);
    item.startTime = _parseDate(json['START_TIME'] ?? json['start_time']);
    item.endTime = _parseDate(json['END_TIME'] ?? json['end_time']);

    item.duration = _parseInt(json['DURATION'] ?? json['duration']);
    item.os = json['OS']?.toString() ?? json['os']?.toString();
    item.browser = json['BROWSER']?.toString() ?? json['browser']?.toString();
    item.localIp = json['LOCAL_IP']?.toString() ?? json['local_ip']?.toString();
    item.publicIp = json['PUBLIC_IP']?.toString() ?? json['public_ip']?.toString();

    item.joinMeetingTime = _parseDouble(json['JOIN_MEETING_TIME'] ?? json['join_meeting_time']);
    item.voipReceivingAvgPacketLoss = _parseDouble(json['VOIP_RECEIVING_AVERAGE_PACKET_LOSS'] ?? json['voip_receiving_average_packet_loss']);
    item.voipAvgLatency = _parseDouble(json['VOIP_AVERAGE_LATENCY'] ?? json['voip_average_latency']);
    item.tcpPercentage = _parseDouble(json['TCP_PERCENTAGE'] ?? json['tcp_percentage']);
    item.udpPercentage = _parseDouble(json['UDP_PERCENTAGE'] ?? json['udp_percentage']);

    item.isCmr = _parseBool(json['IS_CMR'] ?? json['is_cmr']);
    item.isSharing = _parseBool(json['IS_SHARING'] ?? json['is_sharing']);
    item.isRecord = _parseBool(json['IS_RECORD'] ?? json['is_record']);

    item.videoMinutes = _parseDouble(json['VIDEO_MINUTES'] ?? json['video_minutes']);
    item.client = json['CLIENT']?.toString() ?? json['client']?.toString();
    item.clientVersion = json['CLIENT_VERSION']?.toString() ?? json['client_version']?.toString();
    item.mediaNode = json['MEDIA_NODE']?.toString() ?? json['media_node']?.toString();
    item.connection = json['CONNECTION']?.toString() ?? json['connection']?.toString();
    item.hardware = json['HARDWARE']?.toString() ?? json['hardware']?.toString();
    item.camera = json['CAMERA']?.toString() ?? json['camera']?.toString();
    item.microphone = json['MICROPHONE']?.toString() ?? json['microphone']?.toString();
    item.speaker = json['SPEAKER']?.toString() ?? json['speaker']?.toString();

    item.voipMaxLatency = _parseDouble(json['VOIP_MAX_LATENCY'] ?? json['voip_max_latency']);
    item.voipReceivingMaxPacketLoss = _parseDouble(json['VOIP_RECEIVING_MAX_PACKET_LOSS'] ?? json['voip_receiving_max_packet_loss']);
    item.voipSendingAvgPacketLoss = _parseDouble(json['VOIP_SENDING_AVERAGE_PACKET_LOSS'] ?? json['voip_sending_average_packet_loss']);
    item.voipSendingMaxPacketLoss = _parseDouble(json['VOIP_SENDING_MAX_PACKET_LOSS'] ?? json['voip_sending_max_packet_loss']);
    item.voipReceivingAvgJitter = _parseDouble(json['VOIP_RECEIVING_AVERAGE_JITTER'] ?? json['voip_receiving_average_jitter']);
    item.voipReceivingMaxJitter = _parseDouble(json['VOIP_RECEIVING_MAX_JITTER'] ?? json['voip_receiving_max_jitter']);
    item.voipSendingAvgJitter = _parseDouble(json['VOIP_SENDING_AVERAGE_JITTER'] ?? json['voip_sending_average_jitter']);
    item.voipSendingMaxJitter = _parseDouble(json['VOIP_SENDING_MAX_JITTER'] ?? json['voip_sending_max_jitter']);

    item.videoAvgLatency = _parseDouble(json['VIDEO_AVERAGE_LATENCY'] ?? json['video_average_latency']);
    item.videoMaxLatency = _parseDouble(json['VIDEO_MAX_LATENCY'] ?? json['video_max_latency']);
    item.videoReceivingAvgPacketLoss = _parseDouble(json['VIDEO_RECEIVING_AVERAGE_PACKET_LOSS'] ?? json['video_receiving_average_packet_loss']);
    item.videoReceivingMaxPacketLoss = _parseDouble(json['VIDEO_RECEIVING_MAX_PACKET_LOSS'] ?? json['video_receiving_max_packet_loss']);
    item.videoSendingAvgPacketLoss = _parseDouble(json['VIDEO_SENDING_AVERAGE_PACKET_LOSS'] ?? json['video_sending_average_packet_loss']);
    item.videoSendingMaxPacketLoss = _parseDouble(json['VIDEO_SENDING_MAX_PACKET_LOSS'] ?? json['video_sending_max_packet_loss']);
    item.videoReceivingAvgJitter = _parseDouble(json['VIDEO_RECEIVING_AVERAGE_JITTER'] ?? json['video_receiving_average_jitter']);
    item.videoReceivingMaxJitter = _parseDouble(json['VIDEO_RECEIVING_MAX_JITTER'] ?? json['video_receiving_max_jitter']);
    item.videoSendingAvgJitter = _parseDouble(json['VIDEO_SENDING_AVERAGE_JITTER'] ?? json['video_sending_average_jitter']);
    item.videoSendingMaxJitter = _parseDouble(json['VIDEO_SENDING_MAX_JITTER'] ?? json['video_sending_max_jitter']);

    item.cpuAppAvg = _parseDouble(json['CPU_APPLICATION_AVERAGE'] ?? json['cpu_application_average']);
    item.cpuAppMax = _parseDouble(json['CPU_APPLICATION_MAX'] ?? json['cpu_application_max']);
    item.cpuSysAvg = _parseDouble(json['CPU_SYSTEM_AVERAGE'] ?? json['cpu_system_average']);
    item.cpuSysMax = _parseDouble(json['CPU_SYSTEM_MAX'] ?? json['cpu_system_max']);

    item.virtualBackgroundUsed = _parseBool(json['VIRTUAL_BACKGROUND_USED'] ?? json['virtual_background_used']);
    item.hostIndicator = _parseBool(json['HOST_INDICATOR'] ?? json['host_indicator']);
    item.isCohost = _parseBool(json['IS_COHOST'] ?? json['is_cohost']);

    item.clientType = json['CLIENT_TYPE']?.toString() ?? json['client_type']?.toString();
    item.subClientType = json['SUB_CLIENT_TYPE']?.toString() ?? json['sub_client_type']?.toString();
    item.clientBrowserDetails = json['CLIENT_BROWSER_DETAILS']?.toString() ?? json['client_browser_details']?.toString();
    item.videoQuality = json['VIDEO_QUALITY']?.toString() ?? json['video_quality']?.toString();
    item.voipQuality = json['VOIP_QUALITY']?.toString() ?? json['voip_quality']?.toString();

    item.country = json['COUNTRY']?.toString() ?? json['country']?.toString();
    item.state = json['STATE']?.toString() ?? json['state']?.toString();
    item.city = json['CITY']?.toString() ?? json['city']?.toString();

    item.platformId = _parseInt(json['platform_id'] ?? json['PLATFORM_ID']);
    item.userMatch = json['user_match']?.toString() ?? json['USER_MATCH']?.toString();
    item.courseId = _parseInt(json['course_id'] ?? json['COURSE_ID']);
    item.completeCourse = _parseBool(json['complete_course'] ?? json['COMPLETE_COURSE']);

    item.lastSyncedAt = DateTime.now();
    return item;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'MEETING_NUMBER': meetingNumber,
      'MEETING_NAME': meetingName,
      'CONFERENCE_ID': conferenceId,
      'USER_NAME': userName,
      'EMAIL': email,
      'LOCATION (DEPRECATED)': location,
      'JOIN_DATE': joinDate?.toIso8601String().split('T').first,
      'START_TIME': startTime?.toIso8601String(),
      'END_TIME': endTime?.toIso8601String(),
      'DURATION': duration,
      'OS': os,
      'BROWSER': browser,
      'LOCAL_IP': localIp,
      'PUBLIC_IP': publicIp,
      'JOIN_MEETING_TIME': joinMeetingTime,
      'VOIP_RECEIVING_AVERAGE_PACKET_LOSS': voipReceivingAvgPacketLoss,
      'VOIP_AVERAGE_LATENCY': voipAvgLatency,
      'TCP_PERCENTAGE': tcpPercentage,
      'UDP_PERCENTAGE': udpPercentage,
      'IS_CMR': isCmr == true ? 'Y' : (isCmr == false ? 'N' : null),
      'IS_SHARING': isSharing == true ? 'Y' : (isSharing == false ? 'N' : null),
      'IS_RECORD': isRecord == true ? 'Y' : (isRecord == false ? 'N' : null),
      'VIDEO_MINUTES': videoMinutes,
      'CLIENT': client,
      'CLIENT_VERSION': clientVersion,
      'MEDIA_NODE': mediaNode,
      'CONNECTION': connection,
      'HARDWARE': hardware,
      'CAMERA': camera,
      'MICROPHONE': microphone,
      'SPEAKER': speaker,
      'VOIP_MAX_LATENCY': voipMaxLatency,
      'VOIP_RECEIVING_MAX_PACKET_LOSS': voipReceivingMaxPacketLoss,
      'VOIP_SENDING_AVERAGE_PACKET_LOSS': voipSendingAvgPacketLoss,
      'VOIP_SENDING_MAX_PACKET_LOSS': voipSendingMaxPacketLoss,
      'VOIP_RECEIVING_AVERAGE_JITTER': voipReceivingAvgJitter,
      'VOIP_RECEIVING_MAX_JITTER': voipReceivingMaxJitter,
      'VOIP_SENDING_AVERAGE_JITTER': voipSendingAvgJitter,
      'VOIP_SENDING_MAX_JITTER': voipSendingMaxJitter,
      'VIDEO_AVERAGE_LATENCY': videoAvgLatency,
      'VIDEO_MAX_LATENCY': videoMaxLatency,
      'VIDEO_RECEIVING_AVERAGE_PACKET_LOSS': videoReceivingAvgPacketLoss,
      'VIDEO_RECEIVING_MAX_PACKET_LOSS': videoReceivingMaxPacketLoss,
      'VIDEO_SENDING_AVERAGE_PACKET_LOSS': videoSendingAvgPacketLoss,
      'VIDEO_SENDING_MAX_PACKET_LOSS': videoSendingMaxPacketLoss,
      'VIDEO_RECEIVING_AVERAGE_JITTER': videoReceivingAvgJitter,
      'VIDEO_RECEIVING_MAX_JITTER': videoReceivingMaxJitter,
      'VIDEO_SENDING_AVERAGE_JITTER': videoSendingAvgJitter,
      'VIDEO_SENDING_MAX_JITTER': videoSendingMaxJitter,
      'CPU_APPLICATION_AVERAGE': cpuAppAvg,
      'CPU_APPLICATION_MAX': cpuAppMax,
      'CPU_SYSTEM_AVERAGE': cpuSysAvg,
      'CPU_SYSTEM_MAX': cpuSysMax,
      'VIRTUAL_BACKGROUND_USED': virtualBackgroundUsed == true ? 'Y' : (virtualBackgroundUsed == false ? 'N' : null),
      'HOST_INDICATOR': hostIndicator == true ? 'Y' : (hostIndicator == false ? 'N' : null),
      'IS_COHOST': isCohost == true ? 'Y' : (isCohost == false ? 'N' : null),
      'CLIENT_TYPE': clientType,
      'SUB_CLIENT_TYPE': subClientType,
      'CLIENT_BROWSER_DETAILS': clientBrowserDetails,
      'VIDEO_QUALITY': videoQuality,
      'VOIP_QUALITY': voipQuality,
      'COUNTRY': country,
      'STATE': state,
      'CITY': city,
      'platform_id': platformId,
      'user_match': userMatch,
      'course_id': courseId,
      'complete_course': completeCourse,
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
    };
  }
}
