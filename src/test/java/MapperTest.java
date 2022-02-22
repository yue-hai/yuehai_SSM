import com.yuehai.ssm.bean.Employee;
import com.yuehai.ssm.dao.DepartmentMapper;
import com.yuehai.ssm.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;


/**
 * 测试dao层的工作
 * @author lfy
 * 推荐Spring的项目就可以使用Spring的单元测试，可以自动注入我们需要的组件
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration指定Spring配置文件的位置
 * 3、直接autowired要使用的组件即可
 */
// 表示使用 spring 的测试
@RunWith(SpringJUnit4ClassRunner.class)
// 加载 spring 配置文件
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {

    // 自动注入，根据类型注入
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    // 测试
    @Test
    public void testCRUD(){

        // 1、查询
//        Employee emp = employeeMapper.selectByPrimaryKey(1);
//        Employee emp2 = employeeMapper.selectByPrimaryKeyWithDept(1);
        List<Employee> emp3 = employeeMapper.selectByExampleWithDept(null);
        System.out.println(emp3);

        // 2、插入几个部门
//		departmentMapper.insertSelective(new Department(null, "开发部"));
//		departmentMapper.insertSelective(new Department(null, "测试部"));

        // 3、生成员工数据，测试员工插入
//        employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@yuehai.com", 1));

        // 4、批量插入多个员工；批量，使用可以执行批量操作的 sqlSession
//        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//        for(int i = 0;i<1000;i++){
//            // UUID.randomUUID().toString().substring(0,5)：生成一个 UUID，取前 5 位
//            String uid = UUID.randomUUID().toString().substring(0,5) + i;
//            mapper.insertSelective(new Employee(null,uid, "M", uid+"@yuehai.com", 4));
//        }
//        System.out.println("批量添加完成");

    }
}
