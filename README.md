# A Tabbed Panel Feed Reader in Dart #

Compliant with Dart Editor build 17463 (M3)  
3:40 PM Wednesday, January 23, 2013 
Blog entry at [scribeGriff.com/studios](http://www.greatandlittle.com/studios/index.php?post/2012/02/21/Having-Fun-with-Dart-AJAX-and-JSON)  
Comments: M3 revision.    
Tags: Dart, JSON, AJAX, CORS, XHR, XHR2

----------

## Revision History ##

**1.) 23 Jan 2013:** Includes M2 fixes such as addHtml becoming appendHtml.  Biggest change is import of dart:json library:

    import 'dart:json';

is now:

    import 'dart:json' as JSON;

This is because both parse and stringify are now top level functions.  By importing the library as JSON, we can keep the syntax as:

    JSON.parse(response);



**2.) 22 Sept 2012:** XMLHttpRequest is now HttpRequest in Dart.  
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

**3.) 16 June 2012:** Removed use of '+' string concatenation operator.  
Replaced instances of:

    element.innerHTML += 'htmlString';

with:

    element.insertAdjacentHTML('beforeend', 'htmlString');

**4.) 19 May 2012:** Updated to Dart Editor build 7552.

    _feedCont = window.document.query('#feedContainer'); 
became

    _feedCont = document.query('#feedContainer');
and

    xhr = new XMLHttpRequest.getTEMPNAME(feedURL, (jsonRequest)
is now

    xhr = new XMLHttpRequest.get(feedURL, (jsonRequest)

**5.) 21 February 2012:** Initial release with Dart Editor build 4577.

----------

## Usage: ##

    void main() {
      new TabbedFeedReader().loadFeed();
    }

----------

## Classes: ##

    class TabbedFeedReader

----------

## Methods/functions ##

    constructor - TabbedFeedReader()
    void _changeDisplay(List _displayList)
    void loadFeed()
    void _iterateEntries()
    void _processResponse(var jsonResponse)
    void _githubFeed()
    void _processGits(var jsonResponse)

