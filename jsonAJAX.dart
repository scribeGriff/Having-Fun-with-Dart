#import('dart:html');
#import('dart:json');
#resource('jsonAJAX.css');

/*************************************
* Class TabbedFeedReader             *
* Dart Editor Build 8370             *
* Creates a tabbed panel feed reader *
**************************************/
class TabbedFeedReader {
  // Div elements
  DivElement _output;
  DivElement _feedCont;
  DivElement _poweredBy;
  DivElement _blogOut;
  DivElement _githubOut;
  DivElement _tabOneFocus;
  DivElement _tabOneReady;
  DivElement _tabTwoFocus;
  DivElement _tabTwoReady;
  // Feed path strings
  String _feedURLCnt;
  String _feedURL;
  String _githubURL;
  String _githubUser;
  // Feed variables
  int _feedOff = -1;
  int _feedLim = 1;
  int _totalEntries;

  /******************************************************
  * Constructor creates the tabbed panel for displaying *
  * the blog feed and github watched repos.             *
  *******************************************************/
  TabbedFeedReader() {
    _feedCont = document.query('#feedContainer');
    _feedCont.innerHTML = "";

    /*************************************************************
     * Create tab one 'focus' div and set its name to Blog Feed. *
     *************************************************************/
    _tabOneFocus = new Element.tag("div");
    _tabOneFocus.attributes = ({
      "id": "tabOneFocus",
      "class": "tab",
      "style": "display:block;"
    });
    _tabOneFocus.innerHTML = "Blog Feed";
    _feedCont.nodes.add(_tabOneFocus);

    /*************************************************************
     * Create tab one 'ready' div and set its name to Blog Feed. *
     *************************************************************/
    _tabOneReady = new Element.tag("div");
    _tabOneReady.attributes = ({
      "id": "tabOneReady",
      "class": "tab",
      "style": "display:none;"
    });
    _tabOneReady.innerHTML = "Blog Feed";
    _feedCont.nodes.add(_tabOneReady);

    /*****************************************************************
     * Create tab two 'focus' div and set its name to Repos Watched. *
     *****************************************************************/
    _tabTwoFocus = new Element.tag("div");
    _tabTwoFocus.attributes = ({
      "id": "tabTwoFocus",
      "class": "tab",
      "style": "display:none;"
    });
    _tabTwoFocus.innerHTML = "Repos Watched";
    _feedCont.nodes.add(_tabTwoFocus);

    /*****************************************************************
     * Create tab two 'ready' div and set its name to Repos Watched. *
     *****************************************************************/
    _tabTwoReady = new Element.tag("div");
    _tabTwoReady.attributes = ({
      "id": "tabTwoReady",
      "class": "tab",
      "style": "display:block;"
    });
    _tabTwoReady.innerHTML = "Repos Watched";
    _feedCont.nodes.add(_tabTwoReady);

    /*******************************************
     * The little 'Powered by Dart' icon.      *
     *******************************************/
    _poweredBy = new Element.tag("div");
    _poweredBy.id = "poweredBy";
    _feedCont.nodes.add(_poweredBy);
    _poweredBy.innerHTML =
        "<a href='http://www.dartlang.org/'> powered by <span class='dartClass'>Dart</span></a>";

    /****************************************************************
     * Create the blog feed div and give it an id of 'blogOut'.     *
     ****************************************************************/
    _blogOut = new Element.tag("div");
    _blogOut.id = "blogOut";
    _feedCont.nodes.add(_blogOut);

    /****************************************************************
     * Create the Github feed div and give it an id of 'githubOut'. *
     ****************************************************************/
    _githubOut = new Element.tag("div");
    _githubOut.id = "githubOut";
    _feedCont.nodes.add(_githubOut);

    /*****************************************************************
     * Add event listeners to the two 'ready' tabs and call function *
     * changeDisplay() which is passed a display list that control   *
     * the state of the tabbed panel.                                *
     *****************************************************************/
    _tabOneReady.on.click.add((e) {
      List _displayList = [_tabOneFocus,_tabTwoReady,_blogOut];
      _changeDisplay(_displayList);
    });

    _tabTwoReady.on.click.add((e) {
      List _displayList = [_tabOneReady,_tabTwoFocus,_githubOut];
      _changeDisplay(_displayList);
    });

    /*****************************************************************
     * Define the various feed paths for the blog's Dart category    *
     * and the path to the Github repositories.                      *
     *****************************************************************/
    // define github user
    _githubUser = "scribeGriff";
    // feed path that returns total entries in category Dart
    _feedURLCnt = "http://www.scribegriff.com/studios/index.php?rest/"
        "blog&f=getPosts&cat_url=Google/Dart&count_only=1";
    // feed path that allows iterating through each entry
    _feedURL = "http://www.scribegriff.com/studios/index.php?rest/"
        "blog&f=getPosts&cat_url=Google/Dart&offset=$_feedOff&limit=$_feedLim";
    // github feed for watched repositories
    _githubURL = "https://api.github.com/users/$_githubUser/watched";
  }

  /***************************************************************************
   * changeDisplay() controls the tabbed panel by deciding which divs should *
   * have their display set to 'block' and which should be set to 'none'.    *
   * This function is called by the listeners attached to each ready tab.    *
   ***************************************************************************/
  void _changeDisplay(List _displayList) {
    List _idList = [_tabOneFocus,_tabTwoFocus,_tabOneReady,
                  _tabTwoReady,_blogOut,_githubOut];
    for(int i = 0; i < _idList.length; i++) {
      var block = false;
      for(int j = 0; j < _displayList.length; j++) {
         if(_idList[i] == _displayList[j]) {
            block = true;
            break;
            }
         }
      if (block) {
        _idList[i].style.display = "block";
      } else {
        _idList[i].style.display = "none";
      }
    }
  }

  /**********************************************************************
   * The loadFeed() method is called by main() and begins by retrieving *
   * the total entries in the blog feed for the Dart category           *
   **********************************************************************/
  void loadFeed() {
    XMLHttpRequest tEn = new XMLHttpRequest.get(_feedURLCnt, (jsonRequest) {
      var jsonResponse = JSON.parse(jsonRequest.responseText);
      _totalEntries = jsonResponse["data"];
      // Once total entries is known, make AJAX requests to retrieve each.
      _iterateEntries();
    });
  }

  /**********************************************************************
   * The iterateEntries() function takes the number of total entries    *
   * retrieved in the previous AJAX request and iterates through each   *
   * one with a try/catch statement.  If response is valid, passes the  *
   * json data to the processResponse() function.  If invalid, prints   *
   * the exception to the console and iterates to the next entry.  Once *
   * all entries have been processed, moves on to github feed.          *
   **********************************************************************/
  void _iterateEntries() {
    XMLHttpRequest xhr;
    var jsonResponse;

    if(_totalEntries > 0) {
      _totalEntries--;
      _feedOff++;
      //Update path based on new value of feed offset value _feedOff.
      _feedURL = "http://www.scribegriff.com/studios/index.php?rest/"
          "blog&f=getPosts&cat_url=Google/Dart&offset=$_feedOff&limit=$_feedLim";
      xhr = new XMLHttpRequest.get(_feedURL, (jsonRequest) {
        try {
          jsonResponse = JSON.parse(jsonRequest.responseText);
          // Valid data, process the response.
          _processResponse(jsonResponse);
        } catch (var exception) {
          print("invalid json: $exception");
          // Invalid data, try the next entry.
          _iterateEntries();
        }
      });
    } else {
      //Done with blog entries, on to github.
      _githubFeed();
    }
  }

  /**********************************************************************
   * The processResponse() function uses bracket notation to write the  *
   * feed data to HTML.  Once the entry has been written, returns to    *
   * iterateEntries() function to attempt to retrieve next entry        *
   **********************************************************************/
  void _processResponse(var jsonResponse) {
    HeadingElement titleHeading = new Element.tag("h2");
    String link = "http://www.scribegriff.com/studios/index.php?post/"
        "${jsonResponse["data"][0]["url"]}";
    titleHeading.text = "${jsonResponse["data"][0]["title"]}";
    _blogOut.nodes.add(titleHeading);
    _blogOut.insertAdjacentHTML("beforeend",
        "${jsonResponse["data"][0]["excerpt"]}");
    _blogOut.insertAdjacentHTML("beforeend",
        "<a href='$link'>read full entry</a><br>");
    _blogOut.insertAdjacentHTML("beforeend",
        "Entry created ${jsonResponse["data"][0]["creadt"]}<br>");
    _blogOut.insertAdjacentHTML("beforeend",
        "Entry modified ${jsonResponse["data"][0]["upddt"]}<br>");
    //Finished with this entry, now try to retrieve the next one.
    _iterateEntries();
  }

  /************************************************************************
   * Once all of the blog entries have been processed, we move on to the  *
   * github feed with function githubFeed().  Here we use a slightly      *
   * different AJAX request which represents some of the features of      *
   * XHR2, checking to see if browser understands CORS (IE9, for example, *
   * does not appear to) in the process.  The github CORS response is     *
   * processed as a single JSON data stream.                              *
   ************************************************************************/
  void _githubFeed() {
    var jsonResponse;
    XMLHttpRequest githubXHR = new XMLHttpRequest();
    //Check if browser understands XHR2.
    if(githubXHR.withCredentials != null) {
      githubXHR.open("GET", _githubURL, true);
      githubXHR.on.load.add((e) {
        jsonResponse = JSON.parse(githubXHR.responseText);
        //Have the JSON data, now to process it.
        _processGits(jsonResponse);
      });
      //Use an error handler on XHR.
      githubXHR.on.error.add((e) {
        _githubOut.insertAdjacentHTML("beforeend",
            "There was an error loading this feed.<br>");
      });
      githubXHR.send(null);
    //No browser support for XHR2.
    } else {
      _githubOut.insertAdjacentHTML("beforeend",
          "This browser doesn't appear to support XHR2");
    }
  }

  /************************************************************************
   * The processGits() function uses bracket notation to write the        *
   * feed data to HTML.  In this case, we loop through all entries        *
   * returned by the json response.                                       *
   ************************************************************************/
  void _processGits(var jsonResponse) {
    //Make a note of when we retrieved the data.
    Date creationTime = new Date.now();
    HeadingElement titleHeading = new Element.tag("h2");
    titleHeading.text =
        "$_githubUser is watching ${jsonResponse.length} repositories:";
    _githubOut.nodes.add(titleHeading);
    HeadingElement dateHeading = new Element.tag("p");
    dateHeading.text = "data is current as of $creationTime";
    _githubOut.nodes.add(dateHeading);
    //Loop through each entry in the JSON response:
    for (int i = 0; i < jsonResponse.length; i++) {
      //Each entry is wrapped in a div with class = "reposClass".
      DivElement _reposDiv = new Element.tag("div");
      _reposDiv.attributes = ({
        "class": "reposClass"
      });
      _githubOut.nodes.add(_reposDiv);
      _reposDiv.insertAdjacentHTML("beforeend",
          '''
          <a href='${jsonResponse[i]["owner"]["url"]}'><img src=
          '${jsonResponse[i]["owner"]["avatar_url"]}'></a>''');
      _reposDiv.insertAdjacentHTML("beforeend",
          '''
          <a href='${jsonResponse[i]["html_url"]}'>
          ${jsonResponse[i]["description"]}</a><br>''');
      _reposDiv.insertAdjacentHTML("beforeend",
          "Coded by ${jsonResponse[i]["owner"]["login"]}<br>");
      _reposDiv.insertAdjacentHTML("beforeend",
          "Last updated at ${jsonResponse[i]["updated_at"]}<br>");
      _reposDiv.insertAdjacentHTML("beforeend",
          "This repo has ${jsonResponse[i]["watchers"]} watchers<br>");
    }
  }
}

/************************************************************************
 * On page load, the main() function is called, which creates a new     *
 * instance of the TabbedFeedReader(), calling its method loadFeed()    *
 * to populate the tabbed panel with blog and github data               *
 ************************************************************************/
void main() {
  new TabbedFeedReader().loadFeed();
}
