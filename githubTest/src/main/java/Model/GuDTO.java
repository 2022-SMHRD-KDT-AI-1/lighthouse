package Model;

public class GuDTO {
	
	private int num;
	private String addr;
	private float latitude;
	private float longitude;
	
	
	public GuDTO(int num, String addr, float latitude, float longitude) {
		this.num = num;
		this.addr = addr;
		this.latitude = latitude;
		this.longitude = longitude;
	}
	
	


	public GuDTO(String addr) {
		this.addr = addr;
	}




	public int getNum() {
		return num;
	}


	public void setNum(int num) {
		this.num = num;
	}


	public String getAddr() {
		return addr;
	}


	public void setAddr(String addr) {
		this.addr = addr;
	}


	public float getLatitude() {
		return latitude;
	}


	public void setLatitude(float latitude) {
		this.latitude = latitude;
	}


	public float getLongitude() {
		return longitude;
	}


	public void setLongitude(float longitude) {
		this.longitude = longitude;
	}
	
	
	
	

}
