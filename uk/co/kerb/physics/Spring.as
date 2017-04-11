class uk.co.kerb.physics.Spring
{
    var id, pA, pB, restLength, elasticity;
    function Spring(id, pA, pB, restLength, elasticity)
    {
        this.id = id;
        this.pA = pA;
        this.pB = pB;
        this.restLength = restLength;
        this.elasticity = elasticity;
    } // End of the function
    function update()
    {
        var _loc2;
        var _loc3;
        _loc2 = pB.vCurr.minusNew(pA.vCurr);
        _loc3 = 1 - restLength / _loc2.length();
        _loc3 = _loc3 - elasticity * _loc3;
        if (pA.locked)
        {
            _loc2.mult(_loc3);
            pB.vCurr.minus(_loc2);
        }
        else if (pB.locked)
        {
            _loc2.mult(_loc3);
            pA.vCurr.plus(_loc2);
        }
        else
        {
            _loc2.mult(_loc3 * 0.500000);
            pA.vCurr.plus(_loc2);
            pB.vCurr.minus(_loc2);
        } // end else if
    } // End of the function
} // End of Class
