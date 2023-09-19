package vo;

import java.util.List;

public class BookInfo {
	private int ri_acnt, ri_scnt, ri_ccnt, rd_seat_num, ri_count; 
	private String ri_status, ri_idx, ri_line_id, ri_line_type, ri_fr, ri_to, ri_frdate, ri_todate, ri_com, ri_level, ri_date, ri_frtime, ri_totime;
    private List<SeatInfo> busSeatList;
	/* detail 추가 부분 */
	private String  pd_payment, pd_date;
	private int pd_real_price, pd_total_price;
	/* cancel 추가 부분 */
	private int mi_pmoney, cr_pmoney, cr_pay;
	//private String bt1_sidx, bt2_eidx, pd_payment;
	
	// 애매내열 리스트
	public BookInfo(String ri_idx, String ri_line_type, String ri_fr, String ri_to, String ri_frdate, 
			String ri_status, String ri_frtime, int ri_acnt,int ri_scnt,int ri_ccnt, List<SeatInfo> busSeatList) {
		super();
		this.ri_idx = ri_idx;
		this.ri_line_type = ri_line_type;
		this.ri_fr = ri_fr;
		this.ri_to = ri_to;
		this.ri_frdate = ri_frdate;
		this.ri_status = ri_status;
		this.ri_frtime = ri_frtime;
		this.ri_acnt = ri_acnt;
		this.ri_scnt = ri_scnt;
		this.ri_ccnt = ri_ccnt;
		this.busSeatList = busSeatList;
	}

	
	// 예매상세내역
	public BookInfo(int ri_acnt, int ri_scnt, int ri_ccnt, String ri_status, String ri_idx, String ri_line_type,
			String ri_fr, String ri_to, String ri_frdate, String ri_todate, String ri_com, String ri_level,
			String ri_frtime, String ri_totime, String pd_payment, String pd_date, int pd_real_price, int pd_total_price, List<SeatInfo> busSeatList) {
		super();
		this.ri_acnt = ri_acnt;
		this.ri_scnt = ri_scnt;
		this.ri_ccnt = ri_ccnt;
		this.ri_status = ri_status;
		this.ri_idx = ri_idx;
		this.ri_line_type = ri_line_type;
		this.ri_fr = ri_fr;
		this.ri_to = ri_to;
		this.ri_frdate = ri_frdate;
		this.ri_todate = ri_todate;
		this.ri_com = ri_com;
		this.ri_level = ri_level;
		this.ri_frtime = ri_frtime;
		this.ri_totime = ri_totime;
		this.pd_payment = pd_payment;
		this.pd_date = pd_date;
		this.pd_real_price = pd_real_price;
		this.pd_total_price = pd_total_price;
		this.busSeatList = busSeatList;
	}
	
	

	// 예매 취소 및 환불
	public BookInfo(String ri_frdate, int pd_real_price, int pd_total_price, String pd_payment , int mi_pmoney, int cr_pmoney, int cr_pay) {
		super();
		this.ri_frdate = ri_frdate;
		this.pd_real_price = pd_real_price;
		this.pd_total_price = pd_total_price;
		this.pd_payment = pd_payment;
		this.mi_pmoney = mi_pmoney;
		this.cr_pmoney = cr_pmoney;
		this.cr_pay = cr_pay;
	}


	public int getRd_seat_num() {
		return rd_seat_num;
	}

	public void setRd_seat_num(int rd_seat_num) {
		this.rd_seat_num = rd_seat_num;
	}

	public int getRi_count() {
		return ri_count;
	}

	public void setRi_count(int ri_count) {
		this.ri_count = ri_count;
	}

	public int getRi_acnt() {
		return ri_acnt;
	}


	public void setRi_acnt(int ri_acnt) {
		this.ri_acnt = ri_acnt;
	}

	public int getRi_scnt() {
		return ri_scnt;
	}

	public void setRi_scnt(int ri_scnt) {
		this.ri_scnt = ri_scnt;
	}

	public int getRi_ccnt() {
		return ri_ccnt;
	}

	public void setRi_ccnt(int ri_ccnt) {
		this.ri_ccnt = ri_ccnt;
	}

	public String getRi_status() {
		return ri_status;
	}

	public void setRi_status(String ri_status) {
		this.ri_status = ri_status;
	}

	public String getRi_idx() {
		return ri_idx;
	}

	public void setRi_idx(String ri_idx) {
		this.ri_idx = ri_idx;
	}

	public String getRi_line_id() {
		return ri_line_id;
	}

	public void setRi_line_id(String ri_line_id) {
		this.ri_line_id = ri_line_id;
	}

	public String getRi_line_type() {
		return ri_line_type;
	}

	public void setRi_line_type(String ri_line_type) {
		this.ri_line_type = ri_line_type;
	}

	public String getRi_fr() {
		return ri_fr;
	}

	public void setRi_fr(String ri_fr) {
		this.ri_fr = ri_fr;
	}

	public String getRi_to() {
		return ri_to;
	}

	public void setRi_to(String ri_to) {
		this.ri_to = ri_to;
	}

	public String getRi_frdate() {
		return ri_frdate;
	}

	public void setRi_frdate(String ri_frdate) {
		this.ri_frdate = ri_frdate;
	}

	public String getRi_todate() {
		return ri_todate;
	}

	public void setRi_todate(String ri_todate) {
		this.ri_todate = ri_todate;
	}

	public String getRi_com() {
		return ri_com;
	}

	public void setRi_com(String ri_com) {
		this.ri_com = ri_com;
	}

	public String getRi_level() {
		return ri_level;
	}

	public void setRi_level(String ri_level) {
		this.ri_level = ri_level;
	}

	public String getRi_date() {
		return ri_date;
	}

	public void setRi_date(String ri_date) {
		this.ri_date = ri_date;
	}

	public List<SeatInfo> getBusSeatList() {
		return busSeatList;
	}

	public void setBusSeatList(List<SeatInfo> busSeatList) {
		this.busSeatList = busSeatList;
	}

	public String getRi_totime() {
		return ri_totime;
	}

	public void setRi_totime(String ri_totime) {
		this.ri_totime = ri_totime;
	}

	public String getRi_frtime() {
		return ri_frtime;
	}
	
	public void setRi_frtime(String ri_frtime) {
		this.ri_frtime = ri_frtime;
	}

	public String getPd_payment() {
		return pd_payment;
	}

	public void setPd_payment(String pd_payment) {
		this.pd_payment = pd_payment;
	}

	public String getPd_date() {
		return pd_date;
	}

	public void setPd_date(String pd_date) {
		this.pd_date = pd_date;
	}

	public int getPd_real_price() {
		return pd_real_price;
	}

	public void setPd_real_price(int pd_real_price) {
		this.pd_real_price = pd_real_price;
	}

	public int getPd_total_price() {
		return pd_total_price;
	}

	public void setPd_total_price(int pd_total_price) {
		this.pd_total_price = pd_total_price;
	}


	public int getMi_pmoney() {
		return mi_pmoney;
	}


	public void setMi_pmoney(int mi_pmoney) {
		this.mi_pmoney = mi_pmoney;
	}


	public int getCr_pmoney() {
		return cr_pmoney;
	}


	public void setCr_pmoney(int cr_pmoney) {
		this.cr_pmoney = cr_pmoney;
	}


	public int getCr_pay() {
		return cr_pay;
	}


	public void setCr_pay(int cr_pay) {
		this.cr_pay = cr_pay;
	}

	
	
	
}
