package net.ims.jcms;

import java.io.*;
import java.util.Date;
import java.security.NoSuchAlgorithmException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.spec.AlgorithmParameterSpec;
import java.sql.SQLException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

/**
 * Embodies an application license, which consists of a hostname, expiration date, and feature id.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class License {

  // the hostname embedded in the license
  public String hostname;

  // the expiration date embedded in the license
  public Date expiration;

  // the feature ID embedded in the license
  public int feature;

  // secret key, generated by Cipher.KeyGenerator, serialized to byte array
  private static final byte[] keyBytes = {
    -84, -19, 0, 5, 115, 114, 0, 20, 106, 97, 118, 97, 46, 115, 101, 99, 117, 114, 105, 116, 121, 46, 75, 101, 121, 82, 101, 112, -67, -7, 79, -77, -120, -102, 
    -91, 67, 2, 0, 4, 76, 0, 9, 97, 108, 103, 111, 114, 105, 116, 104, 109, 116, 0, 18, 76, 106, 97, 118, 97, 47, 108, 97, 110, 103, 47, 83, 116, 114, 105, 110, 
    103, 59, 91, 0, 7, 101, 110, 99, 111, 100, 101, 100, 116, 0, 2, 91, 66, 76, 0, 6, 102, 111, 114, 109, 97, 116, 113, 0, 126, 0, 1, 76, 0, 4, 116, 121, 112, 
    101, 116, 0, 27, 76, 106, 97, 118, 97, 47, 115, 101, 99, 117, 114, 105, 116, 121, 47, 75, 101, 121, 82, 101, 112, 36, 84, 121, 112, 101, 59, 120, 112, 116, 
    0, 3, 68, 69, 83, 117, 114, 0, 2, 91, 66, -84, -13, 23, -8, 6, 8, 84, -32, 2, 0, 0, 120, 112, 0, 0, 0, 8, 69, -42, 4, -82, 35, 103, 69, 44, 116, 0, 3, 82, 
    65, 87, 126, 114, 0, 25, 106, 97, 118, 97, 46, 115, 101, 99, 117, 114, 105, 116, 121, 46, 75, 101, 121, 82, 101, 112, 36, 84, 121, 112, 101, 
    0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 120, 114, 0, 14, 106, 97, 118, 97, 46, 108, 97, 110, 103, 46, 69, 110, 117, 109, 0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 
    120, 112, 116, 0, 6, 83, 69, 67, 82, 69, 84
  };

  // 8-byte initialization vector
  private static final byte[] iv = { (byte)0x8E, 0x12, 0x39, (byte)0x9C, 0x07, 0x72, 0x6F, 0x5A };

  // Cipher algorithm/coding/padding
  private static final String cipherAlgorithm = "DES/CFB8/NoPadding";

  /** construct given a license key read from a context parameter */
  public License(HttpServletRequest request) throws IOException, ClassNotFoundException, 
						    NoSuchAlgorithmException, NoSuchPaddingException,
						    InvalidKeyException, InvalidAlgorithmParameterException,
						    LicenseInvalidException {

    String licenseString = request.getSession().getServletContext().getInitParameter("site.license");
    if (licenseString==null) throw new LicenseInvalidException("site.license is missing from web.xml.");

    // don't want trailing blanks
    licenseString = licenseString.trim();

    // deserialize secret key from byte array
    ByteArrayInputStream keyStream = new ByteArrayInputStream(keyBytes);
    ObjectInputStream ois = new ObjectInputStream(keyStream);
    SecretKey key = (SecretKey)ois.readObject();
    ois.close();
    keyStream.close();

    // create the cipher object
    Cipher dcipher = Cipher.getInstance(cipherAlgorithm);
    AlgorithmParameterSpec paramSpec = new IvParameterSpec(iv);
    dcipher.init(Cipher.DECRYPT_MODE, key, paramSpec);  // CBC requires an initialization vector

    // create a byte array from the license string
    byte[] licenseBytes = new byte[licenseString.length()/2];
    for (int i=0; i<licenseBytes.length; i++) {
      licenseBytes[i] = Util.hexToByte(licenseString.substring(2*i,2*i+2));
    }

    // decrypt the byte array
    ByteArrayInputStream licenseStream = new ByteArrayInputStream(licenseBytes);
    CipherInputStream cis = new CipherInputStream(licenseStream, dcipher);
    byte[] buffer = new byte[1024];
    int num = cis.read(buffer);
    cis.close();
    licenseStream.close();

    // convert to a plaintext string
    String plaintext = new String(buffer, 0, num);

    // parse out to set the instance vars, if possible
    String[] parts = plaintext.split(" ");
    if (parts!=null && parts.length>2) {
      String expirationText = parts[1];
      if (expirationText!=null) {
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	expiration = format.parse(expirationText, new ParsePosition(0));
	hostname = parts[0];
	feature = Integer.parseInt(parts[2]);
      }
    }

  }

  /**
   * Check whether the current HttpServletRequest is valid against the site license for the given feature; throw an exception if not.
   */
  public static void check(HttpServletRequest request, int feature) throws IOException, ClassNotFoundException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, 
									   InvalidAlgorithmParameterException, FileNotFoundException, SQLException, NamingException, LicenseInvalidException {
    License license = new License(request);
    if (license.hostname==null) {
      throw new LicenseInvalidException("site.license is invalid: hostname not found.");
    } else if (license.expiration==null) {
      throw new LicenseInvalidException("site.license is invalid: expiration not found.");
    } else if (!license.hostname.equals(request.getServerName())) {
      throw new LicenseInvalidException("site.license is invalid: licensed hostname does not match "+request.getServerName()+".");
    } else if (license.expiration.before(new Date())) {
      throw new LicenseInvalidException("site.license is invalid: it expired on "+license.expiration+".");
    } else if (license.feature!=feature) {
      throw new LicenseInvalidException("site.license is invalid: feature ("+license.feature+") does not match requested feature ("+feature+").");
    }
  }
  
}

