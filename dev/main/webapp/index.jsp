<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%--
    Document   : index
    Created on : Dec 22, 2009, 7:39:49 PM
    Author     : nbuser
--%>

<sql:query var="stations" dataSource="jdbc/divvy">
    SELECT name, id, latitude, longitude FROM divvy.divvy_stations order by name asc
</sql:query>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="style.css">
        <title>divvy Homepage - building from Jenkins</title>
    </head>
    <body>
        <h1>Welcome to <strong>Divvy</strong>
        </h1>

        <table border="0">
            <thead>
                <tr>
                    <th>Select a Divvy Station</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Stations</td>
                </tr>
                <tr>
                    <td>
                        <form action="./displayStationOnGoogleMap.jsp">
                            <strong>Select a Station</strong>
                            <select name="station">
                                <c:forEach var="station" items="${stations.rows}">
                                    <option value="${station.id}">${station.name}</option>
                                </c:forEach>
                            </select>
                           
                            <input type="submit" value="submit" name="submit" />
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <br>
        <table border="0">
            <thead>
                <tr>
                    <th>Select all Bikes that went from Station to Station</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Stations</td>
                </tr>
                <tr>
                    <td>
                        <form action="./responseStation2Station.jsp">
                            <strong>Select From Station</strong>
                            <select name="from_station_id">
                                <c:forEach var="fromstation" items="${stations.rows}">
                                    <option value="${fromstation.id}">${fromstation.name}</option>
                                </c:forEach>
                            </select>
                            
                            <strong>To Station</strong>
                            <select name="to_station_id">
                                <c:forEach var="tostation" items="${stations.rows}">
                                    <option value="${tostation.id}">${tostation.name}</option>
                                </c:forEach>
                            </select>

                            <input type="submit" value="submit" name="submit" />
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <table border="0">
            <thead>
                <tr>
                    <th>Select Path between two Bike Stations</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Stations</td>
                </tr>
                <tr>
                    <td>
                        <form action="./display2StationOnGoogleMap.jsp">
                            <strong>Select From Station</strong>
                            <select name="from_station_id">
                                <c:forEach var="fromstation" items="${stations.rows}">
                                    <option value="${fromstation.id}">${fromstation.name}</option>
                                </c:forEach>
                            </select>
                            
                            <strong>To Station</strong>
                            <select name="to_station_id">
                                <c:forEach var="tostation" items="${stations.rows}">
                                    <option value="${tostation.id}">${tostation.name}</option>
                                </c:forEach>
                            </select>

                            <input type="submit" value="submit" name="submit" />
                        </form>
                    </td>
                </tr>
                <tr>
                    <td>
                        
                        <form action="./displayAllStationsBikeLayer.jsp">
                            <strong>Display All Bike Stations on Google Map</strong>
                            <input type="submit" value="submit" name="submit">
                        </form>
                     </td>
                </tr>
            </tbody>
        </table>
        
        
    </body>
</html>
