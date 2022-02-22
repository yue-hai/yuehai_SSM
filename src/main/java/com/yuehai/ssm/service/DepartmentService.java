package com.yuehai.ssm.service;

import com.yuehai.ssm.bean.Department;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 月海
 * @create 2022/2/7 17:41
 */

// 与部门有关的业务组件
public interface DepartmentService {

    /**
     * 查询所有的部门信息
     * @return
     */
    public List<Department> getAll();
}
