class uk.co.kerb.physics.Constraint
{
    var id, pA, pB, pC, min, max;
    function Constraint(id, pA, pB, pC, min, max)
    {
        this.id = id;
        this.pA = pA;
        this.pB = pB;
        this.pC = pC;
        this.min = min;
        this.max = max;
    } // End of the function
    function update()
    {
        var _loc4;
        var _loc9;
        var _loc8;
        var _loc7;
        var _loc6;
        var _loc5;
        var _loc2;
        var _loc3;
        _loc8 = pA.vCurr.x - pB.vCurr.x;
        _loc7 = pA.vCurr.y - pB.vCurr.y;
        _loc4 = Math.atan2(_loc7, _loc8);
        _loc6 = pC.vCurr.x - pB.vCurr.x;
        _loc5 = pC.vCurr.y - pB.vCurr.y;
        _loc9 = Math.atan2(_loc5, _loc6);
        _loc2 = _loc9 - _loc4;
        if (_loc2 < 0)
        {
            _loc2 = _loc2 + 6.283185;
        } // end if
        if (_loc2 < min)
        {
            _loc3 = Math.sqrt(_loc6 * _loc6 + _loc5 * _loc5);
            pC.vCurr.x = pC.vPrev.x = pC.mc._x = _loc3 * Math.cos(_loc4 + min) + pB.vCurr.x;
            pC.vCurr.y = pC.vPrev.y = pC.mc._y = _loc3 * Math.sin(_loc4 + min) + pB.vCurr.y;
        }
        else if (_loc2 > max)
        {
            _loc3 = Math.sqrt(_loc6 * _loc6 + _loc5 * _loc5);
            pC.vCurr.x = pC.vPrev.x = pC.mc._x = _loc3 * Math.cos(_loc4 + max) + pB.vCurr.x;
            pC.vCurr.y = pC.vPrev.y = pC.mc._y = _loc3 * Math.sin(_loc4 + max) + pB.vCurr.y;
        } // end else if
    } // End of the function
} // End of Class
