<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- 使工程进入 indx.jsp 时跳转到员工列表页面 --%>
<%--<jsp:forward page="/getEmps2"></jsp:forward>--%>

<%-- 使工程进入 indx.jsp 时跳转到员工列表（分页查询，使用 json 和 Ajax）页面 --%>
<jsp:forward page="/WEB-INF/views/list2.jsp"></jsp:forward>
