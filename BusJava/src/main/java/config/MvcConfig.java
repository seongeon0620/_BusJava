package config;

import static config.DbConfig.dataSource;

import org.springframework.context.annotation.*;
import org.springframework.web.servlet.config.annotation.*;
import dao.*;
import service.*;

@Configuration
@EnableWebMvc
public class MvcConfig implements WebMvcConfigurer {
	
	@Bean
	public IndexDao indexDao() {
		return new IndexDao(dataSource());
	}
	
	@Bean
	public IndexSvc indexSvc() {
		IndexSvc indexSvc = new IndexSvc();
		indexSvc.setIndexDao(indexDao());
		return indexSvc;
	}
	
	public void configureDefalultServletHandling(DefaultServletHandlerConfigurer configurer) {
		configurer.enable();
	}
	
	public void configureViewResolvers(ViewResolverRegistry registry) {
		registry.jsp("/WEB-INF/view/", ".jsp");
	}

}
