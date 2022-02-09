package Model;

public class testDTO {
	
	private String kind;
	private int seq;
	private String name;
	private String gu;
	private String addr;
	private float lat;
	private float lng;
	private String tel;
	private String approach;
	private String parking;
	private String h_diff;
	private String elev;
	private String toilet;
	
	
	public testDTO(String kind, int seq, String name, String gu, String addr, float lat, float lng, String tel,
			String approach, String parking, String h_diff, String elev, String toilet) {
		this.kind = kind;
		this.seq = seq;
		this.name = name;
		this.gu = gu;
		this.addr = addr;
		this.lat = lat;
		this.lng = lng;
		this.tel = tel;
		this.approach = approach;
		this.parking = parking;
		this.h_diff = h_diff;
		this.elev = elev;
		this.toilet = toilet;
	}
	
	public String getKind() {
		return kind;
	}
	public void setKind(String kind) {
		this.kind = kind;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGu() {
		return gu;
	}
	public void setGu(String gu) {
		this.gu = gu;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public float getLat() {
		return lat;
	}
	public void setLat(float lat) {
		this.lat = lat;
	}
	public float getLng() {
		return lng;
	}
	public void setLng(float lng) {
		this.lng = lng;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getApproach() {
		return approach;
	}
	public void setApproach(String approach) {
		this.approach = approach;
	}
	public String getParking() {
		return parking;
	}
	public void setParking(String parking) {
		this.parking = parking;
	}
	public String getH_diff() {
		return h_diff;
	}
	public void setH_diff(String h_diff) {
		this.h_diff = h_diff;
	}
	public String getElev() {
		return elev;
	}
	public void setElev(String elev) {
		this.elev = elev;
	}
	public String getToilet() {
		return toilet;
	}
	public void setToilet(String toilet) {
		this.toilet = toilet;
	}
	
	

}
