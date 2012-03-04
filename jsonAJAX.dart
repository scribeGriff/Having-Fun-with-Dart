#import('dart:html');
#import('dart:json');
#resource('jsonAJAX.css');

class jsonAJAX {
  DivElement _output;
  DivElement _feedCont;
  DivElement _poweredBy;
  DivElement _blogOut;
  DivElement _githubOut;
  DivElement _tabOneFocus;
  DivElement _tabOneReady;
  DivElement _tabTwoFocus;
  DivElement _tabTwoReady;
  String feedURL;
  String githubURL;
  String githubURL2;
  String githubURL3;
  String githubUser;
  num feedOff = -1;
  num feedLim = 1;
  num githubLim = 10;
  num totalEntries;
  XMLHttpRequest githubXHR;

  //We use the constructor function to create the tabbed panel.
  jsonAJAX() {
    _feedCont = window.document.query('#feedContainer');
    _feedCont.innerHTML = "";
    //Create Tab One Focus Div:
    _tabOneFocus = new Element.tag("div");
    _tabOneFocus.attributes = ({
      "id": "tabOneFocus",
      "class": "tab",
      "style": "display:block;"
    });
    _tabOneFocus.innerHTML = "Blog Feed";
    _feedCont.nodes.add(_tabOneFocus);
    //Create Tab One Ready Div:
    _tabOneReady = new Element.tag("div");
    _tabOneReady.attributes = ({
      "id": "tabOneReady",
      "class": "tab",
      "style": "display:none;"
    });
    _tabOneReady.innerHTML = "Blog Feed";
    _feedCont.nodes.add(_tabOneReady);
    //Create Tab Two Focus Div:
    _tabTwoFocus = new Element.tag("div");
    _tabTwoFocus.attributes = ({
      "id": "tabTwoFocus",
      "class": "tab",
      "style": "display:none;"
    });
    _tabTwoFocus.innerHTML = "Repos Watched";
    _feedCont.nodes.add(_tabTwoFocus);
    //Create Tab Two Ready Div:
    _tabTwoReady = new Element.tag("div");
    _tabTwoReady.attributes = ({
      "id": "tabTwoReady",
      "class": "tab",
      "style": "display:block;"
    });
    _tabTwoReady.innerHTML = "Repos Watched";
    _feedCont.nodes.add(_tabTwoReady);
    //Powered by Dart!
    _poweredBy = new Element.tag("div");
    _poweredBy.id = "poweredBy";
    _feedCont.nodes.add(_poweredBy);
    _poweredBy.innerHTML = 
        '''
        <a href='http://www.dartlang.org/'>
        powered by <span class='dartClass'>Dart</span></a>''';
    //Blog feed div:
    _blogOut = new Element.tag("div");
    _blogOut.id = "blogOut";
    _feedCont.nodes.add(_blogOut);
    //Github feed div:
    _githubOut = new Element.tag("div");
    _githubOut.id = "githubOut";
    _feedCont.nodes.add(_githubOut);
    
    //Now add the click listeners to the two tabs in their ready state.
    _tabOneReady.on.click.add((e) {
      var displayList = [_tabOneFocus,_tabTwoReady,_blogOut];
      changeDisplay(displayList);
    });
    
    _tabTwoReady.on.click.add((e) {
      var displayList = [_tabOneReady,_tabTwoFocus,_githubOut];
      changeDisplay(displayList);
    });
    
    //Define the path to the total blog entries for Dart category
    // and the path to the Github repositories.
    githubUser = "scribeGriff";
    feedURL = "http://www.greatandlittle.com/studios/index.php?rest/" + 
        "blog&f=getPosts&cat_url=Google/Dart&count_only=1";
    githubURL = "https://api.github.com/users/$githubUser/watched";
  }
  
  //Controls the tabbed panel by deciding which divs should be displayed
  //and which should not.  Called by the click listeners.
  void changeDisplay(var displayList) {
    var idList = [_tabOneFocus,_tabTwoFocus,_tabOneReady, 
                  _tabTwoReady,_blogOut,_githubOut];
    for(var i = 0; i < idList.length; i++) {
      var block = false;
      for(var j = 0; j < displayList.length; j++) {
         if(idList[i] == displayList[j]) {
            block = true;
            break;
            }
         }
      if (block) {
        idList[i].style.display = "block";
      } else {
        idList[i].style.display = "none";
      }
    }
  }
  
  //The run() method is called by main() and retrieves
  //the total entries in the blog feed for the Dart category
  void run() {
    XMLHttpRequest tEn = new XMLHttpRequest.getTEMPNAME(feedURL, (jsonRequest) {
      var jsonResponse = JSON.parse(jsonRequest.responseText);
      totalEntries = jsonResponse["data"];
      iterateEntries();
    });
  }

  //Iterate through each blog entry for valid json data.
  void iterateEntries() {
    XMLHttpRequest xhr;
    var jsonResponse;
    
    if(totalEntries > 0) {
      totalEntries--;
      feedOff++;
      feedURL = "http://www.greatandlittle.com/studios/index.php?rest/" +
          "blog&f=getPosts&cat_url=Google/Dart&offset=$feedOff&limit=$feedLim";
      xhr = new XMLHttpRequest.getTEMPNAME(feedURL, (jsonRequest) {
        try {
          jsonResponse = JSON.parse(jsonRequest.responseText);
          //Valid data, process the response.
          processResponse(jsonResponse);
        } catch (var exception) {
          print("invalid json: $exception");
          //Invalid data, try again.
          iterateEntries();
        }
      });
    } else {
      //Done with blog entries, on to github.
      githubFeed();
    }
  }
  
  //Received valid data.  Create the feed entry using bracket notation.
  void processResponse(var jsonResponse) {
    HeadingElement titleHeading = new Element.tag("h2");
    String link = "http://www.greatandlittle.com/studios/index.php?post/" +
        "${jsonResponse["data"][0]["url"]}"; 
    titleHeading.text += "${jsonResponse["data"][0]["title"]}";
    _blogOut.nodes.add(titleHeading);
    _blogOut.innerHTML += "${jsonResponse["data"][0]["excerpt"]}";
    _blogOut.innerHTML += "<a href='$link'>read full entry</a><br>";
    _blogOut.innerHTML += 
        "Entry created ${jsonResponse["data"][0]["creadt"]}<br>";
    _blogOut.innerHTML += 
        "Entry modified ${jsonResponse["data"][0]["upddt"]}<br>";
    //Finished with this entry, now try to retrieve another one.
    iterateEntries();
  }
  
  //Finished with blog feed, let's look at github repositories:
  void githubFeed() {
    var jsonResponse;
    githubXHR = new XMLHttpRequest();
    //Check if browser understands XHR2.
    if(githubXHR.withCredentials != null) {
      githubXHR.open("GET", githubURL, true);
      githubXHR.on.load.add((e) {
        jsonResponse = JSON.parse(githubXHR.responseText);
        //Have the JSON data, now to process it.
        processGits(jsonResponse);
      });
      //Use an error handler on XHR.
      githubXHR.on.error.add((e) {
        _githubOut.innerHTML += "There was an error loading this feed.<br>";
      });
      githubXHR.send(null);
    //No browser support for XHR2.
    } else {
      _githubOut.innerHTML += "This browser doesn't appear to support XHR2";
    }
  }
  
  //Valid JSON response, now to retrieve the data using bracket notation.
  void processGits(var jsonResponse) {
    //Make a note of when we retrieved the data.
    Date creationTime = new Date.now();
    HeadingElement titleHeading = new Element.tag("h2");
    titleHeading.text = 
        "$githubUser is watching ${jsonResponse.length} repositories:";
    _githubOut.nodes.add(titleHeading);
    HeadingElement dateHeading = new Element.tag("p");
    dateHeading.text = "data is current as of $creationTime";
    _githubOut.nodes.add(dateHeading);
    //Loop through each entry in the JSON response:
    for (var i = 0; i < jsonResponse.length; i++) {
      //Each entry is wrapped in a div with class = "reposClass".
      DivElement _reposDiv = new Element.tag("div");
      _reposDiv.attributes = ({
        "class": "reposClass"
      });
      _githubOut.nodes.add(_reposDiv);
      _reposDiv.innerHTML += 
          '''
          <a href='${jsonResponse[i]["owner"]["url"]}'><img src=
          '${jsonResponse[i]["owner"]["avatar_url"]}'></a>''';
      _reposDiv.innerHTML += 
          '''
          <a href='${jsonResponse[i]["html_url"]}'>
          ${jsonResponse[i]["description"]}</a><br>''';
      _reposDiv.innerHTML += 
          "Coded by ${jsonResponse[i]["owner"]["login"]}<br>";
      _reposDiv.innerHTML += 
          "Last updated at ${jsonResponse[i]["updated_at"]}<br>";
      _reposDiv.innerHTML += 
          "This repo has ${jsonResponse[i]["watchers"]} watchers<br>";
    }
  }
}

void main() {
  new jsonAJAX().run();
}
