package Model;

public class StayDTO {
	
	// ���ڽü� ���� 
    private int staySeq;

    // ���ڽü� �� 
    private String Name;

    // ���ڽü� �ּ� 
    private String stayAddr;

    // ���ڽü� ��籸 
    private String stayGu;

    // ���ڽü� ����ó 
    private String stayTel;

    // �����Ա� ���ٷ� ���� 
    private String stayApproach;

    // �����Ա� �������� ���� ���� 
    private String stayHeightDiff;

    // ����� ���� �������� ���� 
    private String stayParking;

    // ����� ���� �°��� ���� 
    private String stayElev;

    // ����� ���� ȭ��� ���� 
    private String stayToilet;
    
    // ���ڽü� ���� 
    private float Latitude;

    // ���ڽü� �浵 
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
