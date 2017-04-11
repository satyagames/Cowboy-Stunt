class uk.co.kerb.physics.LinearSurface
{
    var id, vA, vB, v, vN, vNNorm;
    function LinearSurface(id, xA, yA, xB, yB)
    {
        this.id = id;
        vA = new uk.co.kerb.physics.Vector(xA, yA);
        vB = new uk.co.kerb.physics.Vector(xB, yB);
        v = vB.minusNew(vA);
        vN = v.normalise();
        vNNorm = new uk.co.kerb.physics.Vector(-vN.y, vN.x);
    } // End of the function
} // End of Class
