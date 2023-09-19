package vo;

import java.util.*;

public class LineInfo {
// 노선의 정보를 담고있는 인스턴스 (+ 출발지, 도착지 : sname, ename / + 출발지역, 도착지역 : sarea, earea)
	private int bl_idx, bt_sidx, bt_eidx, bl_adult;
	private String sname, ename, sarea, earea, bl_type, bl_status;
	private List<ScheduleInfo> scheduleInfo;
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
	public String getSname() {
		return sname;
	}
	public void setSname(String sname) {
		this.sname = sname;
	}
	public String getEname() {
		return ename;
	}
	public void setEname(String ename) {
		this.ename = ename;
	}
	public String getSarea() {
		return sarea;
	}
	public void setSarea(String sarea) {
		this.sarea = sarea;
	}
	public String getEarea() {
		return earea;
	}
	public void setEarea(String earea) {
		this.earea = earea;
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
	
	
	
	
}
