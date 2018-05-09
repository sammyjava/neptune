/**
 * Request the given URL and update the message div with the response
 */
function fetchUrl(urlName) {
  // Fetch HTML fragment
  Zapatec.Transport.fetch({
  // synchronous
  async: false,
  // URL to fetch
  url: urlName,
  // Onload event handler
  onLoad: function(objRequest) {
    var div = document.getElementById('message');
    // Put fetched fragment into div
    Zapatec.Transport.setInnerHtml({
      html: objRequest.responseText,
      container: div
      });
    }
  });
}
