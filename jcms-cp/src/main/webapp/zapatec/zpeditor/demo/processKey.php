<?php
/**
 * Function converts an Javascript escaped string back into a string with specified charset (default is UTF-8).
 *
 * @param string $source escaped with Javascript's escape() function
 * @param string $iconv_to destination character set will be used as second paramether in the iconv function. Default is UTF-8.
 * @return string
 */
function unescape($source, $iconv_to = 'UTF-8') {
   $decodedStr = '';
   $pos = 0;
   $len = strlen ($source);
   while ($pos < $len) {
       $charAt = substr ($source, $pos, 1);
       if ($charAt == '%') {
           $pos++;
           $charAt = substr ($source, $pos, 1);
           if ($charAt == 'u') {
               // we got a unicode character
               $pos++;
               $unicodeHexVal = substr ($source, $pos, 4);
               $unicode = hexdec ($unicodeHexVal);
               $decodedStr .= code2utf($unicode);
               $pos += 4;
           }
           else {
               // we have an escaped ascii character
               $hexVal = substr ($source, $pos, 2);
               $decodedStr .= chr (hexdec ($hexVal));
               $pos += 2;
           }
       }
       else {
           $decodedStr .= $charAt;
           $pos++;
       }
   }

   if ($iconv_to != "UTF-8") {
       $decodedStr = iconv("UTF-8", $iconv_to, $decodedStr);
   }

   return $decodedStr;
}

/**
 * Function coverts number of utf char into that character.
 *
 * @param int $num
 * @return utf8char
 */
function code2utf($num){
   if($num<128)return chr($num);
   if($num<2048)return chr(($num>>6)+192).chr(($num&63)+128);
   if($num<65536)return chr(($num>>12)+224).chr((($num>>6)&63)+128).chr(($num&63)+128);
   if($num<2097152)return chr(($num>>18)+240).chr((($num>>12)&63)+128).chr((($num>>6)&63)+128) .chr(($num&63)+128);
   return '';
}

if(isset($_GET['key'])){
	$key = $_GET['key'];
	$key = ereg_replace("[^a-zA-Z0-9]", '', $key);

	$filename = "$key.txt";

	if(isset($_POST['content'])){
		$f = fopen($filename, "w");
		$content = $_POST['content'];
		$content = unescape($content);
		// Mark file as unicode
		fwrite($f, pack("CCC", 0xef, 0xbb, 0xbf));
		fwrite($f, $content);
		fclose($f);
	} else if(file_exists($filename)){
		$f = fopen($filename, "r");
		echo fread($f, filesize($filename));
		fclose($f);
	} else {
		header("HTTP/1.0 404 Not Found");
		echo "No such content";
	}
}
?>
