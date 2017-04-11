class PullBack
{
    var handle_mc, link_mc, anchor_mc, smoke_mc, gameRef, state, currPullbackDistance, wheelRadius, releaseCounter;
    function PullBack(handle_mc, link_mc, anchor_mc, smoke_mc, gameRef)
    {
        this.handle_mc = handle_mc;
        this.link_mc = link_mc;
        this.anchor_mc = anchor_mc;
        this.smoke_mc = smoke_mc;
        this.gameRef = gameRef;
    } // End of the function
    function update()
    {
        switch (state)
        {
            case 0:
            {
                handle_mc._x = anchor_mc._x;
                handle_mc._y = anchor_mc._y;
                break;
            } 
            case 1:
            {
                var _loc2 = PullBack.HANDLE_DRAG_DAMPING * (handle_mc._parent._xmouse - anchor_mc._x);
                var _loc3 = PullBack.HANDLE_DRAG_DAMPING * (handle_mc._parent._ymouse - anchor_mc._y);
                var _loc5 = _loc2 * _loc2 + _loc3 * _loc3;
                if (gameRef.soundOn && Math.abs(_loc5 - currPullbackDistance) > 5000)
                {
                    gameRef.revSound.start();
                } // end if
                currPullbackDistance = _loc5;
                if (_loc2 > PullBack.MAX_DRAG_DISTANCE)
                {
                    _loc2 = PullBack.MAX_DRAG_DISTANCE;
                } // end if
                if (_loc2 < -PullBack.MAX_DRAG_DISTANCE)
                {
                    _loc2 = -PullBack.MAX_DRAG_DISTANCE;
                } // end if
                if (_loc3 > PullBack.MAX_DRAG_DISTANCE)
                {
                    _loc3 = PullBack.MAX_DRAG_DISTANCE;
                } // end if
                if (_loc3 < -PullBack.MAX_DRAG_DISTANCE)
                {
                    _loc3 = -PullBack.MAX_DRAG_DISTANCE;
                } // end if
                handle_mc._x = anchor_mc._x + _loc2;
                handle_mc._y = anchor_mc._y + _loc3;
                anchor_mc._rotation = anchor_mc._rotation - 0.100000 * PullBack.HANDLE_DRAG_DAMPING * (handle_mc._parent._xmouse - anchor_mc._x);
                var _loc4 = anchor_mc._x - handle_mc._parent._xmouse;
                if (_loc4 < 20)
                {
                    _loc4 = 20;
                } // end if
                if (_loc4 > 100)
                {
                    _loc4 = 100;
                } // end if
                smoke_mc._xscale = smoke_mc._xscale + 0.100000 * (_loc4 - smoke_mc._xscale);
                smoke_mc._yscale = smoke_mc._yscale + 0.100000 * (_loc4 - smoke_mc._yscale);
                smoke_mc._x = anchor_mc._x;
                smoke_mc._y = anchor_mc._y + wheelRadius;
                break;
            } 
            case 2:
            {
                handle_mc._x = handle_mc._x + PullBack.HANDLE_RELEASE_DAMPING * (anchor_mc._x - handle_mc._x);
                handle_mc._y = handle_mc._y + PullBack.HANDLE_RELEASE_DAMPING * (anchor_mc._y - handle_mc._y);
                if (releaseCounter++ > 40 || anchor_mc._x - handle_mc._x < 14 && anchor_mc._y - handle_mc._y < 14)
                {
                    state = 3;
                } // end if
                smoke_mc._alpha = smoke_mc._alpha * 0.900000;
                break;
            } 
            case 3:
            {
                handle_mc._visible = false;
                link_mc._visible = false;
                gameRef.destroyPullBack();
            } 
        } // End of switch
        this.updateLink();
    } // End of the function
    function init()
    {
        var callback = this;
        delete handle_mc.onEnterFrame;
        handle_mc.onPress = function ()
        {
            callback.handlePress();
        };
        handle_mc.onRelease = function ()
        {
            callback.handleRelease();
        };
        handle_mc.onReleaseOutside = function ()
        {
            callback.handleRelease();
        };
        link_mc._visible = false;
        handle_mc._visible = true;
        smoke_mc.gotoAndStop(1);
        smoke_mc._alpha = 100;
        smoke_mc.doLoop = true;
        wheelRadius = anchor_mc._height / 2;
        state = 0;
    } // End of the function
    function updateLink()
    {
        var _loc2;
        var _loc3;
        link_mc._x = handle_mc._x;
        link_mc._y = handle_mc._y;
        _loc2 = anchor_mc._x - handle_mc._x;
        _loc3 = anchor_mc._y - handle_mc._y;
        link_mc._rotation = PullBack.RADIANS_TO_DEGREES * Math.atan2(_loc3, _loc2);
        link_mc.graphic._width = Math.sqrt(_loc2 * _loc2 + _loc3 * _loc3);
        handle_mc._rotation = link_mc._rotation;
    } // End of the function
    function handlePress()
    {
        link_mc._visible = true;
        smoke_mc.gotoAndPlay("in");
        delete handle_mc.onEnterFrame;
        releaseCounter = 0;
        if (gameRef.soundOn)
        {
            gameRef.revSound.start();
        } // end if
        state = 1;
    } // End of the function
    function handleRelease()
    {
        var _loc2;
        var _loc3;
        _loc2 = anchor_mc._x - handle_mc._x;
        _loc3 = anchor_mc._y - handle_mc._y;
        if (_loc2 > PullBack.MAX_RETURNED_READING)
        {
            _loc2 = PullBack.MAX_RETURNED_READING;
        }
        else if (_loc2 < -PullBack.MAX_RETURNED_READING)
        {
            _loc2 = -PullBack.MAX_RETURNED_READING;
        } // end else if
        if (_loc3 > PullBack.MAX_RETURNED_READING)
        {
            _loc3 = PullBack.MAX_RETURNED_READING;
        }
        else if (_loc3 < -PullBack.MAX_RETURNED_READING)
        {
            _loc3 = -PullBack.MAX_RETURNED_READING;
        } // end else if
        gameRef.launchBike(_loc2, _loc3);
        smoke_mc.doLoop = false;
        if (gameRef.soundOn)
        {
            gameRef.engineSound.start();
        } // end if
        state = 2;
    } // End of the function
    static var HANDLE_RELEASE_DAMPING = 0.600000;
    static var HANDLE_DRAG_DAMPING = 0.700000;
    static var MAX_DRAG_DISTANCE = 180;
    static var RADIANS_TO_DEGREES = 57.295780;
    static var MAX_RETURNED_READING = 100;
} // End of Class
