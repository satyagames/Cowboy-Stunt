class Game
{
    var root_mc, watchURLs, soundOn, firstTime, currLevelNum, levelData, tellFriendURL, screechSound, crashSound, engineSound, thudSound, revSound, applauseSound, ambulanceSound, introMusicSound, inGameMusicSound, winMusicSound, loseMusicSound, reverseMusicSound, highestLevelReached, _parent, gotoAndStop, endLevelInterval, currWorld, pullBack, finishLine, launching, separated, jumpTimer, jumpSpeed, goComplete, initPanX, initPanInterval, launchStepNum, xLaunchMax, yLaunchMax, jumpEnd;
    function Game(root_mc, preloader_mc)
    {
        this.root_mc = root_mc;
        watchURLs = [];
        soundOn = true;
        firstTime = true;
        if (System.capabilities.playerType == "External" || System.capabilities.playerType == "StandAlone")
        {
            _root.gameDataURL = "xml/game_data.xml";
        } // end if
        new Preloader(root_mc, preloader_mc, _root.gameDataURL, this, preloadComplete);
    } // End of the function
    function getCurrentWatch()
    {
        var _loc2 = [];
        _loc2.push("Level1");
        _loc2.push("Level2");
        _loc2.push("Level3");
        _loc2.push("Level4");
        _loc2.push("Level5");
        _loc2.push("Level6");
        return ([_loc2[currLevelNum - 1], _loc2[currLevelNum]]);
    } // End of the function
    function getCurrentLevel()
    {
        return (currLevelNum);
    } // End of the function
    function handleClickThrough(type)
    {
        if (type == "generic")
        {
            getURL(watchURLs[0], "_blank");
        }
        else
        {
            getURL(watchURLs[currLevelNum], "_blank");
        } // end else if
    } // End of the function
    function preloadComplete(args)
    {
        levelData = args[0];
        watchURLs = args[1];
        tellFriendURL = args[2];
        root_mc.gotoAndStop("intro");
        screechSound = new Sound(root_mc);
        screechSound.attachSound("screech_snd");
        crashSound = new Sound(root_mc);
        crashSound.attachSound("crash_snd");
        engineSound = new Sound(root_mc);
        engineSound.attachSound("engine_snd");
        thudSound = new Sound(root_mc);
        thudSound.attachSound("thud_snd");
        revSound = new Sound(root_mc);
        revSound.attachSound("rev_snd");
        applauseSound = new Sound(root_mc);
        applauseSound.attachSound("applause_snd");
        ambulanceSound = new Sound(root_mc);
        ambulanceSound.attachSound("ambulance_snd");
        introMusicSound = new Sound(root_mc);
        introMusicSound.attachSound("introMusic_snd");
        inGameMusicSound = new Sound(root_mc);
        inGameMusicSound.attachSound("inGameMusic_snd");
        winMusicSound = new Sound(root_mc);
        winMusicSound.attachSound("winMusic_snd");
        loseMusicSound = new Sound(root_mc);
        loseMusicSound.attachSound("loseMusic_snd");
        reverseMusicSound = new Sound(root_mc);
        reverseMusicSound.attachSound("reverseMusic_snd");
    } // End of the function
    function initIntro()
    {
        var callback = this;
        currLevelNum = 0;
        highestLevelReached = 0;
        stopAllSounds ();
        if (soundOn)
        {
            introMusicSound.start(0, 9999);
        } // end if
        root_mc.intro_mc.fromMain = true;
        root_mc.intro_mc.play_btn.onRelease = function ()
        {
            callback.introMusicSound.stop();
            _parent.goingToGame = true;
            if (_parent._currentframe < 87)
            {
                _parent.gotoAndPlay(88);
            }
            else
            {
                _parent.play();
            } // end else if
        };
        root_mc.intro_mc.instructions_btn.onRelease = function ()
        {
            if (_parent.fromMain)
            {
                _parent.fromMain = false;
                _parent.gotoAndPlay("instructionsFromMain");
            }
            else
            {
                _parent.gotoAndPlay("instructions");
            } // end else if
        };
        root_mc.sound_btn.onRelease = function ()
        {
            callback.soundOn = !callback.soundOn;
            if (callback.soundOn)
            {
                this.gotoAndStop("up");
            }
            else
            {
                this.gotoAndStop("down");
                stopAllSounds ();
            } // end else if
        };
    } // End of the function
    function initEnding()
    {
        stopAllSounds ();
        if (soundOn)
        {
            applauseSound.start();
            winMusicSound.start(0, 9999);
        } // end if
    } // End of the function
    function restartLevel()
    {
        clearInterval(endLevelInterval);
        root_mc.nextFrame();
        root_mc.gotoAndStop("levels");
    } // End of the function
    function prevLevel()
    {
        clearInterval(endLevelInterval);
        root_mc.nextFrame();
        if (currLevelNum > 1)
        {
            --currLevelNum;
        } // end if
        root_mc.gotoAndStop("levels");
    } // End of the function
    function nextLevel()
    {
        clearInterval(endLevelInterval);
        root_mc.nextFrame();
        if (currLevelNum++ == levelData.length)
        {
            root_mc.gotoAndStop("gameFinished");
        }
        else
        {
            root_mc.gotoAndStop("levels");
        } // end else if
    } // End of the function
    function initLevel()
    {
        var _loc4;
        var _loc6;
        var _loc5;
        var _loc3;
        var _loc2;
        delete this.currWorld;
        delete this.pullBack;
        root_mc.level_mc.gotoAndStop(currLevelNum);
        root_mc.levelName_mc.gotoAndStop(currLevelNum);
        currWorld = new uk.co.kerb.physics.World(root_mc.level_mc.canvas_mc, this);
        finishLine = 0;
        this.parseLevelData(levelData[currLevelNum - 1]);
        _loc4 = root_mc.level_mc.canvas_mc.pullBack_mc;
        _loc6 = root_mc.level_mc.canvas_mc.pullBackLink_mc;
        _loc5 = root_mc.level_mc.canvas_mc.backWheel_mc;
        _loc3 = root_mc.level_mc.canvas_mc.smoke_mc;
        pullBack = new PullBack(_loc4, _loc6, _loc5, _loc3, this);
        launching = false;
        separated = false;
        jumpTimer = null;
        jumpSpeed = currWorld.getParticle(8).vCurr.x;
        root_mc.level_mc.levelComplete_mc._visible = false;
        root_mc.level_mc.levelRestart_mc._visible = false;
        root_mc.level_mc.levelDown_mc._visible = false;
        root_mc.level_mc.levelTimeOut_mc._visible = false;
        goComplete = false;
        currWorld.getParticle(9).locked = true;
        currWorld.getParticle(10).locked = true;
        currWorld.getParticle(13).locked = true;
        currWorld.getParticle(14).locked = true;
        stopAllSounds ();
        if (soundOn)
        {
            inGameMusicSound.start(0, 9999);
        } // end if
        if (currLevelNum > highestLevelReached)
        {
            _loc2 = root_mc.level_mc.canvas_mc;
            highestLevelReached = currLevelNum;
            initPanX = 1700;
            _loc2._x = -1191.400000;
            _loc2.foreground_mc._x = 1191;
            _loc2.parallax0_mc._x = 982;
            _loc2.parallax1_mc._x = 981;
            _loc2.parallax2_mc._x = 1386;
            switch (currLevelNum)
            {
                case 4:
                {
                    _loc2.parallax0_mc._x = 1282;
                    break;
                } 
                case 5:
                {
                    _loc2.parallax0_mc._x = _loc2.parallax0_mc._x + 600;
                    break;
                } 
                case 6:
                {
                    _loc2.parallax0_mc._x = _loc2.parallax0_mc._x + 600;
                    _loc2.parallax1_mc._x = _loc2.parallax1_mc._x + 600;
                } 
            } // End of switch
            initPanInterval = setInterval(this, "updateInitPan", 20);
        }
        else
        {
            pullBack.init();
            currWorld.start();
        } // end else if
    } // End of the function
    function updateInitPan()
    {
        var _loc2;
        var _loc3;
        initPanX = initPanX - 20;
        _loc2 = root_mc.level_mc.canvas_mc;
        _loc3 = Game.CAMERA_DAMPING * (200 - initPanX - _loc2._x);
        _loc2._x = _loc2._x + _loc3;
        _loc2.foreground_mc._x = -_loc2._x;
        _loc2.parallax0_mc._x = _loc2.parallax0_mc._x + Game.PARALLAX_LEVEL_0_SCALAR * _loc3;
        _loc2.parallax1_mc._x = _loc2.parallax1_mc._x + Game.PARALLAX_LEVEL_1_SCALAR * _loc3;
        _loc2.parallax2_mc._x = _loc2.parallax2_mc._x + Game.PARALLAX_LEVEL_2_SCALAR * _loc3;
        if (initPanX < 150)
        {
            clearInterval(initPanInterval);
            pullBack.init();
            currWorld.start();
        } // end if
    } // End of the function
    function update()
    {
        this.updateBike();
        this.updateRider();
        this.updateCamera();
        if (pullBack != undefined)
        {
            pullBack.update();
        } // end if
    } // End of the function
    function updateBike()
    {
        var _loc5;
        var _loc4;
        var _loc8;
        var _loc6;
        var _loc2 = currWorld.getParticle(0);
        var _loc3 = currWorld.getParticle(1);
        var _loc7 = currWorld.getParticle(2);
        var _loc9 = currWorld.getParticle(3);
        _loc4 = root_mc.level_mc.canvas_mc.bikeBody_mc;
        _loc4._x = 0.250000 * (_loc2.vCurr.x + _loc3.vCurr.x + _loc7.vCurr.x + _loc9.vCurr.x);
        _loc4._y = 0.250000 * (_loc2.vCurr.y + _loc3.vCurr.y + _loc7.vCurr.y + _loc9.vCurr.y);
        _loc5 = _loc3.vCurr.minusNew(_loc2.vCurr);
        _loc4._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc5.y, _loc5.x);
        _loc4 = root_mc.level_mc.canvas_mc.frontFork_mc;
        _loc4._x = _loc3.vCurr.x;
        _loc4._y = _loc3.vCurr.y;
        _loc5 = _loc7.vCurr.minusNew(_loc3.vCurr);
        _loc4._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc5.y, _loc5.x) - 7;
        _loc4 = root_mc.level_mc.canvas_mc.backFork_mc;
        _loc8 = root_mc.level_mc.canvas_mc.backShock_mc;
        _loc4._x = _loc8._x = _loc2.vCurr.x;
        _loc4._y = _loc8._y = _loc2.vCurr.y;
        _loc5 = _loc7.vCurr.minusNew(_loc2.vCurr);
        _loc4._rotation = _loc8._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc5.y, _loc5.x);
        _loc2.mc._rotation = _loc2.mc._rotation + 4 * (_loc2.vCurr.x - _loc2.vPrev.x);
        _loc3.mc._rotation = _loc3.mc._rotation + 4 * (_loc3.vCurr.x - _loc3.vPrev.x);
        if (launching)
        {
            _loc6 = ++launchStepNum / Game.LAUNCH_DURATION;
            _loc6 = _loc6 * _loc6;
            _loc2.vPrev.x = _loc2.vPrev.x - Game.BIKE_LAUNCH_X_SCALAR * xLaunchMax * _loc6;
            _loc3.vPrev.x = _loc3.vPrev.x - Game.BIKE_LAUNCH_X_SCALAR * xLaunchMax * _loc6;
            _loc3.vPrev.y = _loc3.vPrev.y - Game.BIKE_LAUNCH_Y_SCALAR * yLaunchMax * _loc6;
            if (launchStepNum >= Game.LAUNCH_DURATION)
            {
                launching = false;
            } // end if
            _loc2.mc._rotation = _loc2.mc._rotation + 4;
        }
        else if (_loc2.vCurr.y > 1000 && !goComplete)
        {
            trace ("RESET FROM BIKE FALLING");
            engineSound.stop();
            goComplete = true;
            if (separated)
            {
                root_mc.level_mc.levelRestart_mc._visible = true;
                root_mc.level_mc.levelRestart_mc.gotoAndPlay(2);
            }
            else
            {
                root_mc.level_mc.levelDown_mc._visible = true;
                root_mc.level_mc.levelDown_mc.gotoAndPlay(2);
            } // end else if
        } // end else if
    } // End of the function
    function updateRider()
    {
        var _loc2;
        var _loc3;
        var _loc17;
        var _loc4;
        var _loc18 = currWorld.getParticle(0);
        var _loc11 = currWorld.getParticle(1);
        var _loc19 = currWorld.getParticle(2);
        var _loc20 = currWorld.getParticle(3);
        var _loc13 = currWorld.getParticle(4);
        var _loc14 = currWorld.getParticle(5);
        var _loc15 = currWorld.getParticle(6);
        var _loc16 = currWorld.getParticle(7);
        var _loc12 = currWorld.getParticle(8);
        var _loc7 = currWorld.getParticle(9);
        var _loc8 = currWorld.getParticle(10);
        var _loc5 = currWorld.getParticle(11);
        var _loc6 = currWorld.getParticle(12);
        var _loc9 = currWorld.getParticle(13);
        var _loc10 = currWorld.getParticle(14);
        var _loc21 = _loc13.vCurr.x - jumpSpeed;
        jumpSpeed = _loc13.vCurr.x;
        if (!separated)
        {
            _loc3 = root_mc.level_mc.canvas_mc.bikeBody_mc;
            _loc4 = {x: 56, y: -138};
            _loc3.localToGlobal(_loc4);
            _loc3._parent.globalToLocal(_loc4);
            _loc7.vCurr.x = _loc7.vPrev.x = _loc4.x;
            _loc7.vCurr.y = _loc7.vPrev.y = _loc4.y;
            _loc8.vCurr.x = _loc8.vPrev.x = _loc4.x;
            _loc8.vCurr.y = _loc8.vPrev.y = _loc4.y;
            _loc4 = {x: -50, y: 5};
            _loc3.localToGlobal(_loc4);
            _loc3._parent.globalToLocal(_loc4);
            _loc9.vCurr.x = _loc9.vPrev.x = _loc4.x;
            _loc9.vCurr.y = _loc9.vPrev.y = _loc4.y;
            _loc10.vCurr.x = _loc10.vPrev.x = _loc4.x;
            _loc10.vCurr.y = _loc10.vPrev.y = _loc4.y;
            _loc4 = {x: -15, y: -111};
            _loc3.localToGlobal(_loc4);
            _loc3._parent.globalToLocal(_loc4);
            _loc5.vCurr.x = _loc5.vPrev.x = _loc4.x;
            _loc5.vCurr.y = _loc5.vPrev.y = _loc4.y;
            _loc6.vCurr.x = _loc6.vPrev.x = _loc4.x;
            _loc6.vCurr.y = _loc6.vPrev.y = _loc4.y;
        } // end if
        if (_loc12.vCurr.y > 500 && !goComplete)
        {
            trace ("RESET FROM BODY FALLING");
            engineSound.stop();
            goComplete = true;
            root_mc.level_mc.levelDown_mc._visible = true;
            root_mc.level_mc.levelDown_mc.gotoAndPlay(2);
        }
        else if (jumpTimer++ > Game.MAX_JUMP_TIME && !goComplete)
        {
            trace ("RESET FROM TIME OUT");
            engineSound.stop();
            jumpTimer = null;
            if (_loc11.vCurr.x >= jumpEnd && !separated)
            {
                goComplete = true;
                this.levelComplete();
            }
            else if (!separated)
            {
                goComplete = true;
                root_mc.level_mc.levelTimeOut_mc._visible = true;
                root_mc.level_mc.levelTimeOut_mc.gotoAndPlay(2);
            }
            else
            {
                goComplete = true;
                root_mc.level_mc.levelRestart_mc._visible = true;
                root_mc.level_mc.levelRestart_mc.gotoAndPlay(2);
            } // end else if
        } // end else if
        currWorld.getSpring(6).update();
        _loc3 = root_mc.level_mc.canvas_mc.rightHand_mc;
        _loc2 = _loc7.vCurr.minusNew(_loc15.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(8).update();
        _loc3 = root_mc.level_mc.canvas_mc.rightArm_mc;
        _loc2 = _loc15.vCurr.minusNew(_loc14.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(11).update();
        _loc3 = root_mc.level_mc.canvas_mc.rightLeg_mc;
        _loc2 = _loc5.vCurr.minusNew(_loc12.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(10).update();
        _loc3 = root_mc.level_mc.canvas_mc.rightFoot_mc;
        _loc2 = _loc9.vCurr.minusNew(_loc5.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(15).update();
        _loc3 = root_mc.level_mc.canvas_mc.leftHand_mc;
        _loc2 = _loc8.vCurr.minusNew(_loc16.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(16).update();
        _loc3 = root_mc.level_mc.canvas_mc.leftArm_mc;
        _loc2 = _loc16.vCurr.minusNew(_loc14.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(18).update();
        _loc3 = root_mc.level_mc.canvas_mc.leftLeg_mc;
        _loc2 = _loc6.vCurr.minusNew(_loc12.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(17).update();
        _loc3 = root_mc.level_mc.canvas_mc.leftFoot_mc;
        _loc2 = _loc10.vCurr.minusNew(_loc6.vCurr);
        _loc3._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        currWorld.getSpring(7).update();
        _loc3 = root_mc.level_mc.canvas_mc.torso_mc;
        _loc17 = root_mc.level_mc.canvas_mc.head_mc;
        _loc2 = _loc12.vCurr.minusNew(_loc14.vCurr);
        _loc3._rotation = _loc17._rotation = Game.RADIANS_TO_DEGREES * Math.atan2(_loc2.y, _loc2.x);
        if (!separated && _loc11.vCurr.y < _loc13.vCurr.y)
        {
            trace ("SEPARATING - BIKE UPSIDE DOWN");
            this.detachRider();
        } // end if
        if (_loc11.vCurr.x >= finishLine - _loc11.radius && !goComplete)
        {
            if (separated)
            {
                trace ("RESET FROM REACHING END WITHOUT RIDER");
                goComplete = true;
                root_mc.level_mc.levelRestart_mc._visible = true;
                root_mc.level_mc.levelRestart_mc.gotoAndPlay(2);
                engineSound.stop();
                if (soundOn)
                {
                    crashSound.start();
                } // end if
            }
            else
            {
                goComplete = true;
                engineSound.stop();
                if (soundOn)
                {
                    screechSound.start();
                } // end if
                endLevelInterval = setInterval(this, "levelComplete", Game.MESSAGE_DISPLAY_TIME);
            } // end if
        } // end else if
    } // End of the function
    function detachRider()
    {
        if (separated)
        {
            return;
        } // end if
        var _loc4 = currWorld.getParticle(4);
        var _loc5 = currWorld.getParticle(5);
        var _loc6 = currWorld.getParticle(6);
        var _loc8 = currWorld.getParticle(7);
        var _loc3 = currWorld.getParticle(8);
        var _loc11 = currWorld.getParticle(9);
        var _loc7 = currWorld.getParticle(10);
        var _loc9 = currWorld.getParticle(11);
        var _loc10 = currWorld.getParticle(12);
        var _loc12 = currWorld.getParticle(13);
        var _loc13 = currWorld.getParticle(14);
        var _loc2 = _loc4.vCurr.x - jumpSpeed;
        jumpSpeed = _loc4.vCurr.x;
        _loc2 = _loc2 * 2;
        _loc4.vPrev.x = _loc4.vPrev.x - _loc2;
        _loc5.vPrev.x = _loc5.vPrev.x - _loc2;
        _loc6.vPrev.x = _loc6.vPrev.x - _loc2;
        _loc8.vPrev.x = _loc8.vPrev.x - _loc2;
        _loc3.vPrev.x = _loc3.vPrev.x - _loc2;
        _loc11.vPrev.x = _loc11.vPrev.x - _loc2;
        _loc7.vPrev.x = _loc7.vPrev.x - _loc2;
        _loc9.vPrev.x = _loc9.vPrev.x - _loc2;
        _loc10.vPrev.x = _loc10.vPrev.x - _loc2;
        _loc12.vPrev.x = _loc12.vPrev.x - _loc2;
        _loc13.vPrev.x = _loc13.vPrev.x - _loc2;
        _loc3.vPrev.y = _loc3.vPrev.y + _loc2;
        _loc4.vForce.y = 0;
        _loc5.vForce.y = 0;
        _loc3.vForce.y = 0;
        currWorld.getParticle(9).locked = false;
        currWorld.getParticle(10).locked = false;
        currWorld.getParticle(13).locked = false;
        currWorld.getParticle(14).locked = false;
        currWorld.springs.splice(14, 1);
        currWorld.addConstraint("c100", "p5", "p8", "p11", 0.500000, 3.100000);
        currWorld.addConstraint("c101", "p5", "p8", "p12", 0.500000, 3.100000);
        currWorld.springs.splice(19, 1);
        currWorld.springs.splice(12, 1);
        root_mc.level_mc.canvas_mc.rightHand_mc.gotoAndStop(2);
        root_mc.level_mc.canvas_mc.leftHand_mc.gotoAndStop(2);
        if (soundOn)
        {
            thudSound.start(1);
        } // end if
        separated = true;
    } // End of the function
    function levelComplete()
    {
        clearInterval(endLevelInterval);
        if (currLevelNum == levelData.length)
        {
            root_mc.gotoAndStop("gameFinished");
        }
        else
        {
            root_mc.level_mc.levelComplete_mc._visible = true;
            root_mc.level_mc.levelComplete_mc.gotoAndPlay(2);
        } // end else if
    } // End of the function
    function redrawOutlines()
    {
        var _loc2;
        _loc2 = root_mc.level_mc.canvas_mc;
        this.setOutline(_loc2.torso_mc, _loc2.torsoOutline_mc);
        this.setOutline(_loc2.rightArm_mc, _loc2.rightArmOutline_mc);
        this.setOutline(_loc2.leftArm_mc, _loc2.leftArmOutline_mc);
        this.setOutline(_loc2.rightHand_mc, _loc2.rightHandOutline_mc);
        this.setOutline(_loc2.leftHand_mc, _loc2.leftHandOutline_mc);
        this.setOutline(_loc2.rightLeg_mc, _loc2.rightLegOutline_mc);
        this.setOutline(_loc2.leftLeg_mc, _loc2.leftLegOutline_mc);
        this.setOutline(_loc2.rightFoot_mc, _loc2.rightFootOutline_mc);
        this.setOutline(_loc2.leftFoot_mc, _loc2.leftFootOutline_mc);
    } // End of the function
    function setOutline(mc, outline)
    {
        outline._x = mc._x;
        outline._y = mc._y;
        outline._rotation = mc._rotation;
    } // End of the function
    function updateCamera()
    {
        var _loc2;
        var _loc4;
        var _loc3;
        _loc2 = root_mc.level_mc.canvas_mc;
        _loc4 = currWorld.getParticle(4);
        _loc3 = Game.CAMERA_DAMPING * (200 - _loc4.vCurr.x - _loc2._x);
        _loc2._x = _loc2._x + _loc3;
        _loc2.foreground_mc._x = -_loc2._x;
        _loc2.parallax0_mc._x = _loc2.parallax0_mc._x + Game.PARALLAX_LEVEL_0_SCALAR * _loc3;
        _loc2.parallax1_mc._x = _loc2.parallax1_mc._x + Game.PARALLAX_LEVEL_1_SCALAR * _loc3;
        _loc2.parallax2_mc._x = _loc2.parallax2_mc._x + Game.PARALLAX_LEVEL_2_SCALAR * _loc3;
    } // End of the function
    function launchBike(x, y)
    {
        var _loc3 = currWorld.getParticle(0);
        var _loc2 = currWorld.getParticle(1);
        xLaunchMax = x;
        yLaunchMax = y;
        launchStepNum = 10;
        launching = true;
        _loc3.vPrev.x = _loc3.vPrev.x - Game.BIKE_LAUNCH_X_SCALAR * x;
        _loc2.vPrev.x = _loc2.vPrev.x - Game.BIKE_LAUNCH_X_SCALAR * 0.500000 * x;
        _loc2.vPrev.y = _loc2.vPrev.y + Game.BIKE_LAUNCH_Y_SCALAR * y;
        jumpTimer = 0;
    } // End of the function
    function destroyPullBack()
    {
        delete this.pullBack;
    } // End of the function
    function parseLevelData(rawLevelData)
    {
        var _loc6;
        var _loc5;
        var _loc2;
        var _loc3;
        rawLevelData = rawLevelData.childNodes[0];
        _loc6 = Number(rawLevelData.attributes.gravity);
        _loc5 = Number(rawLevelData.attributes.restitution);
        jumpEnd = Number(rawLevelData.attributes.jumpEnd);
        currWorld.setGravity(_loc6);
        currWorld.setRestitution(_loc5);
        for (var _loc3 = 0; _loc3 < rawLevelData.childNodes.length; ++_loc3)
        {
            _loc2 = rawLevelData.childNodes[_loc3];
            if (_loc2.nodeName == "particle")
            {
                this.parseParticleData(_loc2);
            } // end if
        } // end of for
        for (var _loc3 = 0; _loc3 < rawLevelData.childNodes.length; ++_loc3)
        {
            _loc2 = rawLevelData.childNodes[_loc3];
            if (_loc2.nodeName == "surface")
            {
                this.parseSurfaceData(_loc2);
                continue;
            } // end if
            if (_loc2.nodeName == "spring")
            {
                this.parseSpringData(_loc2);
                continue;
            } // end if
            if (_loc2.nodeName == "constraint")
            {
                this.parseConstraintData(_loc2);
            } // end if
        } // end of for
    } // End of the function
    function parseParticleData(rawData)
    {
        var _loc9;
        var _loc3;
        var _loc4;
        var _loc8;
        var _loc7;
        var _loc6;
        var _loc5;
        _loc9 = rawData.attributes.id;
        _loc3 = Number(rawData.attributes.x);
        _loc4 = Number(rawData.attributes.y);
        _loc8 = Number(rawData.attributes.xf);
        _loc7 = Number(rawData.attributes.yf);
        _loc6 = Number(rawData.attributes.r);
        _loc5 = rawData.attributes.mc;
        currWorld.addParticle(_loc9, _loc3, _loc4, _loc8, _loc7, _loc6, _loc5);
    } // End of the function
    function parseSurfaceData(rawData)
    {
        var _loc9;
        var _loc5;
        var _loc7;
        var _loc6;
        var _loc10;
        var _loc3;
        var _loc8;
        var _loc4;
        _loc9 = rawData.attributes.id;
        _loc5 = Number(rawData.attributes.xa);
        _loc7 = Number(rawData.attributes.ya);
        _loc6 = Number(rawData.attributes.xb);
        _loc10 = Number(rawData.attributes.yb);
        _loc3 = Number(rawData.attributes.x);
        _loc8 = Number(rawData.attributes.y);
        _loc4 = Number(rawData.attributes.r);
        if (!isNaN(_loc3) && !isNaN(_loc8) && !isNaN(_loc4))
        {
            currWorld.addCircularSurface(_loc9, _loc3, _loc8, _loc4);
            if (_loc3 + _loc4 > finishLine)
            {
                finishLine = _loc3 + _loc4;
            } // end if
        }
        else if (!isNaN(_loc5) && !isNaN(_loc7) && !isNaN(_loc6) && !isNaN(_loc10))
        {
            currWorld.addLinearSurface(_loc9, _loc5, _loc7, _loc6, _loc10);
            if (_loc5 > finishLine)
            {
                finishLine = _loc5;
            } // end if
            if (_loc6 > finishLine)
            {
                finishLine = _loc6;
            } // end if
        } // end else if
    } // End of the function
    function parseSpringData(rawData)
    {
        var _loc6;
        var _loc8;
        var _loc9;
        var _loc7;
        var _loc3;
        var _loc5;
        var _loc4;
        _loc6 = rawData.attributes.id;
        _loc8 = Number(rawData.attributes.x);
        _loc9 = Number(rawData.attributes.y);
        _loc7 = rawData.attributes.pa;
        _loc3 = rawData.attributes.pb;
        _loc5 = Number(rawData.attributes.l);
        _loc4 = Number(rawData.attributes.e);
        currWorld.addSpring(_loc6, _loc7, _loc3, _loc5, _loc4);
    } // End of the function
    function parseConstraintData(rawData)
    {
        var _loc7;
        var _loc8;
        var _loc3;
        var _loc4;
        var _loc5;
        var _loc6;
        _loc7 = rawData.attributes.id;
        _loc8 = rawData.attributes.pa;
        _loc3 = rawData.attributes.pb;
        _loc4 = rawData.attributes.pc;
        _loc5 = Number(rawData.attributes.min);
        _loc6 = Number(rawData.attributes.max);
        currWorld.addConstraint(_loc7, _loc8, _loc3, _loc4, _loc5, _loc6);
    } // End of the function
    static var BIKE_LAUNCH_X_SCALAR = 0.070000;
    static var BIKE_LAUNCH_Y_SCALAR = 0.020000;
    static var RADIANS_TO_DEGREES = 57.295780;
    static var CAMERA_DAMPING = 0.200000;
    static var PARALLAX_LEVEL_0_SCALAR = -0.950000;
    static var PARALLAX_LEVEL_1_SCALAR = -0.900000;
    static var PARALLAX_LEVEL_2_SCALAR = -0.800000;
    static var PARALLAX_LEVEL_3_SCALAR = 0.900000;
    static var LAUNCH_DURATION = 35;
    static var MAX_JUMP_TIME = 200;
    static var MESSAGE_DISPLAY_TIME = 2000;
} // End of Class
