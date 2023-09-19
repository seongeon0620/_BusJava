package config;

import java.util.Properties;
import org.springframework.beans.factory.annotation.Autowired;
import org.apache.tomcat.jdbc.pool.*;
import org.springframework.context.annotation.*;
import controller.*;
import dao.*;
import service.*;
import vo.*;
import static config.DbConfig.*;

@Configuration
public class LoginConfig {
	@Bean
	public LoginDao loginDao() {
		return new LoginDao(dataSource());
	}
	
	@Bean
	public LoginSvc loginSvc() {
		LoginSvc loginSvc = new LoginSvc();
		loginSvc.setLoginDao(loginDao());
		return loginSvc;
	}
	
}
