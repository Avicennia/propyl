function love.load()
    dtt = 1
    rdata = {}
    love.filesystem.read("data.txt"):gsub("%d+", function(w) table.insert(rdata,tonumber(w)) end)
    tdata = {}
    layer = {}
    floor = 0
    color = {}
    gsize = 256*4
    scale = 1
    ucount = 0 -- unit count
    vscale = 16*scale -- size of one unit
    grid_resolution = math.sqrt(gsize)
    viewport = {
        ori = {x = love.graphics.getPixelWidth()/64, y = love.graphics.getPixelHeight()/64},
        des = {x = 516, y = 516},
        uni = {w = vscale*scale,h = vscale*scale}
    }
    viewport.dim = {height = math.ceil(viewport.des.y-viewport.ori.y), width = math.ceil(viewport.des.x-viewport.ori.x)}
    grid_resolution = math.ceil(grid_resolution)
    local transform = love.math.newTransform
    img = {
        reg = {[126] = "air",[126] = "grass_top_d1",[21] = "dirt",[22] = "dirt",[26] ="grass_top",[15] = "stone",[31] = "sand",[27]= "grass_top", [32] = "water_source", [90] = "tree",[88]= "tree", [92] = "leaves"},
        reg2 = {},
        prep = function(x) return love.graphics.newImage("/textures/"..x..".png") end,
    }
    -------------------------------------
    function floor_adjust(x)
        return x and floor + 1 < #rdata/256 and floor + 1 or not x and floor - 1 >= 0 and floor - 1 or floor
    end
    function populate_layer()
    for n = 1, gsize do -- Remember 0 and 1 offsets from front and end
    layer[n] = img.prep(img.reg[rdata[n+(gsize*floor)]])
    end end
    populate_layer()
    -------------------------------------
end

function love.keypressed(k)
    if(k == "escape")then
        love.event.quit()
    end
    if(k == "up")then
        floor = floor_adjust(true)
    populate_layer()
    end
    if(k == "down")then
        floor = floor_adjust()
    populate_layer()
    end
end

function love.update(dt)
    dtt = dtt*10
end


function love.draw(dt)
    love.graphics.setBackgroundColor(0.2, 0.2, 0.3, 0.9)
    local foss = 2
    local  ucount = 0 -- unit count

    -- Buttons
    -- Viewport Border
    love.graphics.setColor(0.1, 6.4, 2.4)
    local vpx,vpy = viewport.ori.x,viewport.ori.y
    --love.graphics.rectangle("line",vpx, vpy, viewport.des.x+foss, viewport.des.y+foss)
    
    --

    

    -- Viewport Grid
    gdrawct = 1
    love.graphics.print( "Builtin Count: "..gsize, 600, 48,_,_,_,_,_,_)
    love.graphics.print( "Grid Resolution: "..grid_resolution, 600, 58,_,_,_,_,_,_)
    love.graphics.print( "Unit Number: "..#rdata, 600, 68,_,_,_,_,_,_)
    love.graphics.setColor(0.8, 0.4, 0.4)
    love.graphics.print( "Press UP to cycle BELOW.", 600, 88,_,_,_,_,_,_)
    love.graphics.print( "Level: "..floor, 600, 80,_,_,_,_,_,_)

    love.graphics.print( "Press DOWN to cycle ABOVE.", 600, 298,_,_,_,_,_,_)
    love.graphics.print( "Press ESC to quit.", 600, 288,_,_,_,_,_,_)

    for n = 1, grid_resolution do
        local y = (viewport.ori.y+(vscale*(n-1)))
        for nn = 1, grid_resolution do
            local x = (viewport.ori.x+(vscale*(nn-1)))
            love.graphics.reset()
            if(gdrawct > 0)then
               love.graphics.draw(layer[gdrawct] or img.prep(img.reg[0]),(x+foss),(y+foss))--layer[n*nn]
            end
            
            love.graphics.setColor(0.1, 0.4, 0.4)
            love.graphics.rectangle("line", x+foss, y+foss, viewport.uni.w, viewport.uni.h)
            ucount = ucount + 1
            gdrawct = gdrawct+1
            
        end
    end
end
