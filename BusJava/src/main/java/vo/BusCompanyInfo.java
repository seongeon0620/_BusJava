package vo;

public class BusCompanyInfo {
	private int bc_idx;
	private String bc_name;
	
	public BusCompanyInfo(int bc_idx, String bc_name) {
		super();
		this.bc_idx = bc_idx;
		this.bc_name = bc_name;
	}
	
	public int getBc_idx() {
		return bc_idx;
	}
	public void setBc_idx(int bc_idx) {
		this.bc_idx = bc_idx;
	}
	public String getBc_name() {
		return bc_name;
	}
	public void setBc_name(String bc_name) {
		this.bc_name = bc_name;
	}
	
}
