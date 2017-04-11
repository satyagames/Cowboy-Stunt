class uk.co.kerb.physics.Vector
{
    var x, y;
    function Vector(x, y)
    {
        this.x = x == undefined ? (0) : (x);
        this.y = y == undefined ? (0) : (y);
    } // End of the function
    function dot(v)
    {
        return (x * v.x + y * v.y);
    } // End of the function
    function cross(v)
    {
        return (x * v.y - y * v.x);
    } // End of the function
    function plus(v)
    {
        x = x + v.x;
        y = y + v.y;
        return (this);
    } // End of the function
    function plusNew(v)
    {
        return (new uk.co.kerb.physics.Vector(x + v.x, y + v.y));
    } // End of the function
    function minus(v)
    {
        x = x - v.x;
        y = y - v.y;
        return (this);
    } // End of the function
    function minusNew(v)
    {
        return (new uk.co.kerb.physics.Vector(x - v.x, y - v.y));
    } // End of the function
    function mult(s)
    {
        x = x * s;
        y = y * s;
        return (this);
    } // End of the function
    function multNew(s)
    {
        return (new uk.co.kerb.physics.Vector(x * s, y * s));
    } // End of the function
    function clone()
    {
        return (new uk.co.kerb.physics.Vector(x, y));
    } // End of the function
    function length()
    {
        return (Math.sqrt(x * x + y * y));
    } // End of the function
    function distance(v)
    {
        var _loc2;
        var _loc3;
        _loc2 = x - v.x;
        _loc3 = y - v.y;
        return (Math.sqrt(_loc2 * _loc2 + _loc3 * _loc3));
    } // End of the function
    function normalise()
    {
        var _loc2;
        _loc2 = Math.sqrt(x * x + y * y);
        if (_loc2 == 0)
        {
            return (new uk.co.kerb.physics.Vector(0, 0));
        }
        else
        {
            return (new uk.co.kerb.physics.Vector(x / _loc2, y / _loc2));
        } // end else if
    } // End of the function
    function getNormal(dir)
    {
        if (dir.charAt(0) == "l" || dir.charAt(0) == "L")
        {
            return (new uk.co.kerb.physics.Vector(y, -x));
        }
        else
        {
            return (new uk.co.kerb.physics.Vector(-y, x));
        } // end else if
    } // End of the function
    function toString()
    {
        return ("x[" + x + "] y[" + y + "]");
    } // End of the function
} // End of Class
