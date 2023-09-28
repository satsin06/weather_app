// To parse this JSON data, do
//
//     final weather = weatherFromJson(jsonString);

import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
    final int? queryCost;
    final double? latitude;
    final double? longitude;
    final String? resolvedAddress;
    final String? address;
    final String? timezone;
    final double? tzoffset;
    final String? description;
    final List<CurrentConditions>? days;
    final List<dynamic>? alerts;
    final CurrentConditions? currentConditions;

    Weather({
        this.queryCost,
        this.latitude,
        this.longitude,
        this.resolvedAddress,
        this.address,
        this.timezone,
        this.tzoffset,
        this.description,
        this.days,
        this.alerts,
        this.currentConditions,
    });

    factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        queryCost: json["queryCost"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        resolvedAddress: json["resolvedAddress"],
        address: json["address"],
        timezone: json["timezone"],
        tzoffset: json["tzoffset"]?.toDouble(),
        description: json["description"],
        days: json["days"] == null ? [] : List<CurrentConditions>.from(json["days"]!.map((x) => CurrentConditions.fromJson(x))),
        alerts: json["alerts"] == null ? [] : List<dynamic>.from(json["alerts"]!.map((x) => x)),
        currentConditions: json["currentConditions"] == null ? null : CurrentConditions.fromJson(json["currentConditions"]),
    );

    Map<String, dynamic> toJson() => {
        "queryCost": queryCost,
        "latitude": latitude,
        "longitude": longitude,
        "resolvedAddress": resolvedAddress,
        "address": address,
        "timezone": timezone,
        "tzoffset": tzoffset,
        "description": description,
        "days": days == null ? [] : List<dynamic>.from(days!.map((x) => x.toJson())),
        "alerts": alerts == null ? [] : List<dynamic>.from(alerts!.map((x) => x)),
        "currentConditions": currentConditions?.toJson(),
    };
}

class CurrentConditions {
    final String? datetime;
    final int? datetimeEpoch;
    final double? temp;
    final double? feelslike;
    final double? humidity;
    final double? dew;
    final double? precip;
    final double? precipprob;
    final List<WeatherIcon>? preciptype;
    final double? windgust;
    final double? windspeed;
    final double? winddir;
    final double? pressure;
    final double? visibility;
    final double? cloudcover;
    final double? solarradiation;
    final double? solarenergy;
    final double? uvindex;
    final double? severerisk;
    final Conditions? conditions;
    final WeatherIcon? icon;
    final Source? source;
    final String? sunrise;
    final int? sunriseEpoch;
    final String? sunset;
    final int? sunsetEpoch;
    final double? moonphase;
    final double? tempmax;
    final double? tempmin;
    final double? feelslikemax;
    final double? feelslikemin;
    final double? precipcover;
    final String? description;
    final List<CurrentConditions>? hours;

    CurrentConditions({
        this.datetime,
        this.datetimeEpoch,
        this.temp,
        this.feelslike,
        this.humidity,
        this.dew,
        this.precip,
        this.precipprob,
        this.preciptype,
        this.windgust,
        this.windspeed,
        this.winddir,
        this.pressure,
        this.visibility,
        this.cloudcover,
        this.solarradiation,
        this.solarenergy,
        this.uvindex,
        this.severerisk,
        this.conditions,
        this.icon,
        this.source,
        this.sunrise,
        this.sunriseEpoch,
        this.sunset,
        this.sunsetEpoch,
        this.moonphase,
        this.tempmax,
        this.tempmin,
        this.feelslikemax,
        this.feelslikemin,
        this.precipcover,
        this.description,
        this.hours,
    });

    factory CurrentConditions.fromJson(Map<String, dynamic> json) => CurrentConditions(
        datetime: json["datetime"],
        datetimeEpoch: json["datetimeEpoch"],
        temp: json["temp"]?.toDouble(),
        feelslike: json["feelslike"]?.toDouble(),
        humidity: json["humidity"]?.toDouble(),
        dew: json["dew"]?.toDouble(),
        precip: json["precip"]?.toDouble(),
        precipprob: json["precipprob"]?.toDouble(),
        preciptype: json["preciptype"] == null ? [] : List<WeatherIcon>.from(json["preciptype"]!.map((x) => iconValues.map[x]!)),
        windgust: json["windgust"]?.toDouble(),
        windspeed: json["windspeed"]?.toDouble(),
        winddir: json["winddir"]?.toDouble(),
        pressure: json["pressure"]?.toDouble(),
        visibility: json["visibility"]?.toDouble(),
        cloudcover: json["cloudcover"]?.toDouble(),
        solarradiation: json["solarradiation"]?.toDouble(),
        solarenergy: json["solarenergy"]?.toDouble(),
        uvindex: json["uvindex"],
        severerisk: json["severerisk"],
        conditions: conditionsValues.map[json["conditions"]]!,
        icon: iconValues.map[json["icon"]]!,
        source: sourceValues.map[json["source"]]!,
        sunrise: json["sunrise"],
        sunriseEpoch: json["sunriseEpoch"],
        sunset: json["sunset"],
        sunsetEpoch: json["sunsetEpoch"],
        moonphase: json["moonphase"]?.toDouble(),
        tempmax: json["tempmax"]?.toDouble(),
        tempmin: json["tempmin"]?.toDouble(),
        feelslikemax: json["feelslikemax"]?.toDouble(),
        feelslikemin: json["feelslikemin"]?.toDouble(),
        precipcover: json["precipcover"]?.toDouble(),
        description: json["description"],
        hours: json["hours"] == null ? [] : List<CurrentConditions>.from(json["hours"]!.map((x) => CurrentConditions.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "datetime": datetime,
        "datetimeEpoch": datetimeEpoch,
        "temp": temp,
        "feelslike": feelslike,
        "humidity": humidity,
        "dew": dew,
        "precip": precip,
        "precipprob": precipprob,
        "preciptype": preciptype == null ? [] : List<dynamic>.from(preciptype!.map((x) => iconValues.reverse[x])),
        "windgust": windgust,
        "windspeed": windspeed,
        "winddir": winddir,
        "pressure": pressure,
        "visibility": visibility,
        "cloudcover": cloudcover,
        "solarradiation": solarradiation,
        "solarenergy": solarenergy,
        "uvindex": uvindex,
        "severerisk": severerisk,
        "conditions": conditionsValues.reverse[conditions],
        "icon": iconValues.reverse[icon],
        "source": sourceValues.reverse[source],
        "sunrise": sunrise,
        "sunriseEpoch": sunriseEpoch,
        "sunset": sunset,
        "sunsetEpoch": sunsetEpoch,
        "moonphase": moonphase,
        "tempmax": tempmax,
        "tempmin": tempmin,
        "feelslikemax": feelslikemax,
        "feelslikemin": feelslikemin,
        "precipcover": precipcover,
        "description": description,
        "hours": hours == null ? [] : List<dynamic>.from(hours!.map((x) => x.toJson())),
    };
}

enum Conditions {
    CLEAR,
    OVERCAST,
    PARTIALLY_CLOUDY,
    RAIN,
    RAIN_OVERCAST,
    RAIN_PARTIALLY_CLOUDY
}

final conditionsValues = EnumValues({
    "Clear": Conditions.CLEAR,
    "Overcast": Conditions.OVERCAST,
    "Partially cloudy": Conditions.PARTIALLY_CLOUDY,
    "Rain": Conditions.RAIN,
    "Rain, Overcast": Conditions.RAIN_OVERCAST,
    "Rain, Partially cloudy": Conditions.RAIN_PARTIALLY_CLOUDY
});

enum WeatherIcon {
    CLEAR_DAY,
    CLEAR_NIGHT,
    CLOUDY,
    PARTLY_CLOUDY_DAY,
    PARTLY_CLOUDY_NIGHT,
    RAIN
}

final iconValues = EnumValues({
    "clear-day": WeatherIcon.CLEAR_DAY,
    "clear-night": WeatherIcon.CLEAR_NIGHT,
    "cloudy": WeatherIcon.CLOUDY,
    "partly-cloudy-day": WeatherIcon.PARTLY_CLOUDY_DAY,
    "partly-cloudy-night": WeatherIcon.PARTLY_CLOUDY_NIGHT,
    "rain": WeatherIcon.RAIN
});

enum Source {
    COMB,
    FCST,
    OBS
}

final sourceValues = EnumValues({
    "comb": Source.COMB,
    "fcst": Source.FCST,
    "obs": Source.OBS
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
