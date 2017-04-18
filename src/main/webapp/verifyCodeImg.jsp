<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="image/jpeg" autoFlush="false" import="java.awt.*,java.awt.image.*,javax.imageio.*,java.util.*" pageEncoding="UTF-8"%>
<%!private static String tmp = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456787890";

    private static String[] font = { "LiSu", "KaiTi", "ÃÂ¥ÃÃ©", "ÃÃÃÃ©", "Â¿Â¬ÃÃ©", "\u5b8b\u4f53", "\u65b0\u5b8b\u4f53", "\u9ed1\u4f53", "\u6977\u4f53", "\u96b6\u4e66" };%>
<%
    int verifycode_width = 190;
    int verifycode_height = 30;
    int verifycode_wordcount = 4;

    Random rand = new Random();
    int len = verifycode_wordcount;
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i <= len; i++) {
        int start = rand.nextInt(tmp.length());
        sb.append(tmp.charAt(start));
        sb.append(" ");
    }
    String userAgent = request.getHeader("User-Agent");
    if (userAgent.indexOf("Mozilla") < 0 && userAgent.indexOf("OpenWave") < 0 && userAgent.indexOf("Opera") < 0 && userAgent.indexOf("iPanel") < 0) {
        session.setAttribute("verify_code", "ERROR");
    } else {
        session.setAttribute("verify_code", sb.toString().replaceAll(" ", ""));
    }
    out.clear();
    response.setContentType("image/jpeg");
    response.addHeader("pragma", "NO-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addDateHeader("Expries", 0);

    int width = verifycode_width, height = verifycode_height;
    Random tmpRand = new Random();

    BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    Graphics2D g = (Graphics2D) image.getGraphics();

    Color bkgrdColor;
    g.setColor(Color.WHITE);
    g.fillRect(0, 0, width, height);

    int noiseRank = 50;
    int noiseWidth = 2;
    java.util.List pl = new ArrayList();
    while (pl.size() < noiseRank) {
        int rp = new Random().nextInt(width * height / 2) + new Random().nextInt(width * height / 2);
        if (!pl.contains(rp + "")) {
            pl.add(rp + "");
        }
    }
    for (int i = 0; i < noiseRank; i++) {
        bkgrdColor = new Color(tmpRand.nextInt(100), tmpRand.nextInt(100), tmpRand.nextInt(100));
        bkgrdColor.brighter();
        g.setColor(bkgrdColor);
        int pro = Integer.parseInt((String) pl.get(i));
        g.fillRect(pro % width, pro / width, tmpRand.nextInt(noiseWidth) + 1, tmpRand.nextInt(noiseWidth) + 1);
    }

    g.setColor(Color.BLACK);
    g.drawLine(tmpRand.nextInt(width), tmpRand.nextInt(height), tmpRand.nextInt(width), tmpRand.nextInt(height));

    Color fontColor;
    int fontSize = 22;
    for (int i = 0; i < sb.toString().length(); i++) {

        fontSize = 22 + tmpRand.nextInt(5);
        int rotateRate = tmpRand.nextInt(40) - 20;
        g.rotate(Math.toRadians(rotateRate), 20 * i + 10, height / 2);

        g.setFont(new Font(font[tmpRand.nextInt(font.length)], new Random().nextInt(2), fontSize));
        fontColor = new Color(tmpRand.nextInt(100), tmpRand.nextInt(100), tmpRand.nextInt(100));
        g.setColor(fontColor);
        g.drawChars(sb.toString().toCharArray(), i, 1, 20 * i + tmpRand.nextInt(20), 20 + tmpRand.nextInt(5));
        g.rotate(Math.toRadians(-rotateRate), 20 * i + 10, height / 2);
    }

    g.dispose();
    ServletOutputStream outStream = response.getOutputStream();
    //JPEGImageEncoder encoder =JPEGCodec.createJPEGEncoder(outStream);
    //encoder.encode(image);
    ImageIO.write(image, "JPEG", outStream);
    outStream.close();

    //uid参数获取
    String code = StringUtils.replace(sb.toString(), " ", "");
    String uid = request.getParameter("uid");
    
   
%>

