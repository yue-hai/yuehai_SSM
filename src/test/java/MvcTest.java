import com.github.pagehelper.PageInfo;
import com.yuehai.ssm.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用 Spring 测试模块提供的测试请求功能，测试 curd 请求的正确性
 * Spring4 测试的时候，需要servlet3.0的支持
 */
@RunWith(SpringJUnit4ClassRunner.class)
// 有此注解就可以使用 wbe ioc 容器：WebApplicationContext
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:springMVC.xml"})
public class MvcTest {

    // 传入Springmvc的ioc
    @Autowired
    WebApplicationContext context;
    // 虚拟 mvc 请求，获取处理结果。
    MockMvc mockMvc;
    // 创建 MockMvc
    @Before
    public void initMokcMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        /**
         * 模拟请求拿到返回值
         * get("/getEmps")：模拟 get 请求，请求路径为 /emps
         * param("pn", "1")：请求参数，参数1为名，参数2为值
         * andReturn()：拿到请求的返回值
         */
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/getEmps").param("pn", "1")).andReturn();

        // 请求成功以后，请求域中会有 pageInfo，我们可以取出 pageInfo 进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页码："+pi.getPageNum());
        System.out.println("总页码："+pi.getPages());
        System.out.println("总记录数："+pi.getTotal());
        System.out.println("在页面需要连续显示的页码");
        int[] nums = pi.getNavigatepageNums();
        for (int i : nums) {
            System.out.print(" "+i);
        }
        System.out.println();

        //获取员工数据
        List<Employee> list = pi.getList();
        for (Employee employee : list) {
            System.out.println("ID："+employee.getEmpId()+"==>Name:"+employee.getEmpName());
        }

    }
}
