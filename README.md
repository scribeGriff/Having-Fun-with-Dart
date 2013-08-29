# A Tabbed Panel Feed Reader in Dart #

Dart Editor version 0.6.21\_r26639   
Dart SDK version 0.6.21.3_r26639  
8/29/2013 1:29:11 PM    
See the blog entry at [scribeGriff.com/studios](http://www.greatandlittle.com/studios/index.php?post/2012/02/21/Having-Fun-with-Dart-AJAX-and-JSON) for a detailed explanation of the code.     
Comments: Update to use `'dart:convert'`   
Tags: Dart, JSON, AJAX, CORS, XHR, XHR2

----------

## Usage: ##

````dart
void main() {
  new TabbedFeedReader().loadFeed();
}
````

## Revision History ##

**1.) 29 Aug 2013:** The `'dart:json'` library is being removed.  Using `'dart:convert'` instead. The equivalent of `stringify` is dart:convert's `JSON.encode`, and the equivalent of `parse` is `JSON.decode`.

**2.) 23 Jan 2013:** Includes M2 fixes such as addHtml becoming appendHtml.  Biggest change is import of dart:json library:

    import 'dart:json';

is now (lower case is recommended for prefixes):

    import 'dart:json' as json;

This is because both parse and stringify are now top level functions.  By importing the library as json, we can keep the syntax as:

    json.parse(response);

Some of the code is also now using static methods that return futures for the HttpRequest (expect more updates related to this).  So:

    new XMLHttpRequest.get(_feedURL, (jsonRequest)...

is now:

    HttpRequest.request(_feedURL).then((jsonRequest)...



**3.) 22 Sept 2012:** XMLHttpRequest is now HttpRequest in Dart.  
Replaced instances of
    
    new XMLHttpRequest.get(_feedURL, (jsonRequest)...

with:

    new HttpRequest.get(_feedURL, (jsonRequest)...

Dart now has much nicer syntax for dealing with HTML (addHTML) and Text (addText).  
Replaced instances of:

    element.insertAdjacentHTML('beforeend', 'htmlString');

with:

    element.addHTML('htmlString);

General pre-M1 changes including removal of #resource and var keyword from try-catch statements. 

**4.) 16 June 2012:** Removed use of '+' string concatenation operator.  
Replaced instances of:

    element.innerHTML += 'htmlString';

with:

    element.insertAdjacentHTML('beforeend', 'htmlString');

**5.) 19 May 2012:** Updated to Dart Editor build 7552.

    _feedCont = window.document.query('#feedContainer'); 
became

    _feedCont = document.query('#feedContainer');
and

    xhr = new XMLHttpRequest.getTEMPNAME(feedURL, (jsonRequest)
is now

    xhr = new XMLHttpRequest.get(feedURL, (jsonRequest)

**6.) 21 February 2012:** Initial release with Dart Editor build 4577.



## Classes: ##

    class TabbedFeedReader



## Methods/functions ##

    constructor - TabbedFeedReader()
    void _changeDisplay(List _displayList)
    void loadFeed()
    void _iterateEntries()
    void _processResponse(var jsonResponse)
    void _githubFeed()
    void _processGits(var jsonResponse)

