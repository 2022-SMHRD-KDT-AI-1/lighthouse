package Model;

import java.util.ArrayList;

public class jsonConvVO {
	
	private ArrayList<ConvRvDTO> conv_rv_select;
	private ConvAvg1DTO avg1;
	private ConvAvg2DTO avg2;
	private ConvAvg3DTO avg3;
	private ConvAvg4DTO avg4;
	private ConvAvg5DTO avg5;
	public jsonConvVO(ArrayList<ConvRvDTO> conv_rv_select, ConvAvg1DTO avg1, ConvAvg2DTO avg2, ConvAvg3DTO avg3,
			ConvAvg4DTO avg4, ConvAvg5DTO avg5) {
		super();
		this.conv_rv_select = conv_rv_select;
		this.avg1 = avg1;
		this.avg2 = avg2;
		this.avg3 = avg3;
		this.avg4 = avg4;
		this.avg5 = avg5;
	}
	public ArrayList<ConvRvDTO> getConv_rv_select() {
		return conv_rv_select;
	}
	public void setConv_rv_select(ArrayList<ConvRvDTO> conv_rv_select) {
		this.conv_rv_select = conv_rv_select;
	}
	public ConvAvg1DTO getAvg1() {
		return avg1;
	}
	public void setAvg1(ConvAvg1DTO avg1) {
		this.avg1 = avg1;
	}
	public ConvAvg2DTO getAvg2() {
		return avg2;
	}
	public void setAvg2(ConvAvg2DTO avg2) {
		this.avg2 = avg2;
	}
	public ConvAvg3DTO getAvg3() {
		return avg3;
	}
	public void setAvg3(ConvAvg3DTO avg3) {
		this.avg3 = avg3;
	}
	public ConvAvg4DTO getAvg4() {
		return avg4;
	}
	public void setAvg4(ConvAvg4DTO avg4) {
		this.avg4 = avg4;
	}
	public ConvAvg5DTO getAvg5() {
		return avg5;
	}
	public void setAvg5(ConvAvg5DTO avg5) {
		this.avg5 = avg5;
	}
	
	
	
	
	
	
	

}
