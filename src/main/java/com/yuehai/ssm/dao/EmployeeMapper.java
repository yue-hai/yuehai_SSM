package com.yuehai.ssm.dao;

import com.yuehai.ssm.bean.Employee;
import com.yuehai.ssm.bean.EmployeeExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface EmployeeMapper {
    // 按照条件进行统计
    long countByExample(EmployeeExample example);
    // 按照条件删除
    int deleteByExample(EmployeeExample example);
    // 按照主键删除
    int deleteByPrimaryKey(Integer empId);
    // 插入
    int insert(Employee record);
    // 有选择的插入，传递过来什么参数就插入什么参数
    int insertSelective(Employee record);
    // 按照条件查询
    List<Employee> selectByExample(EmployeeExample example);
    // 按照主键查询
    Employee selectByPrimaryKey(Integer empId);
    // 有选择的更新，传递过来什么参数就更新什么参数
    int updateByExampleSelective(@Param("record") Employee record, @Param("example") EmployeeExample example);
    // 按照条件更新，更新全字段
    int updateByExample(@Param("record") Employee record, @Param("example") EmployeeExample example);
    // 按照主键有选择的更新，传递过来什么参数就更新什么参数
    int updateByPrimaryKeySelective(Employee record);
    // 按照主键更新，更新全字段
    int updateByPrimaryKey(Employee record);

    // 自己写的方法

    // 按照条件查询，联合查询部门表
    List<Employee> selectByExampleWithDept(EmployeeExample example);
    // 按照主键查询，联合查询部门表
    Employee selectByPrimaryKeyWithDept(Integer empId);
}