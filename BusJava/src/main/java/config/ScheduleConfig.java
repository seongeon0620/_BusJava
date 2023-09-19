package config;

import org.apache.tomcat.jdbc.pool.*;
import org.springframework.context.annotation.*;
import controller.*;
import dao.*;
import service.*;
import vo.*;
import static config.DbConfig.*;

public class ScheduleConfig {
	
	@Bean
	public ScheduleDao scheduleDao() {
		return new ScheduleDao(dataSource());
	}
	
	@Bean
	public ScheduleSvc scheduleSvc() {
		ScheduleSvc scheduleSvc = new ScheduleSvc();
		scheduleSvc.setScheduleDao(scheduleDao());
		return scheduleSvc;
	}
}
