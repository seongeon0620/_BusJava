package vo;

import java.sql.ResultSet;
import java.util.List;

public class paymoneyInfo {
	private String ri_idx, ri_fr, ri_to, ri_line_type, pd_payment, pd_type, pd_date, ph_payment, ph_date;
	private int ph_idx, pd_idx, pd_real_price, pd_total_price, ph_real_price, ph_pmoney;
	
	public paymoneyInfo(String ri_fr, String ri_to, String ri_line_type, String pd_date, int pd_real_price) {
		super();
		this.ri_fr = ri_fr;
		this.ri_to = ri_to;
		this.ri_line_type = ri_line_type;
		this.pd_date = pd_date;
		this.pd_real_price = pd_real_price;
	}
	
	
	
	public paymoneyInfo(String ph_date, int ph_real_price, int ph_pmoney) {
		super();
		this.ph_date = ph_date;
		this.ph_real_price = ph_real_price;
		this.ph_pmoney = ph_pmoney;
	}



	public String getRi_idx() {
		return ri_idx;
	}
	public void setRi_idx(String ri_idx) {
		this.ri_idx = ri_idx;
	}
	public String getPd_payment() {
		return pd_payment;
	}
	public void setPd_payment(String pd_payment) {
		this.pd_payment = pd_payment;
	}
	public String getPd_type() {
		return pd_type;
	}
	public void setPd_type(String pd_type) {
		this.pd_type = pd_type;
	}
	public String getPd_date() {
		return pd_date;
	}
	public void setPd_date(String pd_date) {
		this.pd_date = pd_date;
	}
	public String getPh_payment() {
		return ph_payment;
	}
	public void setPh_payment(String ph_payment) {
		this.ph_payment = ph_payment;
	}
	public String getPh_date() {
		return ph_date;
	}
	public void setPh_date(String ph_date) {
		this.ph_date = ph_date;
	}
	public int getPh_idx() {
		return ph_idx;
	}
	public void setPh_idx(int ph_idx) {
		this.ph_idx = ph_idx;
	}
	public int getPd_idx() {
		return pd_idx;
	}
	public void setPd_idx(int pd_idx) {
		this.pd_idx = pd_idx;
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
	public int getPh_real_price() {
		return ph_real_price;
	}
	public void setPh_real_price(int ph_real_price) {
		this.ph_real_price = ph_real_price;
	}
	public int getPh_pmoney() {
		return ph_pmoney;
	}
	public void setPh_pmoney(int ph_pmoney) {
		this.ph_pmoney = ph_pmoney;
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
	public String getRi_line_type() {
		return ri_line_type;
	}
	public void setRi_line_type(String ri_line_type) {
		this.ri_line_type = ri_line_type;
	}


	
	
}


































