package com.yuehai.ssm.controller;

import com.yuehai.ssm.bean.Department;
import com.yuehai.ssm.bean.Msg;
import com.yuehai.ssm.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @author 月海
 * @create 2022/2/7 17:39
 */

// 处理和部门有关的请求
// 表明此为控制层
@Controller
public class DepartmentController {

    // 自动注入，根据类型注入
    @Autowired
    DepartmentService departmentService;

    // 需导入 jackson 依赖，用于处理 json
    // 查询所有部门数据（使用 json 和 Ajax）
    @RequestMapping("/getDepts")
    // @ResponseBody用于标识一个控制器方法，
    // 可以将该方法的返回值直接作为响应报文的响应体响应到浏览器
    @ResponseBody
    public Msg getDepts(){
        // 调用查询所有部门的方法
        List<Department> depts = departmentService.getAll();

        // 返回处理成功（状态码100），并将查询到的数据一起返回
        return Msg.success().add("depts",depts);
    }

}
