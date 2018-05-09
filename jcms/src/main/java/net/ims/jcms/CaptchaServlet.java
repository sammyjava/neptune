package net.ims.jcms;

import nl.captcha.Captcha;
import nl.captcha.Captcha.Builder;
import nl.captcha.servlet.CaptchaServletUtil;

import nl.captcha.text.producer.DefaultTextProducer;
import nl.captcha.text.producer.FiveLetterFirstNameTextProducer;

import nl.captcha.text.renderer.WordRenderer;
import nl.captcha.text.renderer.ColoredEdgesWordRenderer;
import nl.captcha.text.renderer.DefaultWordRenderer;

import nl.captcha.backgrounds.BackgroundProducer;
import nl.captcha.backgrounds.FlatColorBackgroundProducer;
import nl.captcha.backgrounds.GradiatedBackgroundProducer;
import nl.captcha.backgrounds.SquigglesBackgroundProducer;
import nl.captcha.backgrounds.TransparentBackgroundProducer;

import nl.captcha.noise.CurvedLineNoiseProducer;

import nl.captcha.gimpy.GimpyRenderer;
import nl.captcha.gimpy.BlockGimpyRenderer;
import nl.captcha.gimpy.DropShadowGimpyRenderer;
import nl.captcha.gimpy.FishEyeGimpyRenderer;
import nl.captcha.gimpy.RippleGimpyRenderer;
import nl.captcha.gimpy.ShearGimpyRenderer;
import nl.captcha.gimpy.StretchGimpyRenderer;

import java.awt.Color;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet to generate and respond with a customized CAPTCHA image.  Many customization parameters can be provided
 * as servlet init parameters:
 *
 * parameter                                example
 * --------------------------------------   ----------
 * captcha.width                            130 (default)
 * captcha.height                            50 (default)
 * captcha.text.length                        5 (default)
 * captcha.text.chars                       2,3,4,5,7,8,9,a,c,d,e,f,h,j,k,m,n,p,s,t,v,w,x,y,z (default)
 * captcha.text.firstname                   true
 * captcha.text.colorededges                true
 * captcha.background.transparent           true
 * captcha.background.squiggles             true
 * captcha.background.flatcolor             150,170,190 (0,0,0 to turn off)
 * captcha.background.gradiatedcolorstart   100,100,100 (default) (0,0,0 to turn off)
 * captcha.background.gradiatedcolorend     250,250,250 (default) (0,0,0 to turn off)
 * captcha.noise.color                      150,150,150 (default) (0,0,0 to turn off)
 * captcha.noise.width                      5.0 (default)
 * captcha.gimpy.block                      true
 * captcha.gimpy.dropshadow                 true
 * captcha.gimpy.fisheye                    true
 * captcha.gimpy.ripple                     true
 * captcha.gimpy.shear                      true
 * captcha.gimpy.stretch                    true
 * captcha.border                           true
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class CaptchaServlet extends HttpServlet {

  // default customization parameters
  char[] chars = {'2','3','4','5','7','8','9','a','c','d','e','f','h','j','k','m','n','p','s','t','v','w','x','y','z'};
  int width = 130;
  int height = 50;
  int length = 5;
  Color fromColor = new Color(100,100,100);
  Color toColor = new Color(250,250,250);
  Color noiseColor = new Color(150,150,150);
  float noiseWidth = 5.0f;

  /**
   * Process a CAPTCHA GET request.
   */
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    ServletConfig config = getServletConfig();

    if (isSet(config.getInitParameter("captcha.width")) && isSet(config.getInitParameter("captcha.height"))) {
      width = Integer.parseInt(config.getInitParameter("captcha.width"));
      height = Integer.parseInt(config.getInitParameter("captcha.height"));
    }

    Captcha.Builder builder = new Captcha.Builder(width, height);

    // TextProducer
    WordRenderer wordRenderer = null;
    if (isTrue(config.getInitParameter("captcha.text.colorededges"))) {
      wordRenderer = new ColoredEdgesWordRenderer();
    } else {
      wordRenderer = new DefaultWordRenderer();
    }
    if (isTrue(config.getInitParameter("captcha.text.firstname"))) {
      builder.addText(new FiveLetterFirstNameTextProducer(), wordRenderer);
    } else {
      if (isSet(config.getInitParameter("captcha.text.length"))) length = Integer.parseInt(config.getInitParameter("captcha.text.length"));
      if (isSet(config.getInitParameter("captcha.text.chars"))) {
	String[] charsArray = config.getInitParameter("captcha.text.chars").split(",");
	chars = new char[charsArray.length];
	for (int i=0; i<chars.length; i++) chars[i] = charsArray[i].charAt(0);
      }
      builder.addText(new DefaultTextProducer(length, chars), wordRenderer); // default
    }

    // BackgroundProducer
    if (isTrue(config.getInitParameter("captcha.background.transparent"))) {
      builder.addBackground(new TransparentBackgroundProducer());
    } else if (isTrue(config.getInitParameter("captcha.background.squiggles"))) {
      builder.addBackground(new SquigglesBackgroundProducer());
    } else if (isSet(config.getInitParameter("captcha.background.flatcolor")) && !isBlack(config.getInitParameter("captcha.background.flatcolor"))) {
      Color color = parseColor(config.getInitParameter("captcha.background.flatcolor"));
      builder.addBackground(new FlatColorBackgroundProducer(color));
    } else if (isSet(config.getInitParameter("captcha.background.gradiatedcolorstart")) && isSet(config.getInitParameter("captcha.background.gradiatedcolorend")) &&
	       !isBlack(config.getInitParameter("captcha.background.gradiatedcolorstart")) && !isBlack(config.getInitParameter("captcha.background.gradiatedcolorend"))) {
      fromColor = parseColor(config.getInitParameter("captcha.background.gradiatedcolorstart"));
      toColor = parseColor(config.getInitParameter("captcha.background.gradiatedcolorend"));
      builder.addBackground(new GradiatedBackgroundProducer(fromColor, toColor));
    } else {
      builder.addBackground(new GradiatedBackgroundProducer(fromColor, toColor)); // default
    }
      
    // NoiseProducer
    if (isSet(config.getInitParameter("captcha.noise.color")) && isBlack(config.getInitParameter("captcha.noise.color"))) {
      // do nothing
    } else if (isSet(config.getInitParameter("captcha.noise.color")) && isSet(config.getInitParameter("captcha.noise.width"))) {
      noiseColor = parseColor(config.getInitParameter("captcha.noise.color"));
      noiseWidth = Float.parseFloat(config.getInitParameter("captcha.noise.width"));
      builder.addNoise(new CurvedLineNoiseProducer(noiseColor, noiseWidth));
    } else {
      builder.addNoise(new CurvedLineNoiseProducer(noiseColor, noiseWidth)); // default
    }      

    // gimp can be used multiple times
    if (isTrue(config.getInitParameter("captcha.gimpy.block"))) builder.gimp(new BlockGimpyRenderer());
    if (isTrue(config.getInitParameter("captcha.gimpy.dropshadow"))) builder.gimp(new DropShadowGimpyRenderer());
    if (isTrue(config.getInitParameter("captcha.gimpy.fisheye"))) builder.gimp(new FishEyeGimpyRenderer());
    if (isTrue(config.getInitParameter("captcha.gimpy.ripple"))) builder.gimp(new RippleGimpyRenderer());
    if (isTrue(config.getInitParameter("captcha.gimpy.shear"))) builder.gimp(new ShearGimpyRenderer());
    if (isTrue(config.getInitParameter("captcha.gimpy.stretch"))) builder.gimp(new StretchGimpyRenderer());

    // border
    if (isTrue(config.getInitParameter("captcha.border"))) builder.addBorder();

    Captcha captcha = builder.build();

    request.getSession().setAttribute(Captcha.NAME, captcha);

    response.setContentType("image/png");

    CaptchaServletUtil.writeImage(response, captcha.getImage());

  }

  static Color parseColor(String s) {
    String[] rgb = s.split(",");
    int r = Integer.parseInt(rgb[0]);
    int g = Integer.parseInt(rgb[1]);
    int b = Integer.parseInt(rgb[2]);
    return new Color(r,g,b);
  }

  static boolean isSet(String s) {
    return (s!=null);
  }

  static boolean isBlack(String s) {
    Color c = parseColor(s);
    return (c.equals(Color.BLACK));
  }

  static boolean isTrue(String s) {
    return (s!=null && s.equals("true"));
  }
  
}
