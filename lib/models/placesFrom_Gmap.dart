class placesFrom_Gmap {
  List<GeocodedWaypoints>? geocodedWaypoints;
  List<Routes>? routes;
  String? status;

  placesFrom_Gmap({this.geocodedWaypoints, this.routes, this.status});

  placesFrom_Gmap.fromJson(Map<String, dynamic> json) {
    if (json['geocoded_waypoints'] != null) {
      geocodedWaypoints = <GeocodedWaypoints>[];
      json['geocoded_waypoints'].forEach((v) {
        geocodedWaypoints!.add(new GeocodedWaypoints.fromJson(v));
      });
    }
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(new Routes.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geocodedWaypoints != null) {
      data['geocoded_waypoints'] =
          geocodedWaypoints!.map((v) => v.toJson()).toList();
    }
    if (routes != null) {
      data['routes'] = routes!.map((v) => v.toJson()).toList();
    }
    if (status != null) {
      data['status'] = status;
    }
    return data;
  }
}

class GeocodedWaypoints {
  String? geocoderStatus;
  String? placeId;
  List<String>? types;

  GeocodedWaypoints({this.geocoderStatus, this.placeId, this.types});

  GeocodedWaypoints.fromJson(Map<String, dynamic> json) {
    geocoderStatus = json['geocoder_status'];
    placeId = json['place_id'];
    types = List<String>.from(json['types'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geocoderStatus != null) data['geocoder_status'] = geocoderStatus;
    if (placeId != null) data['place_id'] = placeId;
    if (types != null) data['types'] = types;
    return data;
  }
}

class Routes {
  Bounds? bounds;
  String? copyrights;
  List<Legs>? legs;
  Polyline? overviewPolyline;
  String? summary;
  List<Null>? warnings;
  List<Null>? waypointOrder;

  Routes(
      {this.bounds,
      this.copyrights,
      this.legs,
      this.overviewPolyline,
      this.summary,
      this.warnings,
      this.waypointOrder});

  Routes.fromJson(Map<String, dynamic> json) {
    bounds =
        json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null;
    copyrights = json['copyrights'];
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(Legs.fromJson(v));
      });
    }
    overviewPolyline = json['overview_polyline'] != null
        ? Polyline.fromJson(json['overview_polyline'])
        : null;
    summary = json['summary'];
    warnings = json['warnings'] != null
        ? <Null>[]
        : null; // Ensure warnings are null or an empty list
    waypointOrder = json['waypoint_order'] != null
        ? <Null>[]
        : null; // Ensure waypointOrder is null or an empty list
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bounds != null) data['bounds'] = bounds!.toJson();
    if (copyrights != null) data['copyrights'] = copyrights;
    if (legs != null) data['legs'] = legs!.map((v) => v.toJson()).toList();
    if (overviewPolyline != null)
      data['overview_polyline'] = overviewPolyline!.toJson();
    if (summary != null) data['summary'] = summary;
    if (warnings != null) data['warnings'] = warnings;
    if (waypointOrder != null) data['waypoint_order'] = waypointOrder;
    return data;
  }
}

class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({this.northeast, this.southwest});

  Bounds.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? Northeast.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? Northeast.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (northeast != null) data['northeast'] = northeast!.toJson();
    if (southwest != null) data['southwest'] = southwest!.toJson();
    return data;
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;
    return data;
  }
}

class Legs {
  Distance? distance;
  Distance? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  List<Steps>? steps;
  List<Null>? trafficSpeedEntry;
  List<Null>? viaWaypoint;

  Legs(
      {this.distance,
      this.duration,
      this.endAddress,
      this.endLocation,
      this.startAddress,
      this.startLocation,
      this.steps,
      this.trafficSpeedEntry,
      this.viaWaypoint});

  Legs.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null ? Distance.fromJson(json['distance']) : null;
    duration = json['duration'] != null ? Distance.fromJson(json['duration']) : null;
    endAddress = json['end_address'];
    endLocation = json['end_location'] != null
        ? Northeast.fromJson(json['end_location'])
        : null;
    startAddress = json['start_address'];
    startLocation = json['start_location'] != null
        ? Northeast.fromJson(json['start_location'])
        : null;
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
    trafficSpeedEntry = json['traffic_speed_entry'] != null
        ? <Null>[]
        : null;
    viaWaypoint = json['via_waypoint'] != null ? <Null>[] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) data['distance'] = distance!.toJson();
    if (duration != null) data['duration'] = duration!.toJson();
    if (endAddress != null) data['end_address'] = endAddress;
    if (endLocation != null) data['end_location'] = endLocation!.toJson();
    if (startAddress != null) data['start_address'] = startAddress;
    if (startLocation != null) data['start_location'] = startLocation!.toJson();
    if (steps != null) data['steps'] = steps!.map((v) => v.toJson()).toList();
    if (trafficSpeedEntry != null)
      data['traffic_speed_entry'] = trafficSpeedEntry;
    if (viaWaypoint != null) data['via_waypoint'] = viaWaypoint;
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (text != null) data['text'] = text;
    if (value != null) data['value'] = value;
    return data;
  }
}

class Steps {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  Polyline? polyline;
  Northeast? startLocation;
  String? travelMode;
  String? maneuver;

  Steps(
      {this.distance,
      this.duration,
      this.endLocation,
      this.htmlInstructions,
      this.polyline,
      this.startLocation,
      this.travelMode,
      this.maneuver});

  Steps.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null ? Distance.fromJson(json['distance']) : null;
    duration = json['duration'] != null ? Distance.fromJson(json['duration']) : null;
    endLocation = json['end_location'] != null
        ? Northeast.fromJson(json['end_location'])
        : null;
    htmlInstructions = json['html_instructions'];
    polyline = json['polyline'] != null
        ? Polyline.fromJson(json['polyline'])
        : null;
    startLocation = json['start_location'] != null
        ? Northeast.fromJson(json['start_location'])
        : null;
    travelMode = json['travel_mode'];
    maneuver = json['maneuver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) data['distance'] = distance!.toJson();
    if (duration != null) data['duration'] = duration!.toJson();
    if (endLocation != null) data['end_location'] = endLocation!.toJson();
    if (htmlInstructions != null) data['html_instructions'] = htmlInstructions;
    if (polyline != null) data['polyline'] = polyline!.toJson();
    if (startLocation != null) data['start_location'] = startLocation!.toJson();
    if (travelMode != null) data['travel_mode'] = travelMode;
    if (maneuver != null) data['maneuver'] = maneuver;
    return data;
  }
}

class Polyline {
  String? points;

  Polyline({this.points});

  Polyline.fromJson(Map<String, dynamic> json) {
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (points != null) data['points'] = points;
    return data;
  }
}
