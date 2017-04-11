class uk.co.kerb.physics.World
{
    var canvas_mc, surfaces, springs, particles, constraints, gravity, restitution, masterObject, threadInterval;
    function World(mc, masterObj)
    {
        canvas_mc = mc;
        surfaces = [];
        springs = [];
        particles = [];
        constraints = [];
        gravity = 1;
        restitution = 1;
        masterObject = masterObj;
    } // End of the function
    function start()
    {
        threadInterval = setInterval(this, "update", 20);
    } // End of the function
    function stop()
    {
        clearInterval(threadInterval);
        delete this.threadInterval;
    } // End of the function
    function addParticle(id, x, y, xForce, yForce, radius, mcRef)
    {
        var _loc2;
        var _loc3;
        _loc3 = canvas_mc[mcRef];
        _loc2 = new uk.co.kerb.physics.Particle(id, x, y, xForce, yForce, radius, _loc3);
        particles.push(_loc2);
        return (_loc2);
    } // End of the function
    function addLinearSurface(id, xA, yA, xB, yB)
    {
        var _loc2;
        _loc2 = new uk.co.kerb.physics.LinearSurface(id, xA, yA, xB, yB);
        surfaces.push(_loc2);
        return (_loc2);
    } // End of the function
    function addCircularSurface(id, x, y, r)
    {
        var _loc2;
        _loc2 = new uk.co.kerb.physics.CircularSurface(id, x, y, r);
        surfaces.push(_loc2);
        return (_loc2);
    } // End of the function
    function addSpring(id, pAID, pBID, restLength, elasticity)
    {
        var _loc7;
        var _loc3;
        var _loc4;
        var _loc2;
        for (var _loc2 = 0; _loc2 < particles.length; ++_loc2)
        {
            if (particles[_loc2].id == pAID)
            {
                _loc3 = particles[_loc2];
                continue;
            } // end if
            if (particles[_loc2].id == pBID)
            {
                _loc4 = particles[_loc2];
            } // end if
        } // end of for
        if (_loc3 == undefined)
        {
            trace ("WARNING: Can\'t find reference to particle id [" + pAID + "] for spring creation. Make sure that the particle has been created before the spring that references it is created");
        } // end if
        if (_loc4 == undefined)
        {
            trace ("WARNING: Can\'t find reference to particle id [" + pBID + "] for spring creation. Make sure that the particle has been created before the spring that references it is created");
        } // end if
        _loc7 = new uk.co.kerb.physics.Spring(id, _loc3, _loc4, restLength, elasticity);
        springs.push(_loc7);
        return (_loc7);
    } // End of the function
    function addConstraint(id, pAID, pBID, pCID, min, max)
    {
        var _loc9;
        var _loc3;
        var _loc4;
        var _loc5;
        var _loc2;
        for (var _loc2 = 0; _loc2 < particles.length; ++_loc2)
        {
            if (particles[_loc2].id == pAID)
            {
                _loc3 = particles[_loc2];
                continue;
            } // end if
            if (particles[_loc2].id == pBID)
            {
                _loc4 = particles[_loc2];
                continue;
            } // end if
            if (particles[_loc2].id == pCID)
            {
                _loc5 = particles[_loc2];
            } // end if
        } // end of for
        if (_loc3 == undefined)
        {
            trace ("WARNING: Can\'t find reference to particle id [" + pAID + "] for spring creation. Make sure that the particle has been created before the spring that references it is created");
        } // end if
        if (_loc4 == undefined)
        {
            trace ("WARNING: Can\'t find reference to particle id [" + pBID + "] for spring creation. Make sure that the particle has been created before the spring that references it is created");
        } // end if
        if (_loc5 == undefined)
        {
            trace ("WARNING: Can\'t find reference to particle id [" + pCID + "] for spring creation. Make sure that the particle has been created before the spring that references it is created");
        } // end if
        _loc9 = new uk.co.kerb.physics.Constraint(id, _loc3, _loc4, _loc5, min, max);
        constraints.push(_loc9);
        return (_loc9);
    } // End of the function
    function setGravity(g)
    {
        gravity = isNaN(g) ? (1) : (g);
    } // End of the function
    function setRestitution(r)
    {
        restitution = isNaN(r) ? (1) : (r);
    } // End of the function
    function getParticle(n)
    {
        return (particles[n]);
    } // End of the function
    function getSpring(n)
    {
        return (springs[n]);
    } // End of the function
    function update()
    {
        var _loc7;
        var _loc5;
        var _loc2;
        var _loc3;
        var _loc6;
        var _loc8 = 3;
        for (var _loc7 = 0; _loc7 < particles.length; ++_loc7)
        {
            particles[_loc7].update(gravity, restitution);
        } // end of for
        for (var _loc7 = 0; _loc7 < springs.length; ++_loc7)
        {
            springs[_loc7].update();
        } // end of for
        for (var _loc7 = 0; _loc7 < particles.length; ++_loc7)
        {
            for (var _loc5 = 0; _loc5 < _loc8; ++_loc5)
            {
                _loc6 = 0;
                for (var _loc2 = 0; _loc2 < surfaces.length; ++_loc2)
                {
                    if (surfaces[_loc2] instanceof uk.co.kerb.physics.LinearSurface)
                    {
                        _loc3 = this.checkLinearSurfaceCollision(particles[_loc7], surfaces[_loc2]);
                    }
                    else
                    {
                        _loc3 = this.checkCircularSurfaceCollision(particles[_loc7], surfaces[_loc2]);
                    } // end else if
                    if (_loc3 != null)
                    {
                        ++_loc6;
                        if (_loc7 == 1)
                        {
                            var _loc4 = particles[_loc7].vCurr.minusNew(_loc3);
                            _loc4.mult(0.500000);
                            particles[2].vCurr.minus(_loc4);
                            if (Math.abs(_loc4.y) > 8)
                            {
                                masterObject.detachRider();
                            } // end if
                        } // end if
                        particles[_loc7].vCurr = _loc3;
                    } // end if
                } // end of for
                if (_loc6 < 2)
                {
                    break;
                } // end if
            } // end of for
        } // end of for
        for (var _loc7 = 0; _loc7 < constraints.length; ++_loc7)
        {
            constraints[_loc7].update();
        } // end of for
        masterObject.update();
        this.redraw();
        masterObject.redrawOutlines();
    } // End of the function
    function checkLinearSurfaceCollision(p, s)
    {
        var _loc5;
        var _loc3;
        var _loc8;
        var _loc12;
        var _loc18;
        var _loc19;
        var _loc15;
        var _loc14;
        var _loc6;
        var _loc9;
        var _loc10;
        var _loc17;
        var _loc16;
        var _loc13;
        var _loc7;
        var _loc11;
        var _loc20;
        var _loc21;
        _loc5 = p.vCurr.minusNew(p.vPrev);
        if (_loc5.x == 0 && _loc5.y == 0)
        {
            return (null);
        } // end if
        _loc3 = s.vA.minusNew(p.vPrev);
        _loc7 = _loc3.cross(s.v) / _loc5.cross(s.v);
        _loc8 = _loc5.multNew(_loc7);
        _loc8.plus(p.vPrev);
        if (this.isBetween(s.vA.x, _loc8.x, s.vB.x) && this.isBetween(s.vA.y, _loc8.y, s.vB.y))
        {
            _loc12 = s.vNNorm.multNew(p.radius);
            _loc18 = s.vA.plusNew(_loc12);
            _loc3 = _loc18.minusNew(_loc8);
            _loc7 = _loc3.cross(s.v) / _loc12.cross(s.v);
            _loc6 = _loc12.multNew(_loc7);
            _loc15 = _loc6.plusNew(_loc8);
            _loc6.mult(-1);
            _loc14 = _loc6.plusNew(_loc8);
            _loc9 = _loc15.minusNew(p.vPrev);
            _loc10 = _loc14.minusNew(p.vPrev);
            _loc16 = _loc9.x * _loc9.x + _loc9.y * _loc9.y;
            _loc13 = _loc10.x * _loc10.x + _loc10.y * _loc10.y;
            _loc17 = _loc5.x * _loc5.x + _loc5.y * _loc5.y;
            if (_loc16 < _loc13)
            {
                if (_loc17 > _loc16)
                {
                    return (_loc15);
                } // end if
            }
            else if (_loc17 > _loc13)
            {
                return (_loc14);
            } // end if
        } // end else if
        _loc3 = p.vCurr.minusNew(s.vA);
        _loc11 = _loc3.dot(s.vN);
        if (_loc11 > 0)
        {
            _loc3 = p.vCurr.minusNew(s.vB);
            _loc11 = _loc3.dot(s.vN);
            if (_loc11 < 0)
            {
                _loc7 = _loc3.cross(s.vN);
                _loc3.x = _loc7 * s.vN.y;
                _loc3.y = _loc7 * -s.vN.x;
                if (p.radius - _loc3.length() >= 0)
                {
                    _loc6 = _loc3.normalise();
                    _loc6.mult(p.radius - _loc3.length());
                    _loc6.plus(p.vCurr);
                    return (_loc6);
                } // end if
            } // end if
        } // end if
        return (null);
    } // End of the function
    function isBetween(a, b, c)
    {
        return (a <= b && b <= c || a >= b && b >= c);
    } // End of the function
    function checkCircularSurfaceCollision(p, s)
    {
        var _loc5;
        var _loc2;
        var _loc3;
        var _loc1;
        _loc2 = p.vCurr.minusNew(s.v);
        _loc3 = _loc2.normalise();
        _loc1 = p.radius + s.radius - _loc2.length();
        if (_loc1 >= 0)
        {
            _loc3.mult(_loc1);
            _loc5 = p.vCurr.plusNew(_loc3);
            return (_loc5);
        }
        else
        {
            return (null);
        } // end else if
    } // End of the function
    function redraw()
    {
        var _loc3;
        var _loc5;
        var _loc4;
        var _loc2;
        for (var _loc3 = 0; _loc3 < particles.length; ++_loc3)
        {
            _loc2 = particles[_loc3];
            _loc2.mc._x = _loc2.vCurr.x;
            _loc2.mc._y = _loc2.vCurr.y;
        } // end of for
    } // End of the function
} // End of Class
