<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%-- 
    Document   : displayStationOnGoogleMap
    Created on : Nov 27, 2015, 12:18:49 PM
    Author     : tlin
    Notes   : This is a testing comments for notes field.
--%>
<sql:query var="trips" dataSource="jdbc/divvy">
    SELECT divvy_trips.trip_id, divvy_trips.to_station_id, divvy_trips.to_station_name,
    divvy_trips.from_station_id, divvy_trips.from_station_name
    FROM divvy.divvy_trips
    WHERE bikeid = ? <sql:param value="${param.bikeid}"></sql:param>
  
</sql:query>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<!-- lat = ${stationlat} -->
<!-- long = ${stationlong} -->

    <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Bike Display Map</title>
    <style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 100%;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <script>
        
  

    function initMap() {
        <!-- var myLatLng = {lat: -25.363, lng: 131.044};    -->
        <!-- var myLatLng = {lat: 41.856268, lng: 41.856268}; -->

        var locations = [];
        <c:forEach var="trip" items="${trips.rows}">
            <sql:query var="locationQuery" dataSource="jdbc/divvy">
                SELECT divvy_stations.id, divvy_stations.name,
                divvy_stations.latitude, divvy_stations.longitude
                FROM divvy.divvy_stations
                WHERE divvy.divvy_stations.id = ${trip.to_station_id}
            </sql:query>
            <c:set var="station" value="${locationQuery.rows[0]}"/>
            <c:set var="stationname" value="${station.name}"/>
            <c:set var="stationlat"  value="${station.latitude}"/>
            <c:set var="stationlong" value="${station.longitude}"/>
            <c:set var="stationid"   value="${station.id}"/>
            <!-- ${trip.to_station_id} -->
            <!-- ${location} -->
            locations.push(["${stationname}",
            "${stationlat}",
            "${stationlong}",
            "${stationid}"]);
        </c:forEach> 

        var myLatLng = {lat: ${stationlat}, lng: ${stationlong}};

        var map = new google.maps.Map(document.getElementById('map'), {
            zoom: 13,
            center: myLatLng
        });

        var marker;
        var markers = [];
        var i;
        var xxdebug=0;
        var infowindow = new google.maps.InfoWindow();
        for (i = 0; i < locations.length; i++) {  
                marker = new google.maps.Marker({
                            position: new google.maps.LatLng(locations[i][1], locations[i][2]),
                            map: map,
                            label: i.toString(),
                            title: '${locations[i][0]}'
                        });
                markers.push(marker);
        };
       
    }

    </script>
    <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=@@GOOGLE_MAP_API_KEY&signed_in=true&callback=initMap">
    </script>
  </body>
</html>
