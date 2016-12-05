<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
    <head>
<script>
<sql:query var="trips" dataSource="jdbc/divvy">
    SELECT divvy_trips.trip_id, divvy_trips.to_station_id, divvy_trips.from_station_id, divvy_trips.to_station_name, divvy_trips.from_station_name
    FROM divvy.divvy_trips
    WHERE bikeid = ? <sql:param value="${param.bikeid}"></sql:param>
    LIMIT 5;
</sql:query>

</script>

    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Waypoints in directions</title>
<style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 100%;
        float: left;
        width: 70%;
        height: 100%;
      }
#right-panel {
  font-family: 'Roboto','sans-serif';
  line-height: 30px;
  padding-left: 10px;
}

#right-panel select, #right-panel input {
  font-size: 15px;
}

#right-panel select {
  width: 100%;
}

#right-panel i {
  font-size: 12px;
}

      #right-panel {
        margin: 20px;
        border-width: 2px;
        width: 20%;
        float: left;
        text-align: left;
        padding-top: 20px;
      }
      #directions-panel {
        margin-top: 20px;
        background-color: #FFEE77;
        padding: 10px;
      }
</style>
  </head>
  <body>
    <div id="map"></div>
    <div id="right-panel">
    <div>
    <b>Start: </b>
    <!-- -->
    <select id="start">
        <c:forEach var="stations" items="${trips.rows}">
            <sql:query var="stationsQuery" dataSource="jdbc/divvy">
                SELECT divvy_stations.id, divvy_stations.name,
                divvy_stations.latitude, divvy_stations.longitude
                FROM divvy.divvy_stations
                WHERE divvy.divvy_stations.id = ${stations.from_station_id}
            </sql:query>
            <c:set var="fromstation" value="${stationsQuery.rows[0]}"/>
            <option value="${fromstation.name},Chicago">${fromstation.name}</option>
                
        </c:forEach>
            
    </select>
    
    <b>Waypoints:</b> <br>
    <i>(Ctrl-Click for multiple selection)</i> <br>
    <select multiple id="waypoints">
        <c:forEach var="waystations" items="${trips.rows}">
            <sql:query var="stationsQuery" dataSource="jdbc/divvy">
                SELECT divvy_stations.id, divvy_stations.name,
                divvy_stations.latitude, divvy_stations.longitude
                FROM divvy.divvy_stations
                WHERE divvy.divvy_stations.id = ${waystations.to_station_id}
            </sql:query>
            <c:set var="waystation" value="${stationsQuery.rows[0]}"/>
            <option selected="selected" value="${waystation.name},Chicago">${waystation.name}</option>
        </c:forEach>
            
    </select>
    
    
    <b>End:</b><br>
    <select id="end">
        <c:forEach var="stations" items="${trips.rows}">
            <sql:query var="stationsQuery" dataSource="jdbc/divvy">
                SELECT divvy_stations.id, divvy_stations.name,
                divvy_stations.latitude, divvy_stations.longitude
                FROM divvy.divvy_stations
                WHERE divvy.divvy_stations.id = ${stations.to_station_id}
            </sql:query>
            <c:set var="tostation" value="${stationsQuery.rows[0]}"/>
            <option value="${tostation.name},Chicago">${tostation.name}</option>
                
        </c:forEach>
            
    </select>
  
      <input type="submit" id="submit">
    </div>
<div id="directions-panel"></div>
  </div>    
<script>
function initMap() {
  var markerArray = [];

  // Instantiate a directions service.
  var directionsService = new google.maps.DirectionsService;
  var directionsDisplay = new google.maps.DirectionsRenderer;
  // Create a map and center it on Chicago.

  var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 12,
        center: {lat: 41.87395806, lng: -87.62773949}
  });

  directionsDisplay.setMap(map);


  document.getElementById('submit').addEventListener('click', function() {
    calculateAndDisplayRoute(directionsService, directionsDisplay);
  });
}

function B3calculateAndDisplayRouteb3(directionsDisplay, directionsService,
    markerArray, stepDisplay, map) {
  // First, remove any existing markers from the map.
  for (var i = 0; i < markerArray.length; i++) {
    markerArray[i].setMap(null);
  }

  // Retrieve the start and end locations and create a DirectionsRequest using
  // WALKING directions.
  directionsService.route({
    origin: document.getElementById('start').value,
    destination: document.getElementById('end').value,
    travelMode: google.maps.TravelMode.WALKING
  }, function(response, status) {
    // Route the directions and pass the response to a function to create
    // markers for each step.
    if (status === google.maps.DirectionsStatus.OK) {
      document.getElementById('warnings-panel').innerHTML =
          '<b>' + response.routes[0].warnings + '</b>';
      directionsDisplay.setDirections(response);
      showSteps(response, markerArray, stepDisplay, map);
    } else {
      window.alert('Directions request failed due to ' + status);
    }
  });
}

function showSteps(directionResult, markerArray, stepDisplay, map) {
  // For each step, place a marker, and add the text to the marker's infowindow.
  // Also attach the marker to an array so we can keep track of it and remove it
  // when calculating new routes.
  var myRoute = directionResult.routes[0].legs[0];
  for (var i = 0; i < myRoute.steps.length; i++) {
      if(i == 0 || i == myRoute.steps.length) {
            var marker = markerArray[i] = markerArray[i] || new google.maps.Marker;
            marker.setMap(map);
            marker.setPosition(myRoute.steps[i].start_location);
            attachInstructionText(
                stepDisplay, marker, myRoute.steps[i].instructions, map);
          }
      }
}

function attachInstructionText(stepDisplay, marker, text, map) {
  google.maps.event.addListener(marker, 'click', function() {
    // Open an info window when the marker is clicked on, containing the text
    // of the step.
    stepDisplay.setContent(text);
    stepDisplay.open(map, marker);
  });
}

function calculateAndDisplayRoute(directionsService, directionsDisplay) {
  var waypts = [];
  var checkboxArray = document.getElementById('waypoints');
  for (var i = 0; i < checkboxArray.length; i++) {
    if (checkboxArray.options[i].selected) {
      waypts.push({
        location: checkboxArray[i].value,
        stopover: true
      });
    }
  }

  directionsService.route({
    origin: document.getElementById('start').value,
    destination: document.getElementById('end').value,
    waypoints: waypts,
    optimizeWaypoints: true,
    travelMode: google.maps.TravelMode.BICYCLING
  }, function(response, status) {
    if (status === google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
      var route = response.routes[0];
      var summaryPanel = document.getElementById('directions-panel');
      summaryPanel.innerHTML = '';
      // For each route, display summary information.
      for (var i = 0; i < route.legs.length; i++) {
        var routeSegment = i + 1;
        summaryPanel.innerHTML += '<b>Route Segment: ' + routeSegment +
            '</b><br>';
        summaryPanel.innerHTML += route.legs[i].start_address + ' to ';
        summaryPanel.innerHTML += route.legs[i].end_address + '<br>';
        summaryPanel.innerHTML += route.legs[i].distance.text + '<br><br>';
      }
    } else {
      window.alert('Directions request failed due to ' + status);
    }
  });
}

    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=@@GOOGLE_MAP_API_KEY&signed_in=true&callback=initMap"
        async defer></script>
  </body>
</html>