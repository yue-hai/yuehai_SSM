package com.yuehai.ssm.service;

import com.yuehai.ssm.bean.Employee;

import java.util.List;

/**
 * @author 月海
 * @create 2022/2/6 16:57
 */

// 与员工有关的业务组件
public interface EmployeeService {

    /**
     * 查询所有员工数据（分页查询）
     * @return
     */
    List<Employee> getAll();

    /**
     * 添加用户信息
     * @param employee
     */
    void addEmp(Employee employee);

    /**
     * 根据姓名查询员工
     * @return
     */
    boolean getEmpByName(String empName);

    /**
     * 根据 id 查询员工
     * @param id
     */
    Employee getEmp(Integer id);

    /**
     * 根据 id 修改员工
     * @param employee
     */
    void updateEmp(Employee employee);

    /**
     * 根据 id 删除单个员工
     * @param id
     */
    void deleteEmp(Integer id);

    /**
     * 根据 id 删除单个员工
     * @param del_ids
     */
    void deleteBatch(List<Integer> del_ids);
}
