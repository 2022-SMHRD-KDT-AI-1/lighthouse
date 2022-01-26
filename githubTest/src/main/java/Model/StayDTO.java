package Model;

public class StayDTO {
	
	// 숙박시설 순번 
    private int staySeq;

    // 숙박시설 명 
    private String Name;

    // 숙박시설 주소 
    private String stayAddr;

    // 숙박시설 담당구 
    private String stayGu;

    // 숙박시설 연락처 
    private String stayTel;

    // 주출입구 접근로 여부 
    private String stayApproach;

    // 주출입구 높이차이 제거 여부 
    private String stayHeightDiff;

    // 장애인 전용 주차구역 여부 
    private String stayParking;

    // 장애인 전용 승강기 여부 
    private String stayElev;

    // 장애인 전용 화장실 여부 
    private String stayToilet;
    
    // 숙박시설 위도 
    private float Latitude;

    // 숙박시설 경도 
    private float Longitude;
    
    

    public StayDTO(int staySeq, String Name, String stayAddr, String stayGu, String stayTel, String stayApproach,
			String stayHeightDiff, String stayParking, String stayElev, String stayToilet, float Latitude,
			float Longitude) {
		super();
		this.staySeq = staySeq;
		this.Name = Name;
		this.stayAddr = stayAddr;
		this.stayGu = stayGu;
		this.stayTel = stayTel;
		this.stayApproach = stayApproach;
		this.stayHeightDiff = stayHeightDiff;
		this.stayParking = stayParking;
		this.stayElev = stayElev;
		this.stayToilet = stayToilet;
		this.Latitude = Latitude;
		this.Longitude = Longitude;
	}

	public int getStaySeq() {
        return staySeq;
    }

    public void setStaySeq(int staySeq) {
        this.staySeq = staySeq;
    }

    public String getName() {
        return Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }

    public String getStayAddr() {
        return stayAddr;
    }

    public void setStayAddr(String stayAddr) {
        this.stayAddr = stayAddr;
    }

    public String getStayGu() {
        return stayGu;
    }

    public void setStayGu(String stayGu) {
        this.stayGu = stayGu;
    }

    public String getStayTel() {
        return stayTel;
    }

    public void setStayTel(String stayTel) {
        this.stayTel = stayTel;
    }

    public String getStayApproach() {
        return stayApproach;
    }

    public void setStayApproach(String stayApproach) {
        this.stayApproach = stayApproach;
    }

    public String getStayHeightDiff() {
        return stayHeightDiff;
    }

    public void setStayHeightDiff(String stayHeightDiff) {
        this.stayHeightDiff = stayHeightDiff;
    }

    public String getStayParking() {
        return stayParking;
    }

    public void setStayParking(String stayParking) {
        this.stayParking = stayParking;
    }

    public String getStayElev() {
        return stayElev;
    }

    public void setStayElev(String stayElev) {
        this.stayElev = stayElev;
    }

    public String getStayToilet() {
        return stayToilet;
    }

    public void setStayToilet(String stayToilet) {
        this.stayToilet = stayToilet;
    }

	public float getLatitude() {
		return Latitude;
	}

	public void setLatitude(float Latitude) {
		this.Latitude = Latitude;
	}

	public float getLongitude() {
		return Longitude;
	}

	public void setLongitude(float Longitude) {
		this.Longitude = Longitude;
	}
    
    

}
