<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: ccj77
  Date: 2022/2/6
  Time: 16:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->

    <title>员工列表</title>

    <!-- Bootstrap 引入在线的 css 样式 -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"
          integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu"
          crossorigin="anonymous">

    <!-- Bootstrap 引入在线的 jQuery 和 Bootstrap 的所有 JavaScript 插件 -->
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="https://fastly.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"
            integrity="sha384-nvAa0+6Qg9clwYCGGPpDQLVpLNn0fRaROjHqs13t4Ggj3Ez50XnGQqc/r8MhnRDZ"
            crossorigin="anonymous">
    </script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"
            integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd"
            crossorigin="anonymous">
    </script>

    <%-- 获取当前站点的根路径，赋值给 APP_PATH --%>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

</head>
<body>

<!-- 搭建显示页面 -->
<div class="container">

    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>月海 - SSM 整合练习</h1>
        </div>
    </div>

    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>

    <!-- 显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>id</th>
                    <th>员工姓名</th>
                    <th>员工性别</th>
                    <th>员工邮箱</th>
                    <th>所在部门</th>
                    <th>操作</th>
                </tr>
                <!-- items：要遍历的数据；var：每次遍历赋值给的属性 -->
                <!-- pageInfo.list：保存的员工数据 -->
                <c:forEach items="${pageInfo.list }" var="emp">
                    <tr>
                        <th>${emp.empId }</th>
                        <th>${emp.empName }</th>
                        <!-- 三元运算 -->
                        <th>${emp.gender=="M"?"男":"女" }</th>
                        <th>${emp.email }</th>
                        <th>${emp.department.deptName }</th>
                        <th>
                            <button class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </th>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>

    <!-- 显示分页信息 -->
    <div class="row">
        <!--分页文字信息  -->
        <div class="col-md-6">当前 ${pageInfo.pageNum }页,总${pageInfo.pages }
            页,总 ${pageInfo.total } 条记录
        </div>

        <!-- 分页条信息 -->
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${APP_PATH }/getEmps?pn=1">首页</a></li>

                    <!-- 判断当前页是否有前页，有则前一页按钮可点击 -->
                    <c:if test="${pageInfo.hasPreviousPage }">
                        <li>
                            <a href="${APP_PATH }/getEmps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <!-- 判断当前页是否有前页，没有则前一页按钮不可点击 -->
                    <c:if test="${!pageInfo.hasPreviousPage }">
                        <li><a href="#" class="btn disabled" role="button">&laquo;</a></li>
                    </c:if>

                    <!-- 遍历连续显示的页码，是个数组 -->
                    <c:forEach items="${pageInfo.navigatepageNums }" var="page_Num">
                        <!-- 若本次遍历的页码是当前页码，则按钮不可点击，且按钮高亮 -->
                        <c:if test="${page_Num == pageInfo.pageNum }">
                            <li class="active"><a href="#">${page_Num }</a></li>
                        </c:if>
                        <!-- 若本次遍历的页码不是当前页码，则按钮可点击 -->
                        <c:if test="${page_Num != pageInfo.pageNum }">
                            <li><a href="${APP_PATH }/getEmps?pn=${page_Num }">${page_Num }</a></li>
                        </c:if>
                    </c:forEach>

                    <!-- 判断当前页是否有后页，有则后一页按钮可点击 -->
                    <c:if test="${pageInfo.hasNextPage }">
                        <li>
                            <a href="${APP_PATH }/getEmps?pn=${pageInfo.pageNum+1 }" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <!-- 判断当前页是否有前页，没有则后一页按钮不可点击 -->
                    <c:if test="${!pageInfo.hasNextPage }">
                        <li><a href="#" class="btn disabled" role="button">&raquo;</a></li>
                    </c:if>

                    <li><a href="${APP_PATH }/getEmps?pn=${pageInfo.pages}">末页</a></li>

                </ul>
            </nav>
        </div>
    </div>

</div>

</body>

</html>
