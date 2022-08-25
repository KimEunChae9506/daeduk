<% request.setCharacterEncoding("UTF-8");%><%@ page import="java.util.*
,io.jsonwebtoken.Jwts
,io.jsonwebtoken.Claims
,io.jsonwebtoken.SignatureAlgorithm
,io.jsonwebtoken.SignatureException
,java.io.UnsupportedEncodingException
,java.security.GeneralSecurityException
,java.security.Key
,java.security.NoSuchAlgorithmException
,javax.crypto.Cipher
,javax.crypto.spec.IvParameterSpec
,javax.crypto.spec.SecretKeySpec
,org.apache.commons.codec.binary.Base64"%><%!

public static class ProEncrypts {
	private String iv;
	private Key keySpec;
	
	/**
	 * 16자리이상 의 키값을 입력하여 객체를 생성한다.
	 * 
	 * @param key
	 *            암/복호화를 위한 키값
	 * @throws UnsupportedEncodingException
	 *             키값의 길이가 16이하일 경우 발생
	 */
	public ProEncrypts(String key) throws UnsupportedEncodingException {
		this.iv = key.substring(0, 16);
		byte[] keyBytes = new byte[16];
		byte[] b = key.getBytes("UTF-8");
		int len = b.length;
		if (len > keyBytes.length) {
			len = keyBytes.length;
		}
		System.arraycopy(b, 0, keyBytes, 0, len);
		SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");

		this.keySpec = keySpec;
	}
	
	/**
	 * AES256 으로 암호화 한다.
	 * 
	 * @param str
	 *            암호화할 문자열
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws GeneralSecurityException
	 * @throws UnsupportedEncodingException
	 */
	public String returnEncryptCode(String str) throws NoSuchAlgorithmException,
	GeneralSecurityException, UnsupportedEncodingException {
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));
		byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		String enStr = new String(Base64.encodeBase64(encrypted));
		return enStr;
    }
    
	/**
	 * AES256으로 암호화된 txt 를 복호화한다.
	 * 
	 * @param str
	 *            복호화할 문자열
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws GeneralSecurityException
	 * @throws UnsupportedEncodingException
	 */
    public String returnDecryptCode(String str) throws NoSuchAlgorithmException,
	GeneralSecurityException, UnsupportedEncodingException {
    	Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));
		byte[] byteStr = Base64.decodeBase64(str.getBytes());
		return new String(c.doFinal(byteStr), "UTF-8");
    }
    
    /**
	 * JWT로 HS256를 이용하여 TOKEN 생성으로 데이터 인증절차를 생성해 보호합니다.
	 * 
	 * @param encKey
	 *            암호화키
	 * @param payload
	 *            보호할 결과 데이터
	 * @return 암호화된 jwt 형식의 데이터 token
	 */
    public static String createToken(String encKey, Map<String, Object> payloads) {
	    Map<String, Object> headers = new HashMap<>();    
	    headers.put("typ", "JWT");
	    headers.put("alg", "HS256");
	     
	    String jwt = Jwts.builder()
	            .setHeader(headers)
	            .setClaims(payloads)
	            .signWith(SignatureAlgorithm.HS256, encKey.getBytes())
	            .compact();
	    return jwt;
	}
	
    /**
	 * TOKEN 키를 이용하여 데이터를 가져옵니다.
	 * 
	 * @param encKey
	 *            사용자가 호출한 암호화키
	 * @param jwtTokenString
	 *            암화화된 토큰키
	 * @return 암호화된 jwt 형식의 데이터 token
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getTokenFromJwtString(String encKey, String jwtTokenString, Map<String,Object> mainMap) throws InterruptedException {
		try {
			Claims claims = Jwts.parser()
		        .setSigningKey(encKey.getBytes())
		        .parseClaimsJws(jwtTokenString)
		        .getBody();
		    mainMap.replace("result",(List<Map<String,Object>>)claims.get("result"));
		} catch (SignatureException e) {
			mainMap.replace("result","KEY ERROR");
		}
	    return mainMap;
	}
}
%>