<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@page import="java.util.*" %>
<%-- 
    Document   : displayStationOnGoogleMap
    Created on : Nov 27, 2015, 12:18:49 PM
    Author     : tlin
Google Key = AIzaSyAE9xrYlCRr9Pg2nfA8NhugSpBL3nqRuCY
--%>
<sql:query var="stations" dataSource="jdbc/divvy">
    SELECT name, latitude, longitude, id FROM divvy.divvy_stations
</sql:query>
    



<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html> 
<head> 
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" /> 
  <title>Google Maps Multiple Markers</title> 
  <script src="http://maps.google.com/maps/api/js?sensor=false" 
          type="text/javascript"></script>
</head> 
<body>

<div id="map" style="width: 1000px; height: 1000px;"></div>
<script type="text/javascript">

    function initMap() {
        var locations = [];
            <c:forEach var="location" items="${stations.rows}">
                locations.push(["${location.name}",
                                "${location.latitude}",
                                "${location.longitude}",
                                "${location.id}"]);
            </c:forEach> 

        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 15,
          center: new google.maps.LatLng(41.87395806,-87.62773949),
          mapTypeId: google.maps.MapTypeId.ROADMAP
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
            src="https://maps.googleapis.com/maps/api/js?key=GOOGLE_MAP_API_KEY&signed_in=true&callback=initMap">
  </script>
</body>
</html>
