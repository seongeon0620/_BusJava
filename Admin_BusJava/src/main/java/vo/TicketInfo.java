package vo;

import java.util.List;

public class TicketInfo {
	private int ri_acnt, ri_scnt, ri_ccnt, pd_real_price, pd_total_price;
	private String ri_idx, mi_id, ri_line_id, ri_line_type, ri_fr, ri_to, ri_frdate, ri_todate, ri_com, ri_level, ri_status, ri_date;
	private String ri_frtime, ri_totime, pd_payment, pd_date ;
	private List<SeatInfo> SeatInfo;
	
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
	public String getRi_idx() {
		return ri_idx;
	}
	public void setRi_idx(String ri_idx) {
		this.ri_idx = ri_idx;
	}
	public String getMi_id() {
		return mi_id;
	}
	public void setMi_id(String mi_id) {
		this.mi_id = mi_id;
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
	public String getRi_status() {
		return ri_status;
	}
	public void setRi_status(String ri_status) {
		this.ri_status = ri_status;
	}
	public String getRi_date() {
		return ri_date;
	}
	public void setRi_date(String ri_date) {
		this.ri_date = ri_date;
	}
	public List<SeatInfo> getSeatInfo() {
		return SeatInfo;
	}
	public void setSeatInfo(List<SeatInfo> seatInfo) {
		SeatInfo = seatInfo;
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
	public String getRi_frtime() {
		return ri_frtime;
	}
	public void setRi_frtime(String ri_frtime) {
		this.ri_frtime = ri_frtime;
	}
	public String getRi_totime() {
		return ri_totime;
	}
	public void setRi_totime(String ri_totime) {
		this.ri_totime = ri_totime;
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
	
	
	
	
}
