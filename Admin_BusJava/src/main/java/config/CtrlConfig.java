package config;

import org.springframework.beans.factory.annotation.*;
import org.springframework.context.annotation.*;
import controller.*;
import service.*;

@Configuration
public class CtrlConfig {
	@Autowired
	private IndexSvc indexSvc;
	
	@Autowired
	private TerminalSvc terminalSvc;
	
	@Autowired
	private LoginSvc loginSvc;
	
	@Autowired
	private MemberSvc memberSvc;
	
	@Autowired
	private SalesSvc salesSvc;
	
	@Autowired
	private CsNoticeSvc csNoticeSvc;
	
	@Autowired
	private FaqListSvc faqListSvc;
	
	@Autowired
	private BannerSvc bannerSvc;

	@Autowired
	private TicketSvc ticketSvc;
	
	@Autowired
	private LostSvc lostSvc;
	
	@Bean
	public IndexCtrl indexCtrl() {
		IndexCtrl indexCtrl = new IndexCtrl();
		indexCtrl.setIndexSvc(indexSvc);
		return indexCtrl;
	}
	
	@Bean
	public LoginCtrl loginCtrl() {
		LoginCtrl loginCtrl = new LoginCtrl();
		loginCtrl.setLoginSvc(loginSvc);
		return loginCtrl;
	}
	
	@Bean
	public TerminalCtrl terminalCtrl() {
		TerminalCtrl terminalCtrl = new TerminalCtrl();
		terminalCtrl.setTerminalSvc(terminalSvc);
		return terminalCtrl;
	}
	
	@Bean
	public MemberCtrl memberCtrl() {
		MemberCtrl memberCtrl = new MemberCtrl();
		memberCtrl.setMemberSvc(memberSvc);
		return memberCtrl;
	}
	
	@Bean
	public SalesCtrl salesCtrl() {
		SalesCtrl salesCtrl = new SalesCtrl();
		salesCtrl.setSalesSvc(salesSvc);
		return salesCtrl;
	}
	
	@Bean
	public CsNoticeCtrl csNoticeCtrl() {
		CsNoticeCtrl csNoticeCtrl = new CsNoticeCtrl();
		csNoticeCtrl.setCsNoticeSvc(csNoticeSvc);
		return csNoticeCtrl;
	}
	
	@Bean
    public FaqListCtrl faqListCtrl() {
		FaqListCtrl faqListCtrl = new FaqListCtrl();
		faqListCtrl.setFaqListSvc(faqListSvc);
		return faqListCtrl;
    }
	
	@Bean
	public BannerCtrl bannerCtrl() {
		BannerCtrl bannerCtrl = new BannerCtrl();
		bannerCtrl.setBannerSvc(bannerSvc);
		return bannerCtrl;
	}
	
	@Bean
	public TicketCtrl ticketCtrl() {
		TicketCtrl ticket = new TicketCtrl();
		ticket.setTicketSvc(ticketSvc);
		return ticket;
	}
	
	@Bean
	public LostCtrl lostCtrl() {
		LostCtrl lostCtrl = new LostCtrl();
		lostCtrl.setLostSvc(lostSvc);
		return lostCtrl;
	}
}

