<%-- <%@ page session="false" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	if(request.getSession(false) != null && request.getSession(false).getAttribute("loggedInUser_userName") == null)
	{
		response.sendRedirect("login");
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<script type="text/javascript" src="<c:url value="/js/jquery-3.4.1.js" />" ></script>
	<script type="text/javascript" src="<c:url value="/js/bootstrap.bundle.min.js" />" ></script>
	<link rel="stylesheet" href="<c:url value="/css/bootstrap.css" />" >
	<link rel="stylesheet" href="<c:url value="/css/app.css" />" >
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Dash board</title>
</head>
<body>
	<div class="container-fluid wrapper">
		<div class="row header">
			<div class="col-md-2 header-item">
				Auto logout
			</div>
			<div class="col-md-3 offset-7 user-info-session-control-box">
				<div class="row">
					<div class="col-md-4 header-item">
					</div>
					<div class="col-md-4 header-item">
						<span class="glyphicon glyphicon-user"></span>
						<span>${loggedInUser_userName}</span>
					</div>
					<div class="col-md-4 header-item">
						<a href="${pageContext.request.contextPath}/logout">
							<span class="glyphicon glyphicon-off"></span>
							<span class="logout-label">
								logout
							</span>
						</a>
					</div>
				</div>
			</div>
		</div>
		<div class="row content">
			<div class="col-md-2 col-sm-2 col-xs-2 sidebar">
				<div class="menu-item">
					<a href="<c:url value="/dashboard.jsp" />" style="color:white">
						Dashboard
					</a>
				</div>
				<div class="menu-item">
					<a href="<c:url value="/dashboard-without-timer.jsp" />" style="color:white">
						Dashboard Without Timer
					</a>
				</div>
			</div>
			<div class="col-md-10 col-sm-10 col-xs-10">
				<h2 style="font-variant-caps: all-petite-caps;">Dashboard</h2>
				<h2 style="font-variant-caps: all-petite-caps;">Welcome ${user.userName}</h2>
				<button onCLick="doAjaxCall()">Refresh Session</button>
			</div>
		</div>
		
		<div class="row footer">
			<div style="margin: auto;">
				&copy;Copyright  2019-2020 nlpraveennl@gmail.com
			</div>
		</div>
	</div>
</body>
<jsp:include page="template/autologout-script-simple.jsp"></jsp:include>
</html>