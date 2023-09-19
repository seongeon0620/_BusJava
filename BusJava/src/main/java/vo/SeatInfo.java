package vo;

public class SeatInfo {
	private int si_idx, bi_idx, si_seat ;
	private String si_isuse, reserved_yn;	// reserved_yn : 해당 좌석의 예매완료 여부. Y : 예매불가능(예매완료) , N : 예매가능 
	public int getSi_idx() {
		return si_idx;
	}
	public void setSi_idx(int si_idx) {
		this.si_idx = si_idx;
	}
	public int getBi_idx() {
		return bi_idx;
	}
	public void setBi_idx(int bi_idx) {
		this.bi_idx = bi_idx;
	}
	public int getSi_seat() {
		return si_seat;
	}
	public void setSi_seat(int si_seat) {
		this.si_seat = si_seat;
	}
	public String getSi_isuse() {
		return si_isuse;
	}
	public void setSi_isuse(String si_isuse) {
		this.si_isuse = si_isuse;
	}
	public String getReserved_yn() {
		return reserved_yn;
	}
	public void setReserved_yn(String reserved_yn) {
		this.reserved_yn = reserved_yn;
	}
	
	
	
}
