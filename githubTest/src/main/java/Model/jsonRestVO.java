package Model;

import java.util.ArrayList;

public class jsonRestVO {
	
//	RestDAO rest_dao = new RestDAO();
//	RestRvDAO rest_rv_dao = new RestRvDAO();
	
	
	private ArrayList<RestRvDTO> rest_rv_select;
	private RestAvg1DTO avg1;
	private RestAvg2DTO avg2;
	private RestAvg3DTO avg3;
	private RestAvg4DTO avg4;
	private RestAvg5DTO avg5;
	public jsonRestVO(ArrayList<RestRvDTO> rest_rv_select, RestAvg1DTO avg1, RestAvg2DTO avg2, RestAvg3DTO avg3,
			RestAvg4DTO avg4, RestAvg5DTO avg5) {
		super();
		this.rest_rv_select = rest_rv_select;
		this.avg1 = avg1;
		this.avg2 = avg2;
		this.avg3 = avg3;
		this.avg4 = avg4;
		this.avg5 = avg5;
	}
	public ArrayList<RestRvDTO> getRest_rv_select() {
		return rest_rv_select;
	}
	public void setRest_rv_select(ArrayList<RestRvDTO> rest_rv_select) {
		this.rest_rv_select = rest_rv_select;
	}
	public RestAvg1DTO getAvg1() {
		return avg1;
	}
	public void setAvg1(RestAvg1DTO avg1) {
		this.avg1 = avg1;
	}
	public RestAvg2DTO getAvg2() {
		return avg2;
	}
	public void setAvg2(RestAvg2DTO avg2) {
		this.avg2 = avg2;
	}
	public RestAvg3DTO getAvg3() {
		return avg3;
	}
	public void setAvg3(RestAvg3DTO avg3) {
		this.avg3 = avg3;
	}
	public RestAvg4DTO getAvg4() {
		return avg4;
	}
	public void setAvg4(RestAvg4DTO avg4) {
		this.avg4 = avg4;
	}
	public RestAvg5DTO getAvg5() {
		return avg5;
	}
	public void setAvg5(RestAvg5DTO avg5) {
		this.avg5 = avg5;
	}
	
	
	
	
	
	
	
	

}
