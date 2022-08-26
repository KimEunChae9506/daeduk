<%@ page import="java.io.*,java.lang.*,java.net.*,java.util.*,com.google.gson.*,org.apache.log4j.Logger"%><%@ page contentType="text/json; charset=UTF-8" language="java" session="false" %><%request.setCharacterEncoding("utf-8");%><%@ include file="./common/ProSearchProperties.jsp" %><%@ include file="./common/ProUtils.jsp" %><%
	/*
	* 오타교정
	*/
	int timeout = 500;	 //ms

	String query 	= ProUtils.getCheckReq(request, "query", "");	 	// 검색어
	String service 	= ProUtils.getCheckReq(request, "service", "@ALL");	// service
	String pretty 	= ProUtils.getCheckReq(request, "pretty", "n");		//json 구조를 보기편하게 확인하기위한 view
	
	query = URLEncoder.encode(query, "UTF-8");
	String url = "http://" + ES_SERVERS + "/_pro10-speller";
    String params = "?query=" + query  ; 

	if ( !query.equals("")) {
		out.println(callSpellerQuery(url + params, "", timeout, pretty)); //send url value
	}
%><%!
	public String callSpellerQuery(String receiverURL, String params, int timeout, String pretty) {
		Logger logger = Logger.getLogger("[Log]");
		StringBuffer receiveMsg = new StringBuffer();
		HttpURLConnection uc = null;
		try {
			URL servletUrl = new URL(receiverURL);
			uc = (HttpURLConnection) servletUrl.openConnection();
			uc.setRequestProperty("Content-type", "application/x-www-form-urlencoded");
			uc.setRequestMethod("POST");
			uc.setDoOutput(true);
			uc.setDoInput(true);
			uc.setUseCaches(false);
			uc.setDefaultUseCaches(false);
			uc.setConnectTimeout(timeout);
			uc.setReadTimeout(timeout);
			DataOutputStream dos = new DataOutputStream (uc.getOutputStream());
			dos.write(params.getBytes());
			dos.flush();
			dos.close();

			int errorCode = 0;

			logger.info("[URLConnection Response Code] " + uc.getResponseCode() + " ::" + HttpURLConnection.HTTP_OK);
			
			if (uc.getResponseCode() == HttpURLConnection.HTTP_OK) {
				String currLine = "";
                // UTF-8. ..
                BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), "UTF-8"));
//                BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream()));
                while ((currLine = in.readLine()) != null) {
                	receiveMsg.append(currLine).append("\r\n");
                }
                in.close();
            } else {
                  errorCode = uc.getResponseCode();
                  return receiveMsg.toString();
             }
       } catch(Exception ex) {
    	   logger.error(ex);
       } finally {
            uc.disconnect();
       }

       Gson gson = new GsonBuilder().disableHtmlEscaping().create();
       if(pretty.equals("y") || pretty.equals("Y")){
    	   gson = new GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create();
       }
       
       JsonObject convertedObject = new Gson().fromJson(receiveMsg.toString(), JsonObject.class);
       return gson.toJson(convertedObject);
	}
%>