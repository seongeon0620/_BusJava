package config;

import org.apache.tomcat.jdbc.pool.*;
import org.springframework.context.annotation.*;
import controller.*;
import dao.*;
import service.*;
import vo.*;
import static config.DbConfig.*;
import org.springframework.jdbc.datasource.*;	// 트랜잭션 추가
import org.springframework.transaction.*;	 // 트랜잭션 추가
import org.springframework.transaction.annotation.*;	// 트랜잭션 추가


@Configuration
@EnableTransactionManagement
public class TicketingConfig {
	
	@Bean
	public TicketingDao ticketingDao() {
		return new TicketingDao(dataSource());
	}
	
	@Bean
	public TicketingSvc ticketingSvc() {
		TicketingSvc ticketingSvc = new TicketingSvc();
		ticketingSvc.setTicketingDao(ticketingDao());
		return ticketingSvc;
	}
}
