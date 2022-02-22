package com.yuehai.ssm.service.impl;

import com.yuehai.ssm.bean.Employee;
import com.yuehai.ssm.bean.EmployeeExample;
import com.yuehai.ssm.dao.EmployeeMapper;
import com.yuehai.ssm.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 月海
 * @create 2022/2/6 16:59
 */

// 表明此为 Service 层
@Service
public class EmployeeServiceImpl implements EmployeeService {

    // 自动注入，根据类型注入
    @Autowired
    private EmployeeMapper employeeMapper;

    @Override
    public List<Employee> getAll() {
        // 按照条件查询，联合查询部门表，传入 null 则为查询全部
        return employeeMapper.selectByExampleWithDept(null);
    }

    @Override
    public void addEmp(Employee employee) {
        // 有选择的插入，id 是自增的所以不插入
        employeeMapper.insertSelective(employee);
    }

    @Override
    public boolean getEmpByName(String empName) {
        // 创建 EmployeeExample 对象，此查询方法需要
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        // 调用此方法拼装条件，使查询的员工姓名必须等于传进来的值
        criteria.andEmpNameEqualTo(empName);
        // 根据用户名查询数据库中是否有数据，有则返回大于 0 的数，没有则返回 0
        long count = employeeMapper.countByExample(employeeExample);

        // 返回布尔值，若数据库中有值则返回 true，没有值则返回 false
        return count == 0;
    }

    @Override
    public Employee getEmp(Integer id) {
        // 根据主键查询
        return employeeMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateEmp(Employee employee) {
        // 根据主键进行有选择的更新
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    @Override
    public void deleteEmp(Integer id) {
        // 根据主键删除
        employeeMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatch(List<Integer> del_ids) {
        // 创建 EmployeeExample 对象，此查询方法需要
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        // 拼装后的语句为：delete from xxx where emp_id in(1,2,3)
        // 调用此方法拼装条件，使查询的员工 id 必须等于传进来的值
        criteria.andEmpIdIn(del_ids);
        // 根据主键进行有选择的删除
        employeeMapper.deleteByExample(employeeExample);
    }
}
