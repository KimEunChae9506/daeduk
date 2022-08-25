<%@ page import="java.io.*,java.lang.*,java.net.*,java.util.*"%><%@ page contentType="text/json; charset=utf-8" language="java" session="false" %><%request.setCharacterEncoding("utf-8");%><%@ include file="./common/ProSearchProperties.jsp" %><%@ include file="./common/ProUtils.jsp" %><%

	int timeout = 1000;	 //ms
	String type 	= ProUtils.getCheckReq(request, "type", "search");						//search, insert ,delete
	String userid 	= ProUtils.getCheckReq(request, "userid", "test_lsw");					//userid
	String regDate 	= ProUtils.getCheckReq(request, "regDate", "20210823000000");			//regDate
	
	regDate = ProUtils.getCurrentDate("yyyyMMddhhmmss");
	
	String word 	= ProUtils.getCheckReq(request, "word", "문서");							//word
	
	String interestNo 	= ProUtils.getCheckReq(request, "interestNo", "");					//interestNo

	StringBuffer sb = new StringBuffer();
	String url = "http://" + ES_SERVERS + "/@prosearch_interestkeyword/";

	if(type.equals("insert")){
		interestNo 	= userid+"_" +word;
		url += "_doc/" +userid+"_" +URLEncoder.encode(word, "UTF-8");
		sb.append("{\n"+ 
			  "	\"userId\":\""+userid +"\", \n"+
			  "	\"regdate\":\""+regDate +"\", \n"+
			  "	\"word\":\""+word +"\", \n"+
			  "	\"interestNo\":\""+interestNo +"\" \n"+
			  "}");
	}else if(type.equals("delete")){
		url+="_delete_by_query";
		sb.append("{\n"+ 
			  "	\"query\":{ \n"+
					"\"match\": { \n"+
						"\"interestNo\": \""+interestNo+"\" \n"+ 
					"} \n"+
			  "}\n"+ 
		"}");
	}else{
		url+="_search";
		sb.append("{\n"+ 
			  "	\"query\":{ \n"+
			  "	 \"match\":{ \n"+
			  "	  \"userId\":\""+userid +"\" \n"+
			  "   } \n"+
			  "}\n"+ 
		"}");
		
	}

	String params = sb.toString();

	out.println(saveInterestKeyword(url , params, timeout)); //send url value
%>
<%!
	public String saveInterestKeyword(String receiverURL, String jsonData, int timeout) {
		StringBuffer receiveMsg = new StringBuffer();
		HttpURLConnection uc = null;
		int errorCode = 0;
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


			//System.out.println("[URLConnection Response Code] " + uc.getResponseCode());
			
			errorCode = uc.getResponseCode();
			
			if (uc.getResponseCode() == 201) {
				String currLine = "";
                // UTF-8. ..
                BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), "UTF-8"));
                while ((currLine = in.readLine()) != null) {
                	receiveMsg.append(currLine).append("\r\n");
                }
				
				//System.out.println("receiveMsg=" + receiveMsg.toString());
                in.close();
            } else if(uc.getResponseCode() == 200){
				String currLine = "";
                // UTF-8. ..
                BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), "UTF-8"));
                while ((currLine = in.readLine()) != null) {
                	receiveMsg.append(currLine).append("\r\n");
                }
				//System.out.println("receiveMsg=" + receiveMsg.toString());
                in.close();

			}else {
                errorCode = uc.getResponseCode();
				return errorCode+" ::: ";
             }
       } catch(Exception ex) {
            System.out.println(ex);
			return ex.getMessage();
       } finally {
            uc.disconnect();
       }

       //System.out.println(receiveMsg.toString());
      return receiveMsg.toString();
	}
%>