<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	if(request.getSession(false) != null && request.getSession(false).getAttribute("loggedInUser_userName") != null)
	{
		response.sendRedirect("dashboard.jsp");
	}
%>

<!DOCTYPE html>
<html>
	<head>
		<script type="text/javascript" src="<c:url value="/js/jquery-3.4.1.js" />"></script>
		<link href="<c:url value="/css/bootstrap.css" />" rel="stylesheet">
		<style>
		.login-form-container
		{
			margin-top:10%;
			border: 1px solid darkgray;
		    padding: 15px;
		    background-color: royalblue;
		    color: white;
		}
		.login-form-header
		{
			font-family: monospace;
		    font-size: 22px;
		    border-bottom: 1px solid white;
		}
		.login-form-header p{
			margin: auto
		}
		.login-form-body
		{
			margin-top: 25px;
		}
		.errors-container
		{
			padding: 15px;
			margin-top: 10px;
			border: 1px solid transparent;
			border-radius: 4px;
			color: #a94442;
			background-color: #f2dede;
			border-color: #ebccd1;
		}
		.message-container
		{
			padding: 15px;
			margin-top: 10px;
			border: 1px solid transparent;
			border-radius: 4px;
			color: #31708f;
			background-color: #d9edf7;
			border-color: #bce8f1;
		}
		</style>
	</head>
	
	<body>
		<div class="container-fluid">
			<form method="post" action="login" class="form-horizontal" onsubmit="return validate(this);">
				<div class="login-form-container col-md-4 offset-md-4">
					<div class="row login-form-header">
						<p style="font-variant-caps: all-petite-caps;">Login Here</p>
					</div>
					<div class="login-form-body">
						  <div class="form-group">
						  	<div class="col-sm-12" style="font-variant-caps: all-petite-caps;">
						   		User Name
						   	</div>
						    <div class="col-sm-12">
						      <input name="userName" type="text" id="username" placeholder="User name" style="width:100%"/>
						    </div>
						  </div>
						  <div class="form-group" style="font-variant-caps: all-petite-caps;">
						  	<div class="col-sm-12">
						    	Password
						    </div>
						    <div class="col-sm-12">
						      <input type="password" name="password" id="password" placeholder="Password" style="width:100%"/>
						    </div>
						  </div>
						  <div class="form-group">
						    <div class="col-sm-offset-2 col-sm-10">
						      <button type="submit" class="btn btn-default" style="font-variant-caps: all-petite-caps;">
						      	Sign In
						      </button>
						    </div>
						  </div>
					</div>
				</div>
				<c:if test='${not empty requestScope["error"]}'>
					<div class="errors-container col-md-4 offset-md-4">
						<div class="error">${requestScope.error}</div>
					</div>
				</c:if>
				<c:if test="${not empty requestScope.msg}">
					<div class="message-container col-md-4 offset-md-4">
						<div class="msg">${requestScope.msg}</div>
					</div>
				</c:if>
			</form>
		</div>
	</body>
	<script>
		function validate()
		{
			if($('#username').val().trim().length == 0)
			{
				alert("Username is required");
				return false;
			}
			else if($('#password').val().trim().length == 0)
			{
				alert("Password is required");
				return false;
			}
		}
	</script>
</html>