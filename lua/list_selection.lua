local file = file
local print, ipairs = print, ipairs
local i2c = i2c
local u8g = u8g
local node_task_post = node.task.post


local M = {}
if setfenv then
    setfenv(1, M) -- for 5.1
else
    _ENV = M -- for 5.2
end

    local disp
    local font

    local function setLargeFont()
        disp:setFont(font)
        disp:setFontRefHeightExtendedText()
        disp:setDefaultForegroundColor()
        disp:setFontPosTop()
    end

    local function print_list(files, selected)
        setLargeFont()
        disp:drawStr(30, 0, "files")
        line = 15
        for _, file in ipairs(files) do
            if(file == selected) then
                disp:drawStr(30, line, "> "..file)
            else 
                disp:drawStr(30, line, "  "..file)
            end
            line = line + 10
        end
    end

    local function updateDisplay(func)
        local function drawPages()
            func()
            if (disp:nextPage() == true) then
                node_task_post(drawPages)
            end
        end
  
        disp:firstPage()
        node_task_post(drawPages)
    end

    function init(sda_pin, scl_pin)
        local sla = 0x3c
        i2c.setup(0, sda_pin, scl_pin, i2c.SLOW)  
  
        disp = u8g.ssd1306_128x64_i2c(sla)
        font = u8g.font_6x10
    end

    function display(files, selected)
        updateDisplay(
            function ()
                print_list(files, selected)
            end
        )
    end

return M
