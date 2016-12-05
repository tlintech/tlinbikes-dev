<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%-- 
    Document   : displayStationOnGoogleMap
    Created on : Nov 27, 2015, 12:18:49 PM
    Author     : tlin
--%>
<sql:query var="stations" dataSource="jdbc/divvy">
    SELECT name, id, latitude, longitude, dpcapacity FROM divvy.divvy_stations
    WHERE id = ? <sql:param value="${param.from_station_id}"/>  
    OR id = ? <sql:param value="${param.to_station_id}"/>
</sql:query>

<c:set var="stationname" value="${stations.rows[0].name}"/>
<c:set var="stationlat" value="${stations.rows[0].latitude}"/>
<c:set var="stationlong" value="${stations.rows[0].longitude}"/>
<c:set var="stationdpcapacity" value="${stations.rows[0].dpcapacity}"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<!-- lat = ${stationlat} -->
<!-- long = ${stationlong} -->

    <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Simple markers</title>
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
        var locations = [];
            <c:forEach var="location" items="${stations.rows}">
                locations.push(["${location.name}",
                                "${location.latitude}",
                                "${location.longitude}",
                                "${location.id}"]);
            </c:forEach> 

        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 12,
          center: new google.maps.LatLng(41.87395806,-87.62773949),
        });

        var infowindow = new google.maps.BicyclingLayer();
        infowindow.setMap(map);
        var marker, i;

        for (i = 0; i < locations.length; i++) {  
          marker = new google.maps.Marker({
            position: new google.maps.LatLng(locations[i][1], locations[i][2]),
            map: map
          });

          google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
              infowindow.setContent(locations[i][0]);
              infowindow.open(map, marker);
            }
          })(marker, i));
        }
    }
  </script>
  
  <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=@@GOOGLE_MAP_API_KEY&signed_in=true&callback=initMap">
  </script>
</body>
</html>