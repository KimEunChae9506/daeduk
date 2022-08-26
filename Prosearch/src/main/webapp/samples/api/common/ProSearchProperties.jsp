<%@ page pageEncoding = "UTF-8" %><%!

	public final static int HIGHLIGHT_SIZE = 150;

	public static final String SPECIAL_CHAR_COMMA 	= ",";
	public static final String SPECIAL_CHAR_SLASH 	= "/";
	public static final String SPECIAL_CHAR_CARET 	= "^";
	public static final String SPECIAL_CHAR_DOT 	= ".";
	public static final String SPECIAL_CHAR_COLON 	= ":";

	public static String TOKEN_KEY = "PROTEN_ENCPT_KEY"; //보안키 사용시 값 변경. 키값은 16자 이상으로 지정하세요.
	static Boolean USE_DATA_ENCRYPT = false;	//데이터만 암호화를 사용할지 여부

	public static String [] PRIORITY_SORT = {"id","SUBJECT","BODY","DATE"}; //해당필드 우선 정렬(해당index에 없으면 pass), 대소문자 구분없음


	public static final int DEFAULT_INDEX_NAME   	= 0;
	public static final int DEFAULT_ALIAS_NAME   	= 1;
	public static final int DEFAULT_SORT_FIELD 		= 2;
	public static final int DEFAULT_SEARCH_FIELD 	= 3;
	public static final int DEFAULT_EXCLUDE_FIELD 	= 4;
	public static final int DEFAULT_HIGHLIGHT_FIELD = 5;
	public static final int DEFAULT_FILTER_QUERY 	= 6;
	public static final int DEFAULT_INDEX_VIEW_NAME = 7;

    static String ES_SERVERS = "127.0.0.1:6201";
    static String MANAGER_SERVERS = "127.0.0.1:6501";

	public String [] INDEX_LIST = new String [] {"s_app"};
		
	public static final String HIGHLIGHT_STAG = "<em>";
	public static final String HIGHLIGHT_ETAG = "</em>";


	public String [][] SEARCH_INDEX_SETS = new String[][]
				{
					{
							"s_app", 					//    index name
							"s_app",  					//  alias name
							"SCORE/DESC",  				// sort
							"FIELD_SUBJECT,FIELD_CONTENT,FIELD_OWNER_NAME",								// SEARCH_FIELD field
							"",							// exclude field
							"FIELD_SUBJECT,FIELD_CONTENT,FIELD_OWNER_NAME",				// highlight field
							"",							// Filter Query
							"전자결재"						// View Index Name

					}
				};



%>