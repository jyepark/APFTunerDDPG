function collided = checkCollision(p1, p2, ptObstacle, delta)
    % epsilon = v*linkLength where v = pi/8?
    if (norm(p1-ptObstacle) < delta) || (norm(p2-ptObstacle) < delta)
        collided = true;
    else
        collided = false;
    end
end