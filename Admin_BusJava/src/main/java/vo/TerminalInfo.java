package vo;

public class TerminalInfo {
	private int bs_code;
	private double bh_lat, bh_lon;
	private String bh_code, bh_name, bh_area, bh_addr, bh_status;
	
	public int getBs_code() {
		return bs_code;
	}
	public void setBs_code(int bs_code) {
		this.bs_code = bs_code;
	}
	public double getBh_lat() {
		return bh_lat;
	}
	public void setBh_lat(double bh_lat) {
		this.bh_lat = bh_lat;
	}
	public double getBh_lon() {
		return bh_lon;
	}
	public void setBh_lon(double bh_lon) {
		this.bh_lon = bh_lon;
	}
	
	public String getBh_code() {
		return bh_code;
	}
	public void setBh_code(String bh_code) {
		this.bh_code = bh_code;
	}
	public String getBh_name() {
		return bh_name;
	}
	public void setBh_name(String bh_name) {
		this.bh_name = bh_name;
	}
	public String getBh_area() {
		return bh_area;
	}
	public void setBh_area(String bh_area) {
		this.bh_area = bh_area;
	}
	public String getBh_addr() {
		return bh_addr;
	}
	public void setBh_addr(String bh_addr) {
		this.bh_addr = bh_addr;
	}
	public String getBh_status() {
		return bh_status;
	}
	public void setBh_status(String bt_status) {
		this.bh_status = bt_status;
	}
	
}
