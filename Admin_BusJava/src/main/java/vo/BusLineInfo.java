package vo;

import java.util.*;

public class BusLineInfo {
	private int bl_idx, bt_sidx, bt_eidx, bl_adult;
	private String bl_type, bl_status, bt_name;
	private List<BusScheduleInfo> busScheduleInfo;

	
	public BusLineInfo(int bl_idx, int bt_sidx, int bt_eidx, int bl_adult, String bl_type, String bl_status, String bt_name, 
			List<BusScheduleInfo> busScheduleInfo) {
		this.bl_idx = bl_idx;
		this.bt_sidx = bt_sidx;
		this.bt_eidx = bt_eidx;
		this.bl_adult = bl_adult;
		this.bl_type = bl_type;
		this.bl_status = bl_status;
		this.bt_name = bt_name;
		this.busScheduleInfo = busScheduleInfo;
	}
	public List<BusScheduleInfo> getBusScheduleInfo() {
		return busScheduleInfo;
	}
	public void setBusScheduleInfo(List<BusScheduleInfo> busScheduleInfo) {
		this.busScheduleInfo = busScheduleInfo;
	}
	
	public int getBl_idx() {
		return bl_idx;
	}
	public void setBl_idx(int bl_idx) {
		this.bl_idx = bl_idx;
	}
	public int getBt_sidx() {
		return bt_sidx;
	}
	public void setBt_sidx(int bt_sidx) {
		this.bt_sidx = bt_sidx;
	}
	public int getBt_eidx() {
		return bt_eidx;
	}
	public void setBt_eidx(int bt_eidx) {
		this.bt_eidx = bt_eidx;
	}
	public int getBl_adult() {
		return bl_adult;
	}
	public void setBl_adult(int bl_adult) {
		this.bl_adult = bl_adult;
	}
	public String getBl_type() {
		return bl_type;
	}
	public void setBl_type(String bl_type) {
		this.bl_type = bl_type;
	}
	public String getBl_status() {
		return bl_status;
	}
	public void setBl_status(String bl_status) {
		this.bl_status = bl_status;
	}
	public String getBt_name() {
		return bt_name;
	}
	public void setBt_name(String bt_name) {
		this.bt_name = bt_name;
	}
	
	
}
