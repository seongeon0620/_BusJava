package vo;

public class UserResourceInfo {
	private String action, date, ri_fr, ri_to, line_type, coupon_id;
	private int cnt;	// 쿠폰, 스탬프의 갯수
	public String getAction() {
		return action;
	}
	public void setAction(String action) {
		this.action = action;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
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
	public String getLine_type() {
		return line_type;
	}
	public void setLine_type(String line_type) {
		this.line_type = line_type;
	}
	
	public String getCoupon_id() {
		return coupon_id;
	}
	public void setCoupon_id(String coupon_id) {
		this.coupon_id = coupon_id;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
}
