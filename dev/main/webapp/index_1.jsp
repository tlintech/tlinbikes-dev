<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%--
    Document   : index
    Created on : Dec 22, 2009, 7:39:49 PM
    Author     : nbuser
--%>

<sql:query var="bikes" dataSource="jdbc/divvy">
    SELECT distinct(bikeid) FROM divvy_trips order by bikeid asc limit 200
</sql:query>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="style.css">
        <title>divvy Homepage</title>
    </head>
    <body>
        <h1>Welcome to <strong>Divvy</strong>
        </h1>

        <table border="0">
            <thead>
                <tr>
                    <th>Search for Divvy Bike Trips.</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Bikes are identified by Bike ID Number</td>
                </tr>
                <tr>
                    <td>
                        <form action="response.jsp">
                            <strong>Select a Bike:</strong>
                            <select name="bikeid_select">
                                <c:forEach var="row" items="${bikes.rows}">
                                    <option value="${row.bikeid}">${row.bikeid}</option>
                                </c:forEach>
                            </select>
                            <input type="submit" value="submit" name="submit" />
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>
    </body>
</html>