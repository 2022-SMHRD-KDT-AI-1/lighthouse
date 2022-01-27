package Model;

public class RestRvDTO {
	
	private int seq;
	private int s1;
	private int s2;
	private int s3;
	private String text;
	
	public RestRvDTO(int seq, int s1, int s2, int s3, String text) {
		this.seq = seq;
		this.s1 = s1;
		this.s2 = s2;
		this.s3 = s3;
		this.text = text;
		
		
	}

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getS1() {
		return s1;
	}

	public void setS1(int s1) {
		this.s1 = s1;
	}

	public int getS2() {
		return s2;
	}

	public void setS2(int s2) {
		this.s2 = s2;
	}

	public int getS3() {
		return s3;
	}

	public void setS3(int s3) {
		this.s3 = s3;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
	

}
