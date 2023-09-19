package vo;

public class ArriveInfo {
	// bh_name(출발터미널 이름-FR_TER_NAM), stime(출발시각-TIM_TIM), etime(도착예정시간-V_NEED_TIM), com(고속사-CORNAM), num(차량번호-CNO), grade(등급-BUS_GRA), 
	// ltime(남은시간-RMN_TIM), status(상태-STG_NAM)
	private String bh_name, stime, etime, com, status, num, grade, ltime;

	public String getBh_name() {
		return bh_name;
	}

	public void setBh_name(String bh_name) {
		this.bh_name = bh_name;
	}

	public String getStime() {
		return stime;
	}

	public void setStime(String stime) {
		this.stime = stime;
	}

	public String getEtime() {
		return etime;
	}

	public void setEtime(String etime) {
		this.etime = etime;
	}

	public String getCom() {
		return com;
	}

	public void setCom(String com) {
		this.com = com;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getLtime() {
		return ltime;
	}

	public void setLtime(String ltime) {
		this.ltime = ltime;
	}
	
}
