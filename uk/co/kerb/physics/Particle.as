class uk.co.kerb.physics.Particle
{
    var id, vCurr, vPrev, vForce, radius, mc, locked;
    function Particle(id, x, y, xForce, yForce, radius, mc)
    {
        this.id = id;
        vCurr = new uk.co.kerb.physics.Vector(x, y);
        vPrev = new uk.co.kerb.physics.Vector(x, y);
        vForce = new uk.co.kerb.physics.Vector(xForce, yForce);
        this.radius = radius;
        this.mc = mc;
        locked = false;
    } // End of the function
    function update(gravity, restitution)
    {
        var _loc2;
        _loc2 = vCurr.minusNew(vPrev);
        _loc2.mult(restitution);
        vPrev.x = vCurr.x;
        vPrev.y = vCurr.y;
        vCurr.plus(_loc2);
        vCurr.x = vCurr.x + vForce.x;
        vCurr.y = vCurr.y + (gravity + vForce.y);
    } // End of the function
} // End of Class
