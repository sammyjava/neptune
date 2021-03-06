package net.ims.jcms.tools;

import net.ims.jcms.Util;

import java.io.*;
import java.security.NoSuchAlgorithmException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.spec.AlgorithmParameterSpec;
import javax.crypto.Cipher;
import javax.crypto.CipherOutputStream;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

/**
 * Generates an application license, which consists of a hostname, expiration date, and feature id encoded into a hex character string.
 * Be sure to use the SAME secret key and initialization vector as used in net.ims.jcms.License!!!
 *
 *
 * @author Sam Hokin <sam@ims.net>
 * @version 0.01
 */
public class LicenseGenerator {

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

  // deserialize the key
  private static SecretKey key;

  // buffer for I/O
  static byte[] buf = new byte[1024];

  public static void main(String args[]) {

    try {

      // deserialize key from byte array
      ByteArrayInputStream in = new ByteArrayInputStream(keyBytes);
      ObjectInputStream ois = new ObjectInputStream(in);
      SecretKey key = (SecretKey)ois.readObject();
      ois.close();
      in.close();
      
      // create the cipher object
      AlgorithmParameterSpec paramSpec = new IvParameterSpec(iv);
      Cipher ecipher = Cipher.getInstance(cipherAlgorithm);
      ecipher.init(Cipher.ENCRYPT_MODE, key, paramSpec);  // CBC requires an initialization vector
      
      // encrypt to a byte stream
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      CipherOutputStream cos = new CipherOutputStream(out, ecipher);
      cos.write(args[0].getBytes());
      cos.flush();
      out.flush();
      
      // get encrypted output into a byte array
      byte[] licenseBytes = out.toByteArray();
      
      // convert to a hex string
      StringBuffer licenseHex = new StringBuffer();
      for (int i=0; i<licenseBytes.length; i++) {
	licenseHex.append(Util.byteToHex(licenseBytes[i]));
      }
      
      // display the result
      System.out.println(args[0]);
      System.out.println(licenseHex);
      
    } catch (Exception e) {
      
      System.err.println(e.getMessage());
      
    }
    
  }
  
}
