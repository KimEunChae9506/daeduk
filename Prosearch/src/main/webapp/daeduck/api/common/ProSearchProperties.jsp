<%@ page pageEncoding = "UTF-8" %><%!

	public final static int HIGHLIGHT_SIZE = 250;

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
	
    static String ES_SERVERS = "192.168.8.204:6201";
    static String MANAGER_SERVERS = "192.168.8.204:6501";

	public String [] INDEX_LIST = new String [] {"doc"};
		
	public static final String HIGHLIGHT_STAG = "<em>";
	public static final String HIGHLIGHT_ETAG = "</em>";


	public String [][] SEARCH_INDEX_SETS = new String[][]
				{
					{
						"doc", 					//    index name
						"doc",  					//  alias name
						"SCORE/DESC",  				// sort
						"atch_file_nm.ngram,atch_file_nm,title.ngram,title,content,atch_cont,regt_id,tag_nm",								// SEARCH_FIELD field
						"",							// exclude field
						"atch_file_nm.ngram,atch_file_nm,title.ngram,title,content,atch_cont,regt_id,tag_nm",				// highlight field
						"",							// Filter Query
						""						// View Index Name

					}
				};



%>