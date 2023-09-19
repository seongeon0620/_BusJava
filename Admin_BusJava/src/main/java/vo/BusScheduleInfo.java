package vo;

import java.util.*;

public class BusScheduleInfo {
	private int bs_idx, bc_idx, bi_idx;
	private String bs_stime, bs_etime, bs_date, bi_level, bc_name, bi_num;
	
	public BusScheduleInfo(int bs_idx, int bc_idx, int bi_idx, String bi_num, String bs_stime, String bs_etime, String bs_date, String bi_level,
			String bc_name) {
		this.bs_idx = bs_idx;
		this.bc_idx = bc_idx;
		this.bi_idx = bi_idx;
		this.bi_num = bi_num;
		this.bs_stime = bs_stime;
		this.bs_etime = bs_etime;
		this.bs_date = bs_date;
		this.bi_level = bi_level;
		this.bc_name = bc_name;
	}
	
	public int getBs_idx() {
		return bs_idx;
	}
	public void setBs_idx(int bs_idx) {
		this.bs_idx = bs_idx;
	}
	
	
	public int getBi_idx() {
		return bi_idx;
	}

	public void setBi_idx(int bi_idx) {
		this.bi_idx = bi_idx;
	}

	public String getBi_num() {
		return bi_num;
	}

	public void setBi_num(String bi_num) {
		this.bi_num = bi_num;
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
	public int getBc_idx() {
		return bc_idx;
	}
	public void setBc_idx(int bc_idx) {
		this.bc_idx = bc_idx;
	}
	public String getBi_level() {
		return bi_level;
	}
	public void setBi_level(String bi_level) {
		this.bi_level = bi_level;
	}
	public String getBc_name() {
		return bc_name;
	}
	public void setBc_name(String bc_name) {
		this.bc_name = bc_name;
	}
	
	
}
