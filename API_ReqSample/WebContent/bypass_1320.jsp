<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="java.net.URLConnection,java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.DataOutputStream, java.io.DataInputStream, java.io.ByteArrayOutputStream"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.net.URLDecoder, java.net.URLEncoder"%>


<%@ page import = "javax.net.ssl.TrustManager" %>
<%@ page import = "javax.net.ssl.HttpsURLConnection" %>
<%@ page import = "javax.net.ssl.SSLContext" %>
<%@ page import = "javax.net.ssl.X509TrustManager" %>
<%@ page import = "java.security.cert.X509Certificate" %>

<%!


    // URL, 입력파라미터 POST 처리 후 요청 전송, 결과 수신
    // String url : 호출할 웹 주소
    // String param : POST로 전달할 입력값(인자값)
    // return String ret : 주소 호출 결과 출력
    public String bypassXSS(String url, String param) throws Exception {
        // 결과값을 저장할 객체
        String ret = "";

        try {
            // URL 호출 객체 생성
            HttpsURLConnection con = (HttpsURLConnection) new URL(url).openConnection();
            // 호출 주소가 https 인 경우
            if(con instanceof HttpsURLConnection) {
                // SSL 프로토콜 TLS로 지정 (JDK 1.8 부터는 버전별 설정 가능)
                SSLContext sc = SSLContext.getInstance("TLS");
                // SSL 객체 초기화 (isAllAllow 가 true 인 경우 어떤 인증서든 OK)
                sc.init(null, null, new java.security.SecureRandom());

                // https 연결 수립을 위해 URL 호출 객체에 SSL 객체 설정
                con.setDefaultSSLSocketFactory(sc.getSocketFactory());
            }
            con.setDoOutput(true);          // 호출 주소로 전달할 값 있음
            con.setDoInput(true);           // 호출 주소로부터 전달받을 값 있음
            
            con.setRequestMethod("POST");   // HTTP Method 를 POST로 설정
            con.setUseCaches(false);        // 캐쉬 사용 안할거임.
            // OutputStream을 사용하여 입력값을 호출 주소로 전달
            DataOutputStream dos = new DataOutputStream(con.getOutputStream());
            dos.writeBytes(param);          // Stream에 입력값을 기록한다.
            dos.flush();                    // 다 전달 했으면 버퍼를 비운다.
            dos.close();                    // Stream 객체를 열었으면 닫자
            // InputStream을 사용하여 호출 주소로 부터 1024바이트씩 결과값 수신
            DataInputStream dis = new DataInputStream(con.getInputStream());
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] rawrcv = new byte[1024]; // 임시버퍼 크기는 1024 바이트로 설정
            while(true) {
                int n = dis.read(rawrcv);   // Stream으로부터 1024 바이트만큼을 읽는다.
                if(n<0) break;              // 더 읽을게 없으면 반복부 종료
                baos.write(rawrcv,0,n);     // Stream으로부터 읽어온 데이터를 바이트배열 객체에 기록한다.
            }
            baos.flush();                   // 다 기록했으면 버퍼를 비우자.
            // 바이트배열에 저장된 결과값을 UTF-8 인코딩으로 읽어 문자열로 저장한다.
            ret = new String(baos.toByteArray(), "UTF-8");
            dis.close();                    // Stream 객체를 열었으면 닫자
        } catch (java.net.SocketTimeoutException stoe) {
            //throw new Exception("WERR0005");
            throw stoe;    // 오류가 발생하면 여기서 바로 뻥 하지 말고 호출한 함수에게 오류가 발생했음을 전달하자.
        } catch (Exception e) {
            throw e;    // 오류가 발생하면 여기서 바로 뻥 하지 말고 호출한 함수에게 오류가 발생했음을 전달하자.
        }
        return ret;     // 오류가 발생하지 않았으면 처리 결과를 호출한 함수에게 전달하자.
    }
%>

<%
    String ret = "";
    try {
        String addr = "https://dev2.coocon.co.kr:8443/sol/gateway/scrap_wapi_std.jsp";
        String param= request.getParameter("REQ_DATA");
        
        if(param==null) {
            ret="{\"RESULT_CD\":\"-1\",\"RESULT_MG\":\"No Input\"}";
        } else {
            param = "REQ_DATA=" + URLEncoder.encode(URLEncoder.encode(param,"UTF-8"),"UTF-8");
            out.clear();
            if(!"".equals(param)) {
            	ret = bypassXSS(addr,param);
            } else {
                ret="{\"RESULT_CD\":\"-1\",\"RESULT_MG\":\"Illegal Input\"}";
            }
        }
    } catch (Exception e) {
        ret="{\"RESULT_CD\":\"-1\",\"RESULT_MG\":\""+e.getMessage()+"\"}";
    }
    out.print(ret);
%>