<%@ page import="java.io.*,java.lang.*,java.net.*,java.util.*"%><%@ page contentType="text/json; charset=utf-8" language="java" session="false" %><%request.setCharacterEncoding("utf-8");%><%@ include file="./common/ProSearchProperties.jsp" %><%@ include file="./common/ProUtils.jsp" %><%

	int timeout = 1000;	 //ms

	String search 	= ProUtils.getCheckReq(request, "query", "전자");					//검색어
	//search = URLEncoder.encode(search, "UTF-8");

	String index 	= ProUtils.getCheckReq(request, "index", "exnews");					//검색어
	String url = "http://" + ES_SERVERS + "/" +index +"/_search";
	
	StringBuffer sb = new StringBuffer();
	sb.append("{\n"+ 
			  "	\"query\":{\n"+
			  "		\"match\":{\n"+
			  "			\"subject\":\""+ search +"\" \n"+
			  "		}\n"+
			  "	},\n"+
			  "	\"aggs\": { \n"+
			  "		\"Title_Grouping\":{\n"+
			  "			\"terms\": {\n"+
			  "				\"size\":100,\n"+
			  "				\"field\": \"subject\", \n"+
			  "				\"order\":{ \n"+
			  "					\"_count\":\"desc\" \n"+
			  "				}\n"+
			  "			}\n"+
			  "		}\n"+
			  "	}\n"+
			  "}");
	String params = sb.toString();

	out.println(getWordCloud(url , params, timeout)); //send url value
%>
<%!
	public String getWordCloud(String receiverURL, String jsonData, int timeout) {
		StringBuffer receiveMsg = new StringBuffer();
		HttpURLConnection uc = null;
		try {
			URL servletUrl = new URL(receiverURL);
			uc = (HttpURLConnection) servletUrl.openConnection();
			uc.setRequestProperty("Accept-Charset", "UTF-8"); 
			uc.setRequestProperty("Content-type", "application/json");
			uc.setRequestMethod("POST");
			uc.setDoOutput(true);
			uc.setDoInput(true);
			uc.setUseCaches(false);
			uc.setDefaultUseCaches(false);
			DataOutputStream dos = new DataOutputStream (uc.getOutputStream());
			dos.write(jsonData.getBytes("UTF-8"));
			dos.flush();
			dos.close();

			int errorCode = 0;

			System.out.println("[URLConnection Response Code] " + uc.getResponseCode());
			
			if (uc.getResponseCode() == HttpURLConnection.HTTP_OK) {
				String currLine = "";
                // UTF-8. ..
                BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), "UTF-8"));
                while ((currLine = in.readLine()) != null) {
                	receiveMsg.append(currLine).append("\r\n");
                }
				
				System.out.println("receiveMsg=" + receiveMsg.toString());
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