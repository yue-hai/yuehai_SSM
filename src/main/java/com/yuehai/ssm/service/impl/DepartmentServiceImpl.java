package com.yuehai.ssm.service.impl;

import com.yuehai.ssm.bean.Department;
import com.yuehai.ssm.dao.DepartmentMapper;
import com.yuehai.ssm.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 月海
 * @create 2022/2/7 17:41
 */

// 表明此为 Service 层
@Service
public class DepartmentServiceImpl implements DepartmentService {

    // 自动注入，根据类型注入
    @Autowired
    DepartmentMapper departmentMapper;

    @Override
    public List<Department> getAll() {
        // 按照条件查询部门表，传入 null 则为查询全部
        return departmentMapper.selectByExample(null);
    }
}
