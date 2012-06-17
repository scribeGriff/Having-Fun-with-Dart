# A Tabbed Panel Feed Reader in Dart #

Compliant with Dart Editor build 8370
9:57 PM Saturday, June 16, 2012
Blog entry at [scribeGriff.com/studios](http://www.greatandlittle.com/studios/index.php?post/2012/02/21/Having-Fun-with-Dart-AJAX-and-JSON)
Comments: Needs refractoring to replace static functions - TBD
Tags: JSON, AJAX, CORS, XHR, XHR2

----------

## Revision History ##
**1.) 16 June 2012:** Removed use of '+' string concatenation operator.  
Replaced instances of:

    element.innerHTML += 'htmlString';

with:

    element.insertAdjacentHTML('beforeend', 'htmlString');

**2.) 19 May 2012:** Updated to Dart Editor build 7552.

    _feedCont = window.document.query('#feedContainer'); 
became

    _feedCont = document.query('#feedContainer');
and

    xhr = new XMLHttpRequest.getTEMPNAME(feedURL, (jsonRequest)
is now

    xhr = new XMLHttpRequest.get(feedURL, (jsonRequest)

**3.) 21 February 2012:** Initial release with Dart Editor build 4577.

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

