package config;

import static config.DbConfig.dataSource;

import org.apache.tomcat.jdbc.pool.*;
import org.springframework.context.annotation.*;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import controller.TicketCtrl;

import org.springframework.beans.factory.annotation.*;
import dao.*;
import service.*;

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
	public IndexDao indexDao() {
		return new IndexDao(dataSource());
	}

	@Bean
	public IndexSvc indexSvc() {
		IndexSvc indexSvc = new IndexSvc();
		indexSvc.setIndexDao(indexDao());
		return indexSvc;
	}
	
	
	@Bean
	public TerminalDao terminalDao() {
		return new TerminalDao(dataSource());
	}
	
	@Bean
	public TerminalSvc terminalSvc() {
		TerminalSvc terminalSvc = new TerminalSvc();
		terminalSvc.setTerminalDao(terminalDao());
		return terminalSvc;
	}
	
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
	
	@Bean
	public SalesDao salesDao() {
		return new SalesDao(dataSource());
	}

	@Bean
	public SalesSvc salesSvc() {
		SalesSvc salesSvc = new SalesSvc();
		salesSvc.setSalesDao(salesDao());
		return salesSvc;
	}
	
	@Bean
	public CsNoticeDao csNoticeDao() {
		return new CsNoticeDao(dataSource());
	}
	
	@Bean
	public CsNoticeSvc csNoticeSvc() {
		CsNoticeSvc csNoticeSvc = new CsNoticeSvc();
		csNoticeSvc.setCsNoticeDao(csNoticeDao());
		return csNoticeSvc;
	}
	
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
	
	@Bean
	public BannerDao bannerDao() {
		return new BannerDao(dataSource());
	}
	
	@Bean
	public BannerSvc bannerSvc() {
		BannerSvc bannerSvc = new BannerSvc();
		bannerSvc.setBannerDao(bannerDao());
		return bannerSvc;
	}
	
	@Bean
	public TicketDao ticketDao() {
		return new TicketDao(dataSource());
	}
	
	@Bean
	public TicketSvc ticketSvc() {
		TicketSvc ticketSvc = new TicketSvc();
		ticketSvc.setTicketDao(ticketDao());
		return ticketSvc;
	}
	
	@Bean
	public PlatformTransactionManager transactionManager() {
		DataSourceTransactionManager tm = new DataSourceTransactionManager();
		tm.setDataSource(dataSource());
		return tm;
	}
	
	@Bean
	public LostDao lostDao() {
		return new LostDao(dataSource());
	}
	
	@Bean
	public LostSvc lostSvc() {
		LostSvc lostSvc = new LostSvc();
		lostSvc.setLostDao(lostDao());
		return lostSvc;
	}
	
	
}
