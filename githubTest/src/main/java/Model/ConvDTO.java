package Model;

public class ConvDTO {
	
	// 편의시설 순번 
    private int convSeq;

    // 편의시설 명 
    private String Name;

    // 편의시설 주소 
    private String convAddr;

    // 편의시설 담당구 
    private String convGu;

    // 편의시설 연락처 
    private String convTel;

    // 주출입구 접근로 여부 
    private String convApproach;

    // 주출입구 높이차이 제거 여부 
    private String convHeightDiff;

    // 장애인 전용 주차구역 여부 
    private String convParking;

    // 장애인 전용 승강기 여부 
    private String convElev;

    // 장애인 전용 화장실 여부 
    private String convToilet;
    
    // 편의시설 위도 
    private float Latitude;

    // 편의시설 경도 
    private float Longitude;
    
    
    public ConvDTO(int convSeq, String Name, String convAddr, String convGu, String convTel, String convApproach,
			String convHeightDiff, String convParking, String convElev, String convToilet, float Latitude,
			float Longitude) {
		super();
		this.convSeq = convSeq;
		this.Name = Name;
		this.convAddr = convAddr;
		this.convGu = convGu;
		this.convTel = convTel;
		this.convApproach = convApproach;
		this.convHeightDiff = convHeightDiff;
		this.convParking = convParking;
		this.convElev = convElev;
		this.convToilet = convToilet;
		this.Latitude = Latitude;
		this.Longitude = Longitude;
	}

	public int getConvSeq() {
        return convSeq;
    }

    public void setConvSeq(int convSeq) {
        this.convSeq = convSeq;
    }

    public String getName() {
        return Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }

    public String getConvAddr() {
        return convAddr;
    }

    public void setConvAddr(String convAddr) {
        this.convAddr = convAddr;
    }

    public String getConvGu() {
        return convGu;
    }

    public void setConvGu(String convGu) {
        this.convGu = convGu;
    }

    public String getConvTel() {
        return convTel;
    }

    public void setConvTel(String convTel) {
        this.convTel = convTel;
    }

    public String getConvApproach() {
        return convApproach;
    }

    public void setConvApproach(String convApproach) {
        this.convApproach = convApproach;
    }

    public String getConvHeightDiff() {
        return convHeightDiff;
    }

    public void setConvHeightDiff(String convHeightDiff) {
        this.convHeightDiff = convHeightDiff;
    }

    public String getConvParking() {
        return convParking;
    }

    public void setConvParking(String convParking) {
        this.convParking = convParking;
    }

    public String getConvElev() {
        return convElev;
    }

    public void setConvElev(String convElev) {
        this.convElev = convElev;
    }

    public String getConvToilet() {
        return convToilet;
    }

    public void setConvToilet(String convToilet) {
        this.convToilet = convToilet;
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

	public void setConvLongitude(float Longitude) {
		this.Longitude = Longitude;
	}
    
    

}
