package vo;

public class SalesInfo {
	private String lineType, fromName, toName;
	private int cardFee, bankFee, easyFee, totalFee, count_schedule;
	private double cardRatio, bankRatio, easyRatio;
	public String getLineType() {
		return lineType;
	}
	public void setLineType(String lineType) {
		this.lineType = lineType;
	}
	public String getFromName() {
		return fromName;
	}
	public void setFromName(String fromName) {
		this.fromName = fromName;
	}
	public String getToName() {
		return toName;
	}
	public void setToName(String toName) {
		this.toName = toName;
	}
	public int getCardFee() {
		return cardFee;
	}
	public void setCardFee(int cardFee) {
		this.cardFee = cardFee;
	}
	public int getBankFee() {
		return bankFee;
	}
	public void setBankFee(int bankFee) {
		this.bankFee = bankFee;
	}
	public int getEasyFee() {
		return easyFee;
	}
	public void setEasyFee(int easyFee) {
		this.easyFee = easyFee;
	}
	public int getTotalFee() {
		return totalFee;
	}
	public void setTotalFee(int totalFee) {
		this.totalFee = totalFee;
	}
	public int getCount_schedule() {
		return count_schedule;
	}
	public void setCount_schedule(int count_schedule) {
		this.count_schedule = count_schedule;
	}
	public double getCardRatio() {
		return cardRatio;
	}
	public void setCardRatio(double cardRatio) {
		this.cardRatio = cardRatio;
	}
	public double getBankRatio() {
		return bankRatio;
	}
	public void setBankRatio(double bankRatio) {
		this.bankRatio = bankRatio;
	}
	public double getEasyRatio() {
		return easyRatio;
	}
	public void setEasyRatio(double easyRatio) {
		this.easyRatio = easyRatio;
	}
}
