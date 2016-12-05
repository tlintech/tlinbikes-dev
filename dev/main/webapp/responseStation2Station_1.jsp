<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%--
    Document   : response
    Created on : Dec 22, 2009, 8:52:57 PM
    Author     : nbuser
--%>

<sql:query var="tripsQuery" dataSource="jdbc/divvy">
    SELECT trip_id, bikeid, starttime, stoptime, tripduration FROM divvy_trips 
    WHERE from_station_id = ? <sql:param value="${param.from_station_id}"/>  
    AND to_station_id = ? <sql:param value="${param.to_station_id}"/>
    ORDER BY starttime asc
</sql:query>

<c:set var="firstTrip" value="${tripsQuery.rows[0]}"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>


    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="style.css">
        <title>Trips from Station to Station</title>
    </head>

    <body>

    <table>
        <tr>
        <td>TRIP ID</td><td>BIKE ID</td><td>START TIME</td><td>STOP TIME</td>
        </tr>
        <c:forEach var="trip" items="${tripsQuery.rows}">
            <tr>
                <td>${trip.trip_id}</td><td>${trip.bikeid}</td> <td>${trip.starttime}</td> <td>${trip.stoptime}</td>
            </tr>
        </c:forEach>
    </table>

    </body>
</html>