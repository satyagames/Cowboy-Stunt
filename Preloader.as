class Preloader
{
    var root_mc, meter_mc, callbackObj, callbackFunc, levelData, levelDataURLs, watchURLs, numLevelsLoaded, preloadCheck, tellFriendURL;
    function Preloader(root_mc, meter_mc, gameDataURL, callbackObj, callbackFunc)
    {
        var _loc3;
        var _loc4 = this;
        this.root_mc = root_mc;
        this.meter_mc = meter_mc;
        this.callbackObj = callbackObj;
        this.callbackFunc = callbackFunc;
        levelData = [];
        levelDataURLs = [];
        watchURLs = [];
        numLevelsLoaded = 0;
        _loc3 = new XML(_root.gameData);
        this.parseGameData(_loc3);
        preloadCheck = setInterval(this, "update", 20);
    } // End of the function
    function parseGameData(gd)
    {
        var _loc3;
        for (var gd = gd.childNodes[0].childNodes[0]; gd != null; gd = gd.nextSibling)
        {
            if (gd.nodeName == "level")
            {
                levelDataURLs.push(gd.childNodes[0].toString());
                continue;
            } // end if
            if (gd.nodeName == "link")
            {
                _loc3 = gd.childNodes[0].toString();
                _loc3 = this.replace(_loc3, "&amp;", "&");
                watchURLs.push(_loc3);
                continue;
            } // end if
        } // end of for
        this.loadLevelData(levelDataURLs);
    } // End of the function
    function loadLevelData(levelDataURLs)
    {
        var _loc3;
        var _loc5 = this;
        for (var _loc3 = 0; _loc3 < levelDataURLs.length; ++_loc3)
        {
            levelData[_loc3] = new XML(_root["level" + (_loc3 + 1) + "Data"]);
        } // end of for
    } // End of the function
    function update()
    {
        var _loc4;
        var _loc3;
        var _loc2;
        _loc4 = root_mc.getBytesLoaded();
        _loc3 = root_mc.getBytesTotal();
        _loc2 = Math.round(100 * _loc4 / _loc3);
        meter_mc.watchFaceA_mc.gotoAndStop(_loc2);
        meter_mc.watchFaceB_mc.gotoAndStop(_loc2);
        meter_mc.watchFaceC_mc.gotoAndStop(_loc2);
        meter_mc.watchFaceA_mc.percentLoaded_txt.text = Math.min(99, _loc2);
        meter_mc.watchFaceB_mc.percentLoaded_txt.text = Math.min(99, _loc2);
        meter_mc.watchFaceC_mc.percentLoaded_txt.text = Math.min(99, _loc2);
        if (_loc2 == 100)
        {
            clearInterval(preloadCheck);
            this.loadComplete();
            meter_mc.gotoAndPlay(2);
        } // end if
    } // End of the function
    function levelDataLoaded()
    {
        return (numLevelsLoaded == levelDataURLs.length && tellFriendURL != undefined);
    } // End of the function
    function loadComplete()
    {
        var _loc2 = [];
        clearInterval(preloadCheck);
        _loc2 = [[levelData, watchURLs, tellFriendURL]];
        callbackFunc.apply(callbackObj, _loc2);
    } // End of the function
    function replace(s, subOld, subNew)
    {
        return (s.split(subOld).join(subNew));
    } // End of the function
} // End of Class
