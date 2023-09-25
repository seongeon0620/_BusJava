package config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.*;
import controller.*;
import service.*;

@Configuration
public class CtrlConfig {
	@Autowired
	private MemberSvc memberSvc;
	
	@Autowired
	private TicketingSvc ticketingSvc;
	
	@Autowired
	private ScheduleSvc scheduleSvc;
	
	@Autowired
	private TravelSvc travelSvc;
	
	@Autowired
	private FaqListSvc faqListSvc;
	
	@Autowired
	private LoginSvc loginSvc;
	
	@Autowired
	private CsNotiSvc csNotiSvc;
	
	@Autowired
	private IndexSvc indexSvc;
	
	@Autowired
	private CsLostSvc csLostSvc;
	
	@Bean
	public IndexCtrl indexCtrl() {
		IndexCtrl indexCtrl = new IndexCtrl();
		indexCtrl.setIndexSvc(indexSvc);
		return indexCtrl;
	}
	
	@Bean
	public MemberCtrl memberCtrl() {
		MemberCtrl memberCtrl = new MemberCtrl();
		memberCtrl.setMemberSvc(memberSvc);
		return memberCtrl;
	}
	
	@Bean
	public TicketingCtrl ticketingCtrl() {
		TicketingCtrl ticketingCtrl = new TicketingCtrl();
		ticketingCtrl.setTicketingSvc(ticketingSvc);
		return ticketingCtrl;
	}

	@Bean
	public ScheduleCtrl scheduleCtrl() {
		ScheduleCtrl scheduleCtrl = new ScheduleCtrl();
		scheduleCtrl.setScheduleSvc(scheduleSvc);
		return scheduleCtrl;
	}
	
	@Bean
	public TravelCtrl travelCtrl() {
		TravelCtrl travelCtrl = new TravelCtrl();
		travelCtrl.setTravelSvc(travelSvc);
		return travelCtrl;
	}

	@Bean
    public FaqListCtrl faqListCtrl() {
		FaqListCtrl faqListCtrl = new FaqListCtrl();
		faqListCtrl.setFaqListSvc(faqListSvc);
		return faqListCtrl;
    }
	
	@Bean
	public LoginCtrl loginCtrl() {
		LoginCtrl loginCtrl = new LoginCtrl();
		loginCtrl.setLoginSvc(loginSvc);
		return loginCtrl;
	}
	
	@Bean
	public CsNotiCtrl csNotiCtrl() {
		CsNotiCtrl csNotiCtrl = new CsNotiCtrl();
		csNotiCtrl.setCsNotiSvc(csNotiSvc);
		return csNotiCtrl;
	}
	
	@Bean
	public CsLostCtrl csLostCtrl() {
		CsLostCtrl csLostCtrl = new CsLostCtrl();
		csLostCtrl.setCsLostSvc(csLostSvc);
		return csLostCtrl;
	}
}
