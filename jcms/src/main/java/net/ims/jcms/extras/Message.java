package net.ims.jcms.extras;

import net.ims.jcms.Util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.mail.BodyPart;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;

/**
 * A Message is a convenience class which embodies all the parameters of a single lyris messages_ record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Message {

  public String body;
  public String creatstamp;
  public String digested;
  public String hdrall;
  public String hdrdate;
  public String hdrfrom;
  public String hdrfromspc;
  public String hdrto;
  public String list;
  public String memberid;
  public String messageid;
  public String parentid;
  public String subsetid;
  public String title;
  public String hdrsubject;

  // more useful stuff
  public String textCharset;
  public String textBody;
  public String htmlCharset;
  public String htmlBody;
  
  /**
   * Construct given a full messages_ result row, pruning out Lyris escape codes.
   * result[0][0] = body_
   * result[0][1] = creatstamp_
   * result[0][2] = digested_
   * result[0][3] = hdrall_
   * result[0][4] = hdrdate_
   * result[0][5] = hdrfrom_
   * result[0][6] = hdrfromspc_
   * result[0][7] = hdrto_
   * result[0][8] = list_
   * result[0][9] = memberid_
   * result[0][10] = messageid_
   * result[0][11] = parentid_
   * result[0][12] = subsetid_
   * result[0][13] = title_
   * result[0][14] = hdrsubject_
   */
  public Message(String[] result) throws IOException, MessagingException {

    // instance vars
    body = pruneEscapes(result[0]);
    creatstamp = result[1];
    digested = result[2];
    hdrall = result[3];
    hdrdate = result[4];
    hdrfrom = result[5];
    hdrfromspc = result[6];
    hdrto = result[7];
    list = result[8];
    memberid = result[9];
    messageid = result[10];
    parentid = result[11];
    subsetid = result[12];
    title = pruneEscapes(result[13]);
    hdrsubject = pruneEscapes(result[14]);

    // get MIME parts and character encoding
    if (body!=null && body.indexOf("MIME")>0) {
      MimeMultipart mm = new MimeMultipart(new ByteArrayDataSource(body, "text/plain"));
      int numparts = mm.getCount();
      for (int i=0; i<numparts; i++) {
	BodyPart bp = mm.getBodyPart(i);
	String contentType = bp.getContentType();
	if (contentType.indexOf("html")>0) {
	  htmlBody = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n";
	  if (contentType.indexOf("ISO-8859-1")>0) htmlCharset = "ISO-8859-1"; else htmlCharset="UTF-8";
	  BufferedReader in = new BufferedReader(new InputStreamReader(bp.getInputStream(), htmlCharset));
	  StringBuffer sb = new StringBuffer();
	  int ci;
	  while ((ci=in.read())!=-1) {
	    if (ci==194) {
	      // 194 creeps in from Windows folks, just drop it
	    } else if (ci<160) {
	      // nothing special only 7 Bit
	      sb.append((char)ci);
	    } else {
	      // not 7 bit, use the unicode system
	      sb.append("&#");
	      sb.append(new Integer(ci).toString());
	      sb.append(';');
	    }
	  }
	  htmlBody += sb.toString().replaceAll(" & ", " &amp; ");
	} else if (contentType.indexOf("plain")>0) {
	  if (contentType.indexOf("ISO-8859-1")>0) textCharset = "ISO-8859-1"; else textCharset="UTF-8";
	  textBody = (String)bp.getContent();
	}
      }
    }

  }

  /**
   * Prune Lyris escapes from string.
   */
  static String pruneEscapes(String input) {
    if (input==null) return null;
    String pruned = input;
    while (pruned.indexOf("%%")!=-1) {
      int k = pruned.indexOf("%%"); // opening %%
      int l = pruned.indexOf("%%",k+1)+2; // closing %%
      pruned = pruned.substring(0,k) + pruned.substring(l);
    }
    return pruned;
  }

}

