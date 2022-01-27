package Model;

public class StayDTO {
	
	// 숙박시설 순번 
    private int Seq;

    // 숙박시설 명 
    private String Name;

    // 숙박시설 주소 
    private String Addr;

    // 숙박시설 담당구 
    private String stayGu;

    // 숙박시설 연락처 
    private String Tel;

    // 주출입구 접근로 여부 
    private String Approach;

    // 주출입구 높이차이 제거 여부 
    private String HeightDiff;

    // 장애인 전용 주차구역 여부 
    private String Parking;

    // 장애인 전용 승강기 여부 
    private String Elev;

    // 장애인 전용 화장실 여부 
    private String Toilet;
    
    // 숙박시설 위도 
    private float Latitude;

    // 숙박시설 경도 
    private float Longitude;

	public StayDTO(int Seq, String name, String addr, String stayGu, String tel, String approach, String heightDiff,
			String parking, String elev, String toilet, float latitude, float longitude) {
		super();
		this.Seq = Seq;
		Name = name;
		Addr = addr;
		this.stayGu = stayGu;
		Tel = tel;
		Approach = approach;
		HeightDiff = heightDiff;
		Parking = parking;
		Elev = elev;
		Toilet = toilet;
		Latitude = latitude;
		Longitude = longitude;
	}

	public int getSeq() {
		return Seq;
	}

	public void setSeq(int Seq) {
		this.Seq = Seq;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getAddr() {
		return Addr;
	}

	public void setAddr(String addr) {
		Addr = addr;
	}

	public String getStayGu() {
		return stayGu;
	}

	public void setStayGu(String stayGu) {
		this.stayGu = stayGu;
	}

	public String getTel() {
		return Tel;
	}

	public void setTel(String tel) {
		Tel = tel;
	}

	public String getApproach() {
		return Approach;
	}

	public void setApproach(String approach) {
		Approach = approach;
	}

	public String getHeightDiff() {
		return HeightDiff;
	}

	public void setHeightDiff(String heightDiff) {
		HeightDiff = heightDiff;
	}

	public String getParking() {
		return Parking;
	}

	public void setParking(String parking) {
		Parking = parking;
	}

	public String getElev() {
		return Elev;
	}

	public void setElev(String elev) {
		Elev = elev;
	}

	public String getToilet() {
		return Toilet;
	}

	public void setToilet(String toilet) {
		Toilet = toilet;
	}

	public float getLatitude() {
		return Latitude;
	}

	public void setLatitude(float latitude) {
		Latitude = latitude;
	}

	public float getLongitude() {
		return Longitude;
	}

	public void setLongitude(float longitude) {
		Longitude = longitude;
	}
    
    

    
    

}
