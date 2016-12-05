<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%-- 
    Document   : displayStationOnGoogleMap
    Created on : Nov 27, 2015, 12:18:49 PM
    Author     : tlin
--%>
<sql:query var="stations" dataSource="jdbc/divvy">
    SELECT name, id, latitude, longitude, dpcapacity FROM divvy.divvy_stations
    WHERE id = ? <sql:param value="${param.station}"/>
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
          <!-- var myLatLng = {lat: -25.363, lng: 131.044};    -->
          <!-- var myLatLng = {lat: 41.87395806, lng: -87.62773949}; -->


          var myLatLng = {lat: ${stationlat}, lng: ${stationlong}};


          var map = new google.maps.Map(document.getElementById('map'), {
            zoom: 15,
            center: myLatLng
          });

          var marker = new google.maps.Marker({
            position: myLatLng,
            map: map,
            title: '${stationname}'
          });
          
          var infowindow = new google.maps.InfoWindow({
                content: '${stationname}<br># of stations:${stationdpcapacity}'
          });
          
          marker.addListener('click', function(){ infowindow.open(map,marker)
          });
    }

    </script>
    <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=@@GOOGLE_MAP_API_KEY&signed_in=true&callback=initMap">
    </script>
  </body>
</html>
