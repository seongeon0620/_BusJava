package config;

import org.springframework.jdbc.datasource.*;			//트랜잭션 추가
import org.springframework.transaction.*;				//트랜잭션 추가
import org.springframework.transaction.annotation.*;	//트랜잭션 추가
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
@EnableTransactionManagement 
public class MemberConfig {
	@Bean
	public MemberDao memberDao() {
		return new MemberDao(dataSource());
	}
	
	@Bean
	public MemberSvc memberSvc() {
		MemberSvc memberSvc = new MemberSvc();
		memberSvc.setMemberDao(memberDao());
		return memberSvc;
	}
}
