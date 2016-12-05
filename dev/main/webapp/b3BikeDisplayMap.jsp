<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>

<html>
<script>
<sql:query var="trips" dataSource="jdbc/divvy">
    SELECT divvy_trips.trip_id, divvy_trips.to_station_id, divvy_trips.from_station_id, divvy_trips.to_station_name, divvy_trips.from_station_name
    FROM divvy.divvy_trips
    WHERE bikeid = ? <sql:param value="${param.bikeid}"></sql:param>
    LIMIT 9;
</sql:query>;

</script>

  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Directions service (complex)</title>
    <style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 100%;
      }
      #warnings-panel {
        width: 100%;
        height:10%;
        text-align: center;
      }
#floating-panel {
  position: absolute;
  top: 10px;
  left: 25%;
  z-index: 5;
  background-color: #fff;
  padding: 5px;
  border: 1px solid #999;
  text-align: center;
  font-family: 'Roboto','sans-serif';
  line-height: 30px;
  padding-left: 10px;
}

    </style>
  </head>
  <body>
    <div id="floating-panel">
    <b>Start: </b>
    
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
    <b>End:</b>
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
    </div>
    <div id="map"></div>
    &nbsp;
    <div id="warnings-panel"></div>
<script>
function initMap() {
  var markerArray = [];

  // Instantiate a directions service.
  var directionsService = new google.maps.DirectionsService;

  // Create a map and center it on Chicago.
  var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 12,
        center: {lat: 41.87395806, lng: -87.62773949}
  });




  // Create a renderer for directions and bind it to the map.
  var directionsDisplay = new google.maps.DirectionsRenderer({map: map});

  // Instantiate an info window to hold step text.
  var stepDisplay = new google.maps.InfoWindow;

  // Display the route between the initial start and end selections.
  calculateAndDisplayRoute(
      directionsDisplay, directionsService, markerArray, stepDisplay, map);
  // Listen to change events from the start and end lists.
  var onChangeHandler = function() {
    calculateAndDisplayRoute(
        directionsDisplay, directionsService, markerArray, stepDisplay, map);
  };
  document.getElementById('start').addEventListener('change', onChangeHandler);
  document.getElementById('end').addEventListener('change', onChangeHandler);
}

function calculateAndDisplayRoute(directionsDisplay, directionsService,
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
    travelMode: google.maps.TravelMode.BICYCLING
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



    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=@@GOOGLE_MAP_API_KEY&signed_in=true&callback=initMap"
        async defer></script>
  </body>
</html>