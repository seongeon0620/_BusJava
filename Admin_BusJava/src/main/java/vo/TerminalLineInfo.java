package vo;

import java.util.*;

public class TerminalLineInfo {
	private int bs_idx;
	private String bs_stime, bs_etime, bs_date;
	private List<BusInfo> busInfo;
	private List<BusLineInfo> busLineInfo;
	
	
	public int getBs_idx() {
		return bs_idx;
	}
	public void setBs_idx(int bs_idx) {
		this.bs_idx = bs_idx;
	}
	public String getBs_stime() {
		return bs_stime;
	}
	public void setBs_stime(String bs_stime) {
		this.bs_stime = bs_stime;
	}
	public String getBs_etime() {
		return bs_etime;
	}
	public void setBs_etime(String bs_etime) {
		this.bs_etime = bs_etime;
	}
	public String getBs_date() {
		return bs_date;
	}
	public void setBs_date(String bs_date) {
		this.bs_date = bs_date;
	}
	public List<BusInfo> getBusInfo() {
		return busInfo;
	}
	public void setBusInfo(List<BusInfo> busInfo) {
		this.busInfo = busInfo;
	}
	
	public List<BusLineInfo> getBusLineInfo() {
		return busLineInfo;
	}
	public void setBusLineInfo(List<BusLineInfo> busLineInfo) {
		this.busLineInfo = busLineInfo;
	}
	
	
}
