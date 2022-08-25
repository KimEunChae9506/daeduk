<%@ page import="java.io.*,java.lang.*,java.net.*,java.util.*"%><%@ page contentType="text/html; charset=UTF-8" language="java" session="false" %><%request.setCharacterEncoding("utf-8");%><%@ include file="./common/ProSearchProperties.jsp" %><%@ include file="./common/ProUtils.jsp" %><%


	int timeout = 500;	 //ms

	String search 	= ProUtils.getCheckReq(request, "query", "");						//검색어
	String index 	= ProUtils.getCheckReq(request, "index", "");	//auto_keyword_service
	String stype 	= ProUtils.getCheckReq(request, "type", "doc");				    	//type

	search = URLEncoder.encode(search, "UTF-8");

	String url = "http://" + ES_SERVERS + "/@prosearch_auto_service";

    StringBuffer sb = new StringBuffer();

    String params = "?query=" + search ; 
	System.out.println(url + params);
 
	
	out.println(getAutoComplate(url + params, "", timeout)); //send url value
%>
<%!
	public String getAutoComplate(String receiverURL, String params, int timeout) {
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

		//	System.out.println("[URLConnection Response Code] " + uc.getResponseCode() + " ::" + HttpURLConnection.HTTP_OK);
			
			if (uc.getResponseCode() == HttpURLConnection.HTTP_OK) {
				String currLine = "";
                // UTF-8. ..
                BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), "UTF-8"));
                while ((currLine = in.readLine()) != null) {
                	receiveMsg.append(currLine).append("\r\n");
                }
				
		//		System.out.println("receiveMsg=" + receiveMsg.toString());
                in.close();
            } else {
                  errorCode = uc.getResponseCode();
                  return receiveMsg.toString();
             }
       } catch(Exception ex) {
            System.out.println(ex);
       } finally {
            uc.disconnect();
       }

       //System.out.println(receiveMsg.toString());
       return receiveMsg.toString();
	}
%>