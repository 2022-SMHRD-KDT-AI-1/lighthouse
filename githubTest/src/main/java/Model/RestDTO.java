package Model;

public class RestDTO {
	
	// ������ ���� 
    private int restSeq;

    // ������ �� 
    private String restName;

    // ������ �ּ� 
    private String restAddr;

    // ������ ��籸 
    private String restGu;

    // ������ ����ó 
    private String restTel;

    // �����Ա� ���ٷ� ���� 
    private String restApproach;

    // �����Ա� �������� ���� ���� 
    private String restHeightDiff;

    // ����� ���� �������� ���� 
    private String restParking;

    // ����� ���� �°��� ���� 
    private String restElev;

    // ����� ���� ȭ��� ���� 
    private String restToilet;

    // ������ ���� 
    private float restLatitude;

    // ������ �浵 
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
    
    
    // ������ ����, �浵 ��ǥ
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
