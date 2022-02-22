<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->

    <title>员工列表 Plus</title>

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

    <%-- 页面跳转，查询数据，解析 json，调用 Ajax --%>
    <script type="text/javascript">

        // 定义一个总记录数 和 当前页码数，方便之后的使用
        var totalRecord,currentPage;

        // 页面加载完成以后，调用页面跳转方法，解析数据
        $(function () {
            // 调用跳转方法，跳到第一页
            to_page(1);
        });

        // 抽取 Ajax 页面跳转及解析 json 数据的方法，便于调用
        // 参数 pn 为要跳转到的页码数
        function to_page(pn) {
            $.ajax({
                // 请求地址为：工程路径/getEmps2
                url: "${APP_PATH}/getEmps2",
                // 请求参数
                data: "pn=" + pn,
                // 请求方式 GET
                type: "GET",
                // result：服务器返回的数据
                success: function (result) {
                    // 1、解析并显示员工数据
                    build_emps_table(result);
                    // 2、解析并显示分页信息
                    build_page_info(result);
                    // 3、解析显示分页条数据
                    build_page_nav(result);
                }
            });
        }

        // 1、解析并显示员工数据
        function build_emps_table(result) {
            //清空员工数据表格，否则本次数据会与上一次的数据叠加，导致页面混乱
            $("#emps_table tbody").empty();

            // 分页数据都在 extend 对象中的 pageInfo 对象中的 list 数组中
            var emps = result.extend.pageInfo.list;
            // 遍历 list 员工数据，参数1：要遍历的数据，参数2：回调函数
            // 回调函数参数1：索引；参数2：当前遍历的数据对象
            $.each(emps, function (index, item) {
                // 每条数据前面的复选框
                var checkBoxTd = $("<td><input type='checkbox' class='check_item' /></td>");
                // 添加 td 标签，并将员工 id 放入其中
                var empIdTd = $("<td></td>").append(item.empId);
                // 添加 td 标签，并将员工姓名放入其中
                var empNameTd = $("<td></td>").append(item.empName);
                // 添加 td 标签，并将员工性别放入其中，以三元运算符改变参数
                var genderTd = $("<td></td>").append(item.gender == '0' ? '受' : '攻');
                // 添加 td 标签，并将员工邮箱放入其中
                var emailTd = $("<td></td>").append(item.email);
                // 添加 td 标签，并将员工部门放入其中
                var deptNameTd = $("<td></td>").append(item.department.deptName);

                // 编辑按钮，先添加 button 标签，再添加其 class 属性，然后添加 span 标签，再添加其 class 属性
                // 最后在 span 标签中加入【编辑】文字
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                // 为编辑按钮添加一个自定义的属性，来表示当前员工 id
                editBtn.attr("edit-id", item.empId);

                // 删除按钮
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                // 为删除按钮添加一个自定义的属性来表示当前删除的员工 id
                delBtn.attr("del-id", item.empId);

                // 将编辑按钮与删除按钮添加到 td 标签中，两个按钮
                var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                // 将上面这些对象都添加到 id 为 emps_table 的标签的 tbody 标签的 tr 标签中
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    // 选择 id 为 emps_table 的标签的 tbody 标签中
                    .appendTo("#emps_table tbody");
            });
        }

        // 2、解析并显示分页文字信息，当前是第几页、总记录数等
        function build_page_info(result) {
            //清空分页文字信息，否则本次数据会与上一次的数据叠加，导致页面混乱
            $("#page_info_area").empty();

            // 创建分页文字信息，将其添加到 id 为 page_info_area 的标签中
            $("#page_info_area").append("当前是第" + result.extend.pageInfo.pageNum + "页，总共" +
                result.extend.pageInfo.pages + "页，总共有" +
                result.extend.pageInfo.total + "条记录");

            // 给定义的总记录数赋值，方便之后的操作
            totalRecord = result.extend.pageInfo.total;
            // 给定义的当前页码赋值，方便之后的操作
            currentPage = result.extend.pageInfo.pageNum;
        }

        // 3、解析显示分页条数据
        function build_page_nav(result) {
            //清空分页条数据，否则本次数据会与上一次的数据叠加，导致页面混乱
            $("#page_nav_area").empty();

            // 创建下面这些 li 元素的父元素 ul
            var ul = $("<ul></ul>").addClass("pagination");

            // 首页，添加 li 标签，在其中添加 a 标签并在其中添加【首页】，并设置a 标签的 href 属性
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
            // 上一页
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            // 判断当前页是否有前页（是否是第一页）
            if (result.extend.pageInfo.hasPreviousPage == false) {
                // 是的话给 首页 和 上一页 添加 class 样式：disabled，使其不可点击
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            } else {
                // 不是的话为元素添加点击翻页的事件
                firstPageLi.click(function () {
                    // 跳转到第一页
                    to_page(1);
                });
                prePageLi.click(function () {
                    // 跳转到当前页的下一页
                    to_page(result.extend.pageInfo.pageNum - 1);
                });
            }
            // 将 首页 和 上一页 添加到 ul 标签中
            ul.append(firstPageLi).append(prePageLi);

            // 使用遍历给 ul 标签中添加页码提示，1、2、3、4、5 数字导航分页条
            // 回调函数参数1：索引；参数2：当前遍历的数据对象
            $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
                // 将 a 标签添加到 li 标签中，并在其中加入本次遍历出来的数据
                var numLi = $("<li></li>").append($("<a></a>").append(item));
                // 判断本次遍历出来的数据和本页的页码数是否相同
                if (result.extend.pageInfo.pageNum == item) {
                    // 相同则添加 class 样式：active，使其高亮
                    numLi.addClass("active");
                }
                // 添加点击事件
                numLi.click(function () {
                    to_page(item);
                });
                // 在 ul 标签中添加本次循环的 li 标签
                ul.append(numLi);
            });

            // 下一页
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            // 末页
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
            // 判断当前页是否有下页（是否是最后一页）
            if (result.extend.pageInfo.hasNextPage == false) {
                // 是的话给 末页 和 下一页 添加 class 样式：disabled，使其不可点击
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            } else {
                // 不是的话为元素添加点击翻页的事件
                nextPageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum + 1);
                });
                lastPageLi.click(function () {
                    // 跳转到最后一页
                    to_page(result.extend.pageInfo.pages);
                });
            }
            // 将 下一页 和 末页 添加到 ul 标签中
            ul.append(nextPageLi).append(lastPageLi);

            // 将 ul 标签添加到 id 为 page_nav_area 的标签的 nav 标签中
            $("<nav></nav>").append(ul).appendTo("#page_nav_area");
        }

    </script>

</head>
<body>

<!-- 员工添加的模态框，点击新增按钮调用 js 方法，使其弹出 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <%-- 模态框最上方显示的 员工添加 文字 --%>
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>

            <div class="modal-body">
                <%-- form 表单 --%>
                <form class="form-horizontal">
                    <%-- 员工姓名 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <%-- 员工姓名输入框 --%>
                            <input type="text" name="empName" class="form-control" id="empName_add_input"
                                   placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%-- 员工邮箱 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工邮箱</label>
                        <div class="col-sm-10">
                            <%-- 员工邮箱输入框 --%>
                            <input type="text" name="email" class="form-control" id="email_add_input"
                                   placeholder="email@yuehai.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%-- 员工攻受 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工攻受</label>
                        <div class="col-sm-10">
                            <%-- 员工攻受单选框 --%>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="1" checked="checked"> 攻
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="0"> 受
                            </label>
                        </div>
                    </div>
                    <%-- 所在部门 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">所在部门</label>
                        <div class="col-sm-4">
                            <!-- 查出来的部门下拉单选框，部门提交部门id即可 -->
                            <select class="form-control" name="dId" id="dept_add_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <!-- 部门提交部门id即可 -->
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 员工修改的模态框，点击编辑按钮调用 js 方法，使其弹出 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <%-- 模态框最上方显示的 员工修改 文字 --%>
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工修改</h4>
            </div>

            <div class="modal-body">
                <%-- form 表单 --%>
                <form class="form-horizontal">
                    <%-- 员工姓名 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <%-- 员工姓名展示框，不可修改 --%>
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%-- 员工邮箱 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工邮箱</label>
                        <div class="col-sm-10">
                            <%-- 员工邮箱输入框 --%>
                            <input type="text" name="email" class="form-control" id="email_update_input"
                                   placeholder="email@yuehai.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%-- 员工攻受 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工攻受</label>
                        <div class="col-sm-10">
                            <%-- 员工攻受单选框 --%>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="1" checked="checked"> 攻
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="0"> 受
                            </label>
                        </div>
                    </div>
                    <%-- 所在部门 --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">所在部门</label>
                        <div class="col-sm-4">
                            <!-- 查出来的部门下拉单选框，部门提交部门id即可 -->
                            <select class="form-control" name="dId" id="dept_update_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <!-- 部门提交部门id即可 -->
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
            </div>
        </div>
    </div>
</div>

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
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>

    <!-- 显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <tr>
                    <th>
                        <%-- 复选框，点击使得选择本页所有数据 --%>
                        <input type="checkbox" id="check_all" />
                    </th>
                    <th>id</th>
                    <th>员工姓名</th>
                    <th>员工性别</th>
                    <th>员工邮箱</th>
                    <th>所在部门</th>
                    <th>操作</th>
                </tr>

            </table>
        </div>
    </div>

    <!-- 显示分页信息 -->
    <div class="row">
        <!--分页文字信息  -->
        <div class="col-md-6" id="page_info_area"></div>
        <!-- 分页条信息 -->
        <div class="col-md-6" id="page_nav_area"></div>
    </div>

</div>

</body>

<%-- 点击弹出模态框，进行增删改，此类 js 需放在页面内容的下方 --%>
<script type="text/javascript">

    // 清空表单样式及内容，传入的参数为选择器
    function reset_form(ele){
        // 将 jq 对象转换为 js 对象以使用 reset() 方法，重置表单内容
        $(ele)[0].reset();
        // 清空传入的选择器中的所有的这两种表单样式
        $(ele).find("*").removeClass("has-error has-success");
        // 清空传入的选择器中 class 属性为 help-block 的文本内容
        $(ele).find(".help-block").text("");
    }

    // 点击新增按钮弹出员工添加的模态框，
    // 需放在按钮内容下面，不然加载此 js 时按钮还没加载，无法绑定
    $("#emp_add_modal_btn").click(function () {
        // 每次模态框弹出都清除表单数据，表单完整重置（表单的数据，表单的样式）
        // 调用 reset_form 方法清空数据
        reset_form("#empAddModal form");

        // 调用 getDepts 方法发送ajax请求，查出部门信息，
        // 将其显示在 id 为 dept_add_select （下拉列表）的标签中
        getDepts("#dept_add_select");

        // 调用 modal 方法弹出模态框
        $("#empAddModal").modal({
            // 打开模态框时点击背景不关闭模态框
            backdrop: "static"
        });
    });

    // 查出所有的部门信息并显示在下拉列表中方法
    function getDepts(ele){
        // 清空之前下拉列表的值
        $(ele).empty();

        // 发送 ajax 请求
        $.ajax({
            // 请求地址
            url:"${APP_PATH}/getDepts",
            // 请求方式 GET
            type:"GET",
            // 请求成功以后，处理返回的数据
            success:function(result){
                // 遍历 depts 部门信息，参数1：要遍历的数据，参数2：回调函数
                // 遍历的回调函数也可以不写参数，这样就用 this 表示本次遍历的对象
                $.each(result.extend.depts,function(){
                    // 在 option 标签中加入本次遍历的 deptName，并添加属性 value 值为 本次遍历的 deptId
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    // 将本次遍历的数据添加到 id 为 ele（传入的参数）的标签中
                    optionEle.appendTo(ele);
                });
            }
        });
    }

    // 显示校验结果的提示信息方法，传入 status 表示成功，其他为失败
    // 参数1：选择器名称；参数2：成功还是失败；参数3：提示的内容
    function show_validate_msg(ele,status,msg){
        // 清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        // 清除 span 标签中显示的文本内容
        $(ele).next("span").text("");

        // 判断成功还是失败
        if("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    // 点击确定按钮后校验表单数据方法
    function validate_add_form(){
        // 拿到要校验的数据，使用正则表达式
        // 1、校验员工姓名信息
        var empName = $("#empName_add_input").val();
        // 规则：6-16 位英文字母和数字或 2-5 位中文的组合
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        // 判断是否满足规则
        if(!regName.test(empName)){
            // 不满足规则的提示，调用 show_validate_msg 方法
            show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
            // 跳出方法
            return false;
        }else{
            // 满足规则的提示，调用 show_validate_msg 方法
            show_validate_msg("#empName_add_input", "success", "");
        };

        // 2、校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        // 判断是否满足规则
        if(!regEmail.test(email)){
            // 不满足规则的提示，调用 show_validate_msg 方法
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
            // 跳出方法
            return false;
        }else{
            // 满足规则的提示，调用 show_validate_msg 方法
            show_validate_msg("#email_add_input", "success", "");
        }
        // 都没有错误，返回 true
        return true;
    }

    // 离开焦点事件，发送 ajax 请求校验用户名是否可用
    $("#empName_add_input").change(function(){
        // 获取当前标签中 value 属性的值
        var empName = this.value;

        // 发送 ajax 请求校验用户名是否可用
        $.ajax({
            // 请求地址
            url:"${APP_PATH}/checkuser",
            // 请求方式 GET
            type:"GET",
            // 请求的参数
            data:"empName=" + empName,
            // 请求成功以后，处理返回的数据
            success:function(result){
                // 判断返回的状态码是否为 100
                if(result.code==100){
                    // 是则说明数据库中没有此员工，可以添加
                    // 满足规则的提示，调用 show_validate_msg 方法
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    // 给保存按钮一个自定义的属性，让我们可以知道校验用户名的结果
                    $("#emp_save_btn").attr("ajax-va","success");
                }else{
                    // 不是则说明数据库中有此员工，不可以添加
                    // 不满足规则的提示，调用 show_validate_msg 方法
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                    // 给保存按钮一个自定义的属性，让我们可以知道校验用户名的结果
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
    });

    // 点击保存按钮，添加员工
    $("#emp_save_btn").click(function(){
        // 一、模态框中填写的表单数据提交给服务器进行保存
        // 1、对提交给服务器的数据进行 js 校验，调用 validate_add_form 方法判断其返回值
        if(!validate_add_form()){
            // 返回值为 false 则跳出方法
            return false;
        };
        // 2、判断之前的，离开焦点事件，发送 ajax 请求校验用户名是否可用
        // 判断保存按钮的 ajax-va 属性的值是否为 error，之前设置的值
        if($(this).attr("ajax-va")=="error"){
            // 为 error 跳出方法
            return false;
        }

        // 二、发送ajax请求保存员工
        $.ajax({
            // 请求地址
            url:"${APP_PATH}/emp",
            // 请求方式 POST
            type:"POST",
            // 请求的参数：empAddModal 的标签中的 form 标签序列化之后的数据
            // serialize()：将表单中的数据序列化
            data:$("#empAddModal form").serialize(),
            // 请求成功以后，处理返回的数据
            success:function(result){
                // 判断返回的状态码是否为 100
                if(result.code == 100){
                    // 是则说明员工保存成功；
                    // 1、关闭模态框
                    $("#empAddModal").modal('hide');

                    // 2、调用最开始定义的总记录数，来到最后一页，
                    // 显示刚才保存的数据，发送 ajax 请求显示最后一页数据即可
                    to_page(totalRecord);
                }
                else{
                    // 不是则显示显示失败信息
                    // 有哪个字段的错误信息就显示哪个字段的；undefined：空
                    if(undefined != result.extend.errorFields.empName){
                        //显示员工名字的错误信息
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                    if(undefined != result.extend.errorFields.email){
                        //显示邮箱错误信息
                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                    }
                }
            }
        });
    });


    // 点击编辑按钮，打开编辑模态框
    // 我们是按钮创建之前就绑定了click，所以绑定不上（页面加载完成之后由Ajax创建的按钮）
    // 1、可以在创建按钮的时候绑定
    // 2、绑定点击.live()，jquery新版没有live，使用on进行替代（此处使用此方法）
    // 在整个文档中（document）的 class 属性中有 edit_btn 值的标签绑定单击事件（click）
    $(document).on("click",".edit_btn",function(){
        // 1、查出部门信息，并显示部门列表
        getDepts("#empUpdateModal select");
        // 2、查出员工信息，传入员工 id，显示员工信息
        getEmp($(this).attr("edit-id"));

        //3、把员工的 id 传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));

        // 4、打开模态框
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });

    // 查出员工信息，显示员工信息
    function getEmp(id){
        // 发送 ajax 请求查询员工信息
        $.ajax({
            // 请求地址，传入员工 id
            url:"${APP_PATH}/emp/"+id,
            // 请求方式 GET
            type:"GET",
            // 请求成功以后，处理返回的数据
            success:function(result){
                // 获取返回的 emp 对象并赋值给 empData
                var empData = result.extend.emp;
                // 取出对象中的数据赋值给相应的元素
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                // id 为 empUpdateModal 的标签中的 input 标签中的
                // 属性 name 的值为 gender 的标签赋值
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }
        });
    }

    // 点击更新，更新员工信息
    $("#emp_update_btn").click(function(){
        // 验证邮箱是否合法
        // 1、校验邮箱信息
        var email = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
            return false;
        }else{
            show_validate_msg("#email_update_input", "success", "");
        }

        // 2、发送 ajax 请求保存更新的员工数据
        $.ajax({
            // 请求地址，传入员工 id
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            // 请求方式 PUT
            type:"PUT",
            // 请求的参数：empAddModal 的标签中的 form 标签序列化之后的数据
            // serialize()：将表单中的数据序列化
            data:$("#empUpdateModal form").serialize(),
            // 请求成功以后，处理返回的数据
            success:function(result){
                // 1、关闭模态框
                $("#empUpdateModal").modal("hide");
                // 2、回到本页面
                to_page(currentPage);
            }
        });
    });

    // 点击删除按钮，单个删除
    // 我们是按钮创建之前就绑定了click，所以绑定不上（页面加载完成之后由Ajax创建的按钮）
    // 1、可以在创建按钮的时候绑定
    // 2、绑定点击.live()，jquery新版没有live，使用on进行替代（此处使用此方法）
    // 在整个文档中（document）的 class 属性中有 delete_btn 值的标签绑定单击事件（click）
    $(document).on("click",".delete_btn",function(){
        // 1、弹出是否确认删除对话框
        // 当前按钮的父元素中的 tr 元素里的第 2 个 td 元素中的文本内容，赋值给 empName
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("del-id");

        // 判断用户点击的确定还是取消
        // confirm：提示框，用户点击 true 则返回 true，点击 false 则返回 false
        if(confirm("确认删除【"+empName+"】吗？")){
            // 确认，发送ajax请求删除即可
            $.ajax({
                // 请求地址，传入员工 id
                url:"${APP_PATH}/emp/" + empId,
                // 请求方式 DELETE
                type:"DELETE",
                // 请求成功以后，处理返回的数据
                success:function(result){
                    // 弹窗提示返回的提示信息
                    alert(result.msg);
                    // 回到本页
                    to_page(currentPage);
                }
            });
        }
    });

    // 完成点击最上面的复选框的 全选/全不选 功能
    $("#check_all").click(function(){
        // attr 获取 checked 是 undefined
        // 我们这些 dom 原生的属性；attr获取自定义属性的值；
        // prop 可以修改和读取 dom 原生属性的值
        // 为 class 属性为 check_item 的 checked 属性赋值为此复选框的 checked 的值
        $(".check_item").prop("checked",$(this).prop("checked"));
    });

    // 为每条数据前的复选框添加
    $(document).on("click",".check_item",function(){
        // 判断当前选择中的元素是否全部和本页所有复选框的个数相等
        // .check_item:checked：class 属性为 check_item 的所有被选中（checked）的复选框
        // $(".check_item:checked").length：class 属性为 check_item 的所有被选中（checked）的复选框的个数
        // $(".check_item").length：class 属性为 check_item 的复选框的个数
        var flag = $(".check_item:checked").length==$(".check_item").length;
        // 将 flag 赋值给 id 为 check_all 的标签的 checked 属性
        // 若是以全选，则最上面的复选框页会自动选择
        // 若是未全选，则最上面的复选框页会自动取消选择
        $("#check_all").prop("checked",flag);
    });

    // 点击全部删除，就批量删除
    $("#emp_delete_all_btn").click(function(){
        // 赋一个初始值
        var empNames = "";
        var del_idstr = "";

        // 遍历每一个被选中的元素
        $.each($(".check_item:checked"),function(){
            // this：代表当前正在被遍历的元素（复选框）
            // 组装员工姓名字符串
            // 当前复选框的父元素中的 tr 元素里的第 2 个 td 元素的文本，并在后面加一个','
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            // 组装员工 id 字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });

        // 去除 empNames 多余的 ','
        empNames = empNames.substring(0, empNames.length-1);
        // 去除删除的 id 多余的 '-'
        del_idstr = del_idstr.substring(0, del_idstr.length-1);

        // 判断用户点击的确定还是取消
        // confirm：提示框，用户点击 true 则返回 true，点击 false 则返回 false
        if(confirm("确认删除【"+empNames+"】吗？")){
            // 发送 ajax 请求删除
            $.ajax({
                // 请求地址，传入多个员工的 id
                url:"${APP_PATH}/emp/"+del_idstr,
                // 请求方式 DELETE
                type:"DELETE",
                // 请求成功以后，处理返回的数据
                success:function(result){
                    // 弹窗提示返回的提示信息
                    alert(result.msg);
                    // 回到当前页面
                    to_page(currentPage);
                }
            });
        }
    });

</script>

</html>
