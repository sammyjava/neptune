package net.ims.jcms;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * This class contains generic methods for sending email using the javax.mail package.
 * The SMTP host is available from the servlet context JNDI directory.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Mailer {

    private Session session;

    private MimeMessage message;
    private MimeMultipart multipart;

    /**
     * Construct the session using the mail/Session JNDI context, which allows you to use as many JavaMail parameters
     * as you like.
     */
    public Mailer() throws NamingException {
	Context initCtx = new InitialContext();
	Context envCtx = (Context) initCtx.lookup("java:comp/env");
	session = (Session) envCtx.lookup("mail/Session");
    }

    /**
     * Generate and send a simple text email to a single recipient
     * @param fromAddress  the From: address of the email
     * @param fromName     the From: name of the email
     * @param toAddress    the To: address of the email
     * @param toName       the To: name of the email
     * @param subject      the Subject: of the email
     * @param msg          the message body
     */
    public void send(String fromAddress, String fromName, String toAddress, String toName, String subject, String msg) throws MessagingException, UnsupportedEncodingException {
	InternetAddress from = new InternetAddress("no-reply@ims.net");
	InternetAddress[] replyTo = { new InternetAddress(fromAddress, fromName) };
	InternetAddress to = new InternetAddress(toAddress, toName);
	message = new MimeMessage(session);
	message.setFrom(from);
	message.setReplyTo(replyTo);
	message.addRecipient(Message.RecipientType.TO, to);
	message.setSubject(subject, "UTF-8");
	message.setSentDate(new Date());
	message.setText(msg, "UTF-8");
	message.setHeader("Content-Transfer-Encoding", "8bit");
	message.setHeader("Content-Type", "text/plain; charset=UTF-8");
	Transport.send(message);
    }

    /**
     * Generate and send a simple text email to multiple recipients
     * @param fromAddress  the From: address of the email
     * @param fromName     the From: name of the email
     * @param toAddresses  the To: addresses of the email
     * @param toNames      the To: names of the email
     * @param subject      the Subject: of the email
     * @param msg          the message body
     */
    public void send(String fromAddress, String fromName, String[] toAddresses, String[] toNames, String subject, String msg) throws MessagingException, UnsupportedEncodingException {
	InternetAddress from = new InternetAddress("no-reply@ims.net");
	InternetAddress[] replyTo = { new InternetAddress(fromAddress, fromName) };
	InternetAddress[] to = new InternetAddress[toAddresses.length];
	for (int i=0; i<toAddresses.length; i++) {
	    to[i] = new InternetAddress(toAddresses[i], toNames[i]);
	}
	message = new MimeMessage(session);
	message.setFrom(from);
	message.setReplyTo(replyTo);
	message.addRecipients(Message.RecipientType.TO, to);
	message.setSubject(subject, "UTF-8");
	message.setSentDate(new Date());
	message.setText(msg, "UTF-8");
	message.setHeader("Content-Transfer-Encoding", "8bit");
	message.setHeader("Content-Type", "text/plain; charset=UTF-8");
	Transport.send(message);
    }
    
    /**
     * Set the plain text part of a new multipart message, along with the recipient, etc.
     */
    public void setText(String fromAddress, String fromName, String toAddress, String toName, String subject, String msg) throws MessagingException, UnsupportedEncodingException {
	InternetAddress from = new InternetAddress("no-reply@ims.net");
	InternetAddress[] replyTo = { new InternetAddress(fromAddress, fromName) };
	InternetAddress to = new InternetAddress(toAddress, toName);
	multipart = new MimeMultipart();
	message = new MimeMessage(session);
	message.setFrom(from);
	message.setReplyTo(replyTo);
	message.addRecipient(Message.RecipientType.TO, to);
	message.setHeader("Content-Transfer-Encoding", "8bit");
	message.setHeader("Content-Type", "text/plain; charset=UTF-8");
	message.setSubject(subject, "UTF-8");
	message.setSentDate(new Date());
	BodyPart bodypart = new MimeBodyPart();
	bodypart.setText(msg);
	multipart.addBodyPart(bodypart);
    }

    /**
     * Add an attachment to a multipart message (already initialized with setText())
     */
    public void addAttachment(File file) throws MessagingException {
	BodyPart bodypart = new MimeBodyPart();
	DataSource source = new FileDataSource(file.getAbsolutePath());
	bodypart.setDataHandler(new DataHandler(source));
	bodypart.setFileName(file.getName());
	multipart.addBodyPart(bodypart);
    }

    /**
     * Add an attachment to a multipart message (already initialized with setText()) with the given content type
     */
    public void addAttachment(File file, String contentType) throws MessagingException {
	BodyPart bodypart = new MimeBodyPart();
	DataSource source = new FileDataSource(file.getAbsolutePath());
	bodypart.setDataHandler(new DataHandler(source));
	bodypart.setFileName(file.getName());
	bodypart.setHeader("Content-Type", contentType);
	multipart.addBodyPart(bodypart);
    }

    /**
     * Send a multipart message built using setText() and addAttachment().
     */
    public void sendMultipart() throws MessagingException {
	message.setContent(multipart);
	Transport.send(message);
    }

    /**
     * Check that an email is valid (valid chars, @ symbol, dots, etc.)
     * @param email the email address
     * @return true if the email is determined to be valid based on syntax
     */
    public static boolean isValidEmail(String email) {
	if (email==null) return false;
	boolean ok = true;
	// must be letters and numbers plus @, ., _, - characters
	for (int i=0; i<email.length(); i++) {
	    ok = ok & (Character.isLetterOrDigit(email.charAt(i)) || email.charAt(i)=='@' || email.charAt(i)=='.' || email.charAt(i)=='_' || email.charAt(i)=='-');
	}
	// at least one char to left of @ symbol
	ok = ok && (email.indexOf('@')>0);
	// must have only one @ symbol
	ok = ok && (email.indexOf('@')==email.lastIndexOf('@'));
	// at least two dot-delimited atoms to right of @ symbol
	ok = ok && (email.indexOf('@')<(email.lastIndexOf('.')-1));
	ok = ok && (email.lastIndexOf('.')<(email.length()-1));
	// can't have consecutive ..
	ok = ok && (email.indexOf("..")==-1);
	return ok;
    }
  
}
