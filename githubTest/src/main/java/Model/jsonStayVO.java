package Model;

import java.util.ArrayList;

public class jsonStayVO {
	
	private ArrayList<StayRvDTO> stay_rv_select;
	private StayAvg1DTO avg1;
	private StayAvg2DTO avg2;
	private StayAvg3DTO avg3;
	private StayAvg4DTO avg4;
	private StayAvg5DTO avg5;
	public jsonStayVO(ArrayList<StayRvDTO> stay_rv_select, StayAvg1DTO avg1, StayAvg2DTO avg2, StayAvg3DTO avg3,
			StayAvg4DTO avg4, StayAvg5DTO avg5) {
		super();
		this.stay_rv_select = stay_rv_select;
		this.avg1 = avg1;
		this.avg2 = avg2;
		this.avg3 = avg3;
		this.avg4 = avg4;
		this.avg5 = avg5;
	}
	public ArrayList<StayRvDTO> getStay_rv_select() {
		return stay_rv_select;
	}
	public void setStay_rv_select(ArrayList<StayRvDTO> stay_rv_select) {
		this.stay_rv_select = stay_rv_select;
	}
	public StayAvg1DTO getAvg1() {
		return avg1;
	}
	public void setAvg1(StayAvg1DTO avg1) {
		this.avg1 = avg1;
	}
	public StayAvg2DTO getAvg2() {
		return avg2;
	}
	public void setAvg2(StayAvg2DTO avg2) {
		this.avg2 = avg2;
	}
	public StayAvg3DTO getAvg3() {
		return avg3;
	}
	public void setAvg3(StayAvg3DTO avg3) {
		this.avg3 = avg3;
	}
	public StayAvg4DTO getAvg4() {
		return avg4;
	}
	public void setAvg4(StayAvg4DTO avg4) {
		this.avg4 = avg4;
	}
	public StayAvg5DTO getAvg5() {
		return avg5;
	}
	public void setAvg5(StayAvg5DTO avg5) {
		this.avg5 = avg5;
	}
	
	
	
	
	

}
