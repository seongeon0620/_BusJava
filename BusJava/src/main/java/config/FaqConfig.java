package config;

import org.apache.tomcat.jdbc.pool.*;
import org.springframework.context.annotation.*;
import controller.*;
import dao.*;
import service.*;
import vo.*;
import static config.DbConfig.*;

@Configuration
public class FaqConfig {
	@Bean
	public FaqListDao faqListDao() {
		return new FaqListDao(dataSource());
	}
	
	@Bean
	public FaqListSvc faqListSvc() {
		FaqListSvc faqListSvc = new FaqListSvc();
		faqListSvc.setFaqListDao(faqListDao());
		return faqListSvc;
	}
}
