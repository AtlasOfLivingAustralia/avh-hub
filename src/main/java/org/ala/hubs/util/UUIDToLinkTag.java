package org.ala.hubs.util;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Converts UUIDs in text blocks to links
 */
public class UUIDToLinkTag extends TagSupport {

    private String text = "";
    private String baseLink = "http://biocache.ala.org.au/occurrences/";
    private String linkText = "this record";

    //d2564228-4df4-4ea2-b741-14faa13fd71c
    static final Pattern uuidPattern = Pattern.compile("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}");

    public int doStartTag() throws JspException {
        StringBuffer sb = new StringBuffer();
        Matcher m = uuidPattern.matcher(text);
        int lastEnd = 0;
        while(m.find()){
         sb.append(text.substring(lastEnd,  m.start()));
         sb.append("<a href=\"" + baseLink + m.group() + "\">");
         sb.append(linkText);
         sb.append("</a>");
         lastEnd = m.end();
        }
        if(sb.length() == 0){
          sb.append(text);
        }
        try {
            pageContext.getOut().print(sb.toString());
        } catch (Exception e) {
            throw new JspTagException("UUIDToLinkTag: " + e.getMessage());
        }
        return super.doStartTag();
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getBaseLink() {
        return baseLink;
    }

    public void setBaseLink(String baseLink) {
        this.baseLink = baseLink;
    }

    public String getLinkText() {
        return linkText;
    }

    public void setLinkText(String linkText) {
        this.linkText = linkText;
    }
}
