package config;

import org.apache.tomcat.jdbc.pool.*;
import org.springframework.context.annotation.*;
import dao.*;
import service.CsLostSvc;
import service.CsNotiSvc;

@Configuration
public class DbConfig {
	@Bean(destroyMethod = "close")
	public static DataSource dataSource() {
		DataSource ds = new DataSource();
		ds.setDriverClassName("com.mysql.jdbc.Driver");
		ds.setUrl("jdbc:mysql://localhost/busjava?characterEncoding=utf8");
		ds.setUsername("root");
		ds.setPassword("1234");
		ds.setInitialSize(2);
		ds.setMaxActive(10);
		ds.setTestWhileIdle(true);
		ds.setMinEvictableIdleTimeMillis(60000 * 3);
		ds.setMinEvictableIdleTimeMillis(10 * 1000);
		return ds;
	}
	
	@Bean
	public CsNotiDao csNotiDao() {
		return new CsNotiDao(dataSource());
	}
	
	@Bean
	public CsNotiSvc csNotiSvc() {
		CsNotiSvc csNotiSvc = new CsNotiSvc();
		csNotiSvc.setCsNotiDao(csNotiDao());
		return csNotiSvc;
	}
	
	@Bean
	public CsLostDao csLostDao() {
		return new CsLostDao(dataSource());
	}
	
	@Bean
	public CsLostSvc csLostSvc() {
		CsLostSvc csLostSvc = new CsLostSvc();
		csLostSvc.setCsLostDao(csLostDao());
		return csLostSvc;
	}

}
