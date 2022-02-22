package com.yuehai.ssm.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.yuehai.ssm.bean.Employee;
import com.yuehai.ssm.bean.Msg;
import com.yuehai.ssm.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 月海
 * @create 2022/2/6 16:51
 */

// 处理和员工有关的请求
// 表明此为控制层
@Controller
public class EmployeeController {

    // 自动注入，根据类型注入
    @Autowired
    EmployeeService employeeService;

    // 查询所有员工数据（分页查询）
    @RequestMapping("/getEmps")
    // 将传入的要跳转到的页码数赋值给 pn，若是没有传入则默认值为 1
    // 使用 Map 向 request 域对象共享数据
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){

        // 1、在 MyBatis 配置文件中引入分页插件

        // 2、在查询之前调用分页方法即可实现分页
        // 参数1：页码数（第几页）；参数2：每页的数据数
        PageHelper.startPage(pn,5);

        // 3、查询语句（此时的查询即为查询语句）
        List<Employee> emps = employeeService.getAll();

        // 4、用 PageInfo 对查询结果进行包装
        // 参数1：查询出来的数据
        // 参数2：设置的 Navigatepage 的参数，连续显示的页数
        //      比如当前是第5页，则显示：34567
        //      比如当前是第7页，则显示：56789
        PageInfo page = new PageInfo(emps,5);
        /**
         * PageInfo 包含了非常全面的分页属性：
         *  // 当前页码
         *  page.getPageNum();
         *  // 每页的记录数
         *  page.getPageSize();
         *  // 开始的记录
         *  page.getStartRow();
         *  // 结束的记录
         *  page.getEndRow();
         *  // 总记录数
         *  page.getTotal();
         *  // 总页码
         *  page.getPages();
         *  // 第一页（已废弃）
         *  page.getFirstPage();
         *  // 最后一页（已废弃）
         *  page.getLastPage();
         *  // 是否第一页
         *  page.isFirstPage();
         *  // 是否最后一页
         *  page.isLastPage();
         *  // 是否有前页
         *  page.isHasPreviousPage();
         *  // 是否有后页
         *  page.isHasNextPage();
         *  // 连续显示的页码，是个数组，需遍历
         *  page.getNavigatepageNums(
         */

        // 将分页后的数据共享到请求域，参数1为名称，参数2为值
        model.addAttribute("pageInfo",page);

        return "list";
    }

    // 需导入 jackson 依赖，用于处理 json
    // 查询所有员工数据（分页查询，使用 json 和 Ajax）
    @RequestMapping("/getEmps2")
    // @ResponseBody用于标识一个控制器方法，
    // 可以将该方法的返回值直接作为响应报文的响应体响应到浏览器
    @ResponseBody
    // 将传入的要跳转到的页码数赋值给 pn，若是没有传入则默认值为 1
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        // 1、在 MyBatis 配置文件中引入分页插件

        // 2、在查询之前调用分页方法即可实现分页
        // 参数1：页码数（第几页）；参数2：每页的数据数
        PageHelper.startPage(pn,5);

        // 3、查询语句（此时的查询即为分页查询语句）
        List<Employee> emps = employeeService.getAll();

        // 4、用 PageInfo 对查询结果进行包装
        // 参数1：查询出来的数据
        // 参数2：设置的 Navigatepage 的参数，连续显示的页数
        //      比如当前是第5页，则显示：34567
        //      比如当前是第7页，则显示：56789
        PageInfo page = new PageInfo(emps,5);

        // 返回处理成功（状态码100），并将分页数据一起返回
        return Msg.success().add("pageInfo",page);
    }

    /**
     * 使用 Ajax 检验用户名是否可用
     * @param empName
     * @return
     */
    @RequestMapping("checkuser")
    // @ResponseBody用于标识一个控制器方法，
    // 可以将该方法的返回值直接作为响应报文的响应体响应到浏览器
    @ResponseBody
    // 将传入的员工姓名赋值给 empName
    public Msg checkuser(@RequestParam("empName") String empName){
        // 先判断当前输入的用户名是否是合法的表达式，以免与前端 js 的校验冲突
        // 定义正则表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        // 判断传进来的用户名是否符合正则表达式的规则，返回 true 表示符合
        if(!empName.matches(regx)){
            // 返回处理失败（状态码200）
            return Msg.fail().add("va_msg","用户名必须是2-5位中文或者6-16位英文和数字的组合");
        }

        // 数据库中有值则返回 true，没有值则返回 false
        boolean empByName = employeeService.getEmpByName(empName);
        // 判断返回值
        if (empByName){
            // 返回处理成功（状态码100）
            return Msg.success();
        }else {
            // 返回处理失败（状态码200）
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    /**
     * 添加用户信息，请求地址为：emp
     * RESTful 风格的 URI，请求方式为：POST，添加
     * 	 1、支持 JSR303 校验
     * 	 2、导入 Hibernate-Validator
     * @return
     */
    @RequestMapping(value = "emp",method = RequestMethod.POST)
    // @ResponseBody用于标识一个控制器方法，
    // 可以将该方法的返回值直接作为响应报文的响应体响应到浏览器
    @ResponseBody
    // @Valid：表示后面跟的那个对象要进学校校验
    // BindingResult：封装的校验的结果
    public Msg addEmp(@Valid Employee employee, BindingResult result){
        // result.hasErrors()：校验失败（不通过）
        if(result.hasErrors()){
            // 校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            // 创建一个 map 集合中，将错误的信息封装到其中
            Map<String,Object> map = new HashMap<>();
            // result.getFieldErrors()：返回所有字段的校验失败的错误信息
            List<FieldError> errors = result.getFieldErrors();
            // 遍历错误信息，将错误的信息封装到 map 集合中
            for(FieldError fieldError : errors){
                // fieldError.getField()：错误的字段名
                // fieldError.getDefaultMessage()：错误信息
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            // 返回封装后的错误的信息
            return Msg.fail().add("errorFields",map);
        }else {
            // 校验成功则调用添加方法
            employeeService.addEmp(employee);

            // 返回处理成功（状态码100）
            return Msg.success();
        }
    }

    // RESTful 风格的 URI，请求方式为：GET，查询
    @RequestMapping(value = "emp/{id}",method = RequestMethod.GET)
    // @ResponseBody用于标识一个控制器方法，
    // 可以将该方法的返回值直接作为响应报文的响应体响应到浏览器
    @ResponseBody
    // 将传入的员工 id 赋值给 id
    public Msg getEmp(@PathVariable("id") Integer id){
        // 查询语句，根据 id 查询
        Employee employee = employeeService.getEmp(id);

        // 返回处理成功（状态码100），并将查询到的数据一起返回
        return Msg.success().add("emp",employee);
    }

    /**
     * 如果直接发送ajax=PUT形式的请求
     * 封装的数据无法封装
     * Employee
     * [empId=1014, empName=null, gender=null, email=null, dId=null]
     *
     * 问题：
     * 请求体中有数据；
     * 但是Employee对象封装不上；
     * update tbl_emp  where emp_id = 1014;
     *
     * 原因：
     * Tomcat：
     * 		1、将请求体中的数据，封装一个map。
     * 		2、request.getParameter("empName")就会从这个map中取值。
     * 		3、SpringMVC封装POJO对象的时候，会把POJO中每个属性的值，request.getParamter("email");
     *
     * AJAX发送PUT请求引发的血案：
     * 		PUT请求，请求体中的数据，request.getParameter("empName")拿不到
     * 		Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
     *
     * org.apache.catalina.connector.Request--parseParameters() (3111行)：
     *
     * protected String parseBodyMethods = "POST";
     * if( !getConnector().isParseBodyMethod(getMethod()) ) {
     *      success = true;
     *      return;
     * }
     *
     * 解决方案；
     *  我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
     *  1、web.xml 配置上 HttpPutFormContentFilter；
     *  2、他的作用；将请求体中的数据解析包装成一个map。
     *  3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
     */
    // RESTful 风格的 URI，请求方式为：PUT，修改
    // 这里的参数 empId 要和实体类中的属性名一致，才会自动封装进对象
    @RequestMapping(value = "emp/{empId}",method = RequestMethod.PUT)
    // @ResponseBody用于标识一个控制器方法，
    // 可以将该方法的返回值直接作为响应报文的响应体响应到浏览器
    @ResponseBody
    public Msg updateEmp(Employee employee){
        // 根据 id 修改员工
        employeeService.updateEmp(employee);

        // 返回处理成功（状态码100）
        return Msg.success();
    }

    /**
     * 单个批量删除二合一
     * 批量删除：1-2-3，传入多个 id
     * 单个删除：1，传入一个 id
     */
    // RESTful 风格的 URI，请求方式为：DELETE，删除
    @RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
    // @ResponseBody用于标识一个控制器方法，
    // 可以将该方法的返回值直接作为响应报文的响应体响应到浏览器
    @ResponseBody
    // 将传入的员工一个或多个员工 id 赋值给 ids
    public Msg deleteEmp(@PathVariable("ids")String ids){
        // 判断传入的参数是否带'-'横线（是否为多个值）
        if(ids.contains("-")){
            // 带则为批量删除
            // 将 ids 按照 '-' 进行分割，转为数组
            String[] str_ids = ids.split("-");

            // 创建集合，用来保存多个员工 id
            List<Integer> del_ids = new ArrayList<>();
            // 遍历，将 id 添加到集合中
            for (String id : str_ids) {
                // 强转为 Integer 类型并添加入集合
                del_ids.add(Integer.parseInt(id));
            }
            // 调用批量删除的方法
            employeeService.deleteBatch(del_ids);
        }else{
            // 不带则为单个删除
            // 将传入的参数强转为 Integer 类型并赋值给 id
            Integer id = Integer.parseInt(ids);
            // 调用单个删除的方法
            employeeService.deleteEmp(id);
        }
        // 返回处理成功（状态码100）
        return Msg.success();
    }

}
