package Model;

public class ConvDTO {
	
	// ���ǽü� ���� 
    private int Seq;

    // ���ǽü� �� 
    private String Name;

    // ���ǽü� �ּ� 
    private String Addr;

    // ���ǽü� ��籸 
    private String convGu;

    // ���ǽü� ����ó 
    private String Tel;

    // �����Ա� ���ٷ� ���� 
    private String Approach;

    // �����Ա� �������� ���� ���� 
    private String HeightDiff;

    // ����� ���� �������� ���� 
    private String Parking;

    // ����� ���� �°��� ���� 
    private String Elev;

    // ����� ���� ȭ��� ���� 
    private String Toilet;
    
    // ���ǽü� ���� 
    private float Latitude;

    // ���ǽü� �浵 
    private float Longitude;

	public ConvDTO(int Seq, String name, String addr, String convGu, String tel, String approach, String heightDiff,
			String parking, String elev, String toilet, float latitude, float longitude) {
		super();
		this.Seq = Seq;
		Name = name;
		Addr = addr;
		this.convGu = convGu;
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

	public String getConvGu() {
		return convGu;
	}

	public void setConvGu(String convGu) {
		this.convGu = convGu;
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
