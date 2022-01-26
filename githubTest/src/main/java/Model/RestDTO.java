package Model;

public class RestDTO {
	
	// 음식점 순번 
    private int restSeq;

    // 음식점 명 
    private String restName;

    // 음식점 주소 
    private String restAddr;

    // 음식점 담당구 
    private String restGu;

    // 음식점 연락처 
    private String restTel;

    // 주출입구 접근로 여부 
    private String restApproach;

    // 주출입구 높이차이 제거 여부 
    private String restHeightDiff;

    // 장애인 전용 주차구역 여부 
    private String restParking;

    // 장애인 전용 승강기 여부 
    private String restElev;

    // 장애인 전용 화장실 여부 
    private String restToilet;

    // 음식점 위도 
    private float restLatitude;

    // 음식점 경도 
    private float restLongitude;
    
    
    public RestDTO(int restSeq, String restName, String restAddr, String restGu, String restTel,
			String restApproach, String restHeightDiff, String restParking, String restElev, String restToilet,
			float restLatitude, float restLongitude) {
		super();
		this.restSeq = restSeq;
		this.restName = restName;
		this.restAddr = restAddr;
		this.restGu = restGu;
		this.restTel = restTel;
		this.restApproach = restApproach;
		this.restHeightDiff = restHeightDiff;
		this.restParking = restParking;
		this.restElev = restElev;
		this.restToilet = restToilet;
		this.restLatitude = restLatitude;
		this.restLongitude = restLongitude;
	}
    
    
    // 음식점 위도, 경도 좌표
	public RestDTO(float restLatitude, float restLongitude) {
		super();
		this.restLatitude = restLatitude;
		this.restLongitude = restLongitude;
	}



	public int getRestSeq() {
        return restSeq;
    }

    public void setRestSeq(int restSeq) {
        this.restSeq = restSeq;
    }

    public String getRestName() {
        return restName;
    }

    public void setRestName(String restName) {
        this.restName = restName;
    }

    public String getRestAddr() {
        return restAddr;
    }

    public void setRestAddr(String restAddr) {
        this.restAddr = restAddr;
    }

    public String getRestGu() {
        return restGu;
    }

    public void setRestGu(String restGu) {
        this.restGu = restGu;
    }

    public String getRestTel() {
        return restTel;
    }

    public void setRestTel(String restTel) {
        this.restTel = restTel;
    }

    public String getRestApproach() {
        return restApproach;
    }

    public void setRestApproach(String restApproach) {
        this.restApproach = restApproach;
    }

    public String getRestHeightDiff() {
        return restHeightDiff;
    }

    public void setRestHeightDiff(String restHeightDiff) {
        this.restHeightDiff = restHeightDiff;
    }

    public String getRestParking() {
        return restParking;
    }

    public void setRestParking(String restParking) {
        this.restParking = restParking;
    }

    public String getRestElev() {
        return restElev;
    }

    public void setRestElev(String restElev) {
        this.restElev = restElev;
    }

    public String getRestToilet() {
        return restToilet;
    }

    public void setRestToilet(String restToilet) {
        this.restToilet = restToilet;
    }

    public float getRestLatitude() {
        return restLatitude;
    }

    public void setRestLatitude(float restLatitude) {
        this.restLatitude = restLatitude;
    }

    public float getRestLongitude() {
        return restLongitude;
    }

    public void setRestLongitude(float restLongitude) {
        this.restLongitude = restLongitude;
    }

}
