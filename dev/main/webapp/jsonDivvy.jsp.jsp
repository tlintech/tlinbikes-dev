<%-- 
    Document   : getDivvyJSON
    Created on : Nov 27, 2015, 11:17:45 PM
    Author     : tlin
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<html>
<head>
        
</head>


<body>
<c:import var="jsonData" url="./sampledata.json"/>


<c:forEach items="${jsonData}" var="jsonItem"  varStatus="status" begin="0" end="0">  
    <c:out value="${jsonItem}" default="Not Available" escapeXml="false"></c:out>  
</c:forEach>  


</body>
</html>
