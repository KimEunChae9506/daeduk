<%@ page import="java.io.*,java.lang.*,java.net.*,java.util.*,org.apache.log4j.Logger"%><%@ page contentType="text/html; charset=UTF-8" language="java" session="false" %><%request.setCharacterEncoding("utf-8");%><%@ include file="./common/ProSearchProperties.jsp" %><%@ include file="./common/ProUtils.jsp" %><%
	/*
	* 쿼리로그 append
	*/

	int timeout = 500;	 //ms

	String search 	= ProUtils.getCheckReq(request, "query", "");						//검색어
	String index 	= ProUtils.getCheckReq(request, "index", "");						//index
	String took 	= ProUtils.getCheckReq(request, "took", "");				    	//took
	String service 	= ProUtils.getCheckReq(request, "service", "");				    	//service
	String cnt 		= ProUtils.getCheckReq(request, "cnt", "");				    		//cnt

	search = URLEncoder.encode(search, "UTF-8");
	String url = "http://" + ES_SERVERS + "/_pro10-querylog";
    String params = "?query=" + search + "&service=" + service + "&cnt=" + cnt + "&took=" + took ; 

	out.println(getQueryLog(url + params, "", timeout)); //send url value
%>
<%!
	public String getQueryLog(String receiverURL, String params, int timeout) {
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
			DataOutputStream dos = new DataOutputStream (uc.getOutputStream());
			dos.write(params.getBytes());
			dos.flush();
			dos.close();

			int errorCode = 0;

			//logger.info("[URLConnection Response Code] " + uc.getResponseCode() + " ::" + HttpURLConnection.HTTP_OK);
			
			if (uc.getResponseCode() == HttpURLConnection.HTTP_OK) {
				String currLine = "";
                // UTF-8. ..
                BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), "UTF-8"));
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
       return receiveMsg.toString();
	}
%>