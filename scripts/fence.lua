function is_fence(x, y, z) 
    return string.sub(block.name(block.get(x, y, z)), 1, 12) == "fences:fence"
end

function update_fence_corners(x, y, z, propagate)
    local corners = {0, 0, 0, 0}
    local count = 0

    if is_fence(x - 1, y, z) then
        corners[3] = 1
        count = count + 1
        if propagate then
            update_fence_corners(x - 1, y, z, false)
        end
    end
    if is_fence(x, y, z - 1) then
        corners[1] = 1
        count = count + 1
        if propagate then
            update_fence_corners(x, y, z - 1, false)
        end
    end
    if is_fence(x + 1, y, z) then
        corners[4] = 1
        count = count + 1
        if propagate then
            update_fence_corners(x + 1, y, z, false)
        end
    end
    if is_fence(x, y, z + 1) then
        corners[2] = 1
        count = count + 1
        if propagate then
            update_fence_corners(x, y, z + 1, false)
        end
    end
   
    if count == 0 then
        block.set(x, y, z, block.index('fences:fence'))
    elseif count == 1 then
        block.set(x, y, z, block.index('fences:fence_single'))
        if (corners[1] == 1) then
            block.set_rotation(x, y, z, 1)
        elseif (corners[2] == 1) then
            block.set_rotation(x, y, z, 3)
        elseif (corners[3] == 1) then
            block.set_rotation(x, y, z, 2)
        elseif (corners[4] == 1) then
            block.set_rotation(x, y, z, 0)
        end
    elseif count == 2 then
        if (corners[1] == 1 and corners[2] == 1) then
            block.set(x, y, z, block.index('fences:fence_double'))
            block.set_rotation(x, y, z, 3)
        elseif (corners[3] == 1 and corners[4] == 1) then
            block.set(x, y, z, block.index('fences:fence_double'))
        elseif (corners[2] == 1 and corners[3] == 1) then
            block.set(x, y, z, block.index('fences:fence_corner'))
            block.set_rotation(x, y, z, 3)
        elseif (corners[1] == 1 and corners[3] == 1) then
            block.set(x, y, z, block.index('fences:fence_corner'))
            block.set_rotation(x, y, z, 2)
        elseif (corners[1] == 1 and corners[4] == 1) then
            block.set(x, y, z, block.index('fences:fence_corner'))
            block.set_rotation(x, y, z, 1)
        elseif (corners[1] == 1 and corners[3] == 1) then
            block.set(x, y, z, block.index('fences:fence_corner'))
            block.set_rotation(x, y, z, 2)
        elseif (corners[2] == 1 and corners[4] == 1) then
            block.set(x, y, z, block.index('fences:fence_corner'))
            block.set_rotation(x, y, z, 0)
        end 
    elseif count == 3 then
        block.set(x, y, z, block.index('fences:fence_tripple'))
        if (corners[4] == 0) then
            block.set_rotation(x, y, z, 3)
        elseif (corners[3] == 0) then
            block.set_rotation(x, y, z, 1)
        elseif (corners[2] == 0) then
            block.set_rotation(x, y, z, 2)
        end
    elseif count == 4 then
        block.set(x, y, z, block.index('fences:fence_four'), 0)
    end
end

function on_placed(x, y, z, player)
    update_fence_corners(x, y, z, true)
end

function on_broken(x, y, z, player)
    if is_fence(x - 1, y, z) then
        update_fence_corners(x - 1, y, z, true)
    end
    if is_fence(x, y, z - 1) then
        update_fence_corners(x, y, z - 1, true)
    end
    if is_fence(x + 1, y, z) then
        update_fence_corners(x + 1, y, z, true)
    end
    if is_fence(x, y, z + 1) then
        update_fence_corners(x, y, z + 1, true)
    end
end
