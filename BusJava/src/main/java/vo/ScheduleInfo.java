package vo;

public class ScheduleInfo {
	private int adult_fee, student_fee, child_fee, total_seat, left_seat, route_sq, dispatch_sq;
	private String fr_time, to_time, ri_com, level, route_id, dispatch_date;
	public int getAdult_fee() {
		return adult_fee;
	}
	public void setAdult_fee(int adult_fee) {
		this.adult_fee = adult_fee;
	}
	public int getStudent_fee() {
		return student_fee;
	}
	public void setStudent_fee(int student_fee) {
		this.student_fee = student_fee;
	}
	public int getChild_fee() {
		return child_fee;
	}
	public void setChild_fee(int child_fee) {
		this.child_fee = child_fee;
	}
	public int getTotal_seat() {
		return total_seat;
	}
	public void setTotal_seat(int total_seat) {
		this.total_seat = total_seat;
	}
	public int getLeft_seat() {
		return left_seat;
	}
	public void setLeft_seat(int left_seat) {
		this.left_seat = left_seat;
	}
	public int getRoute_sq() {
		return route_sq;
	}
	public void setRoute_sq(int route_sq) {
		this.route_sq = route_sq;
	}
	public int getDispatch_sq() {
		return dispatch_sq;
	}
	public void setDispatch_sq(int dispatch_sq) {
		this.dispatch_sq = dispatch_sq;
	}
	public String getFr_time() {
		return fr_time;
	}
	public void setFr_time(String fr_time) {
		this.fr_time = fr_time;
	}
	public String getTo_time() {
		return to_time;
	}
	public void setTo_time(String to_time) {
		this.to_time = to_time;
	}
	public String getRi_com() {
		return ri_com;
	}
	public void setRi_com(String ri_com) {
		this.ri_com = ri_com;
	}
	public String getLevel() {
		return level;
	}
	public void setLevel(String level) {
		this.level = level;
	}
	public String getRoute_id() {
		return route_id;
	}
	public void setRoute_id(String route_id) {
		this.route_id = route_id;
	}
	public String getDispatch_date() {
		return dispatch_date;
	}
	public void setDispatch_date(String dispatch_date) {
		this.dispatch_date = dispatch_date;
	}
	
}