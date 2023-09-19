package vo;

public class NoticeInfo {
	private int nl_idx, ai_idx, nl_read;
	// 글번호, 어드민 번호, 조회수
	private String nl_title, nl_content, nl_isview, nl_accent, nl_date;
	// 제목, 내용, 파일명, 게시여부, 중요게시여부, 작성일
	
	public int getNl_idx() {
		return nl_idx;
	}
	public void setNl_idx(int nl_idx) {
		this.nl_idx = nl_idx;
	}
	public int getAi_idx() {
		return ai_idx;
	}
	public void setAi_idx(int ai_idx) {
		this.ai_idx = ai_idx;
	}
	public int getNl_read() {
		return nl_read;
	}
	public void setNl_read(int nl_read) {
		this.nl_read = nl_read;
	}
	public String getNl_title() {
		return nl_title;
	}
	public void setNl_title(String nl_title) {
		this.nl_title = nl_title;
	}
	public String getNl_content() {
		return nl_content;
	}
	public void setNl_content(String nl_content) {
		this.nl_content = nl_content;
	}
	public String getNl_isview() {
		return nl_isview;
	}
	public void setNl_isview(String nl_isview) {
		this.nl_isview = nl_isview;
	}
	public String getNl_accent() {
		return nl_accent;
	}
	public void setNl_accent(String nl_accent) {
		this.nl_accent = nl_accent;
	}
	public String getNl_date() {
		return nl_date;
	}
	public void setNl_date(String nl_date) {
		this.nl_date = nl_date;
	}
	
}
