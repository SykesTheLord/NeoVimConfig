local function get_distro()
    local file = io.open("/etc/os-release", "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    local distro = content:match("ID=%a+")
    if distro then
        distro = distro:gsub("ID=", "")
        return distro:lower()
    end
    return nil
end

local distro = get_distro()
local is_neon = distro and distro:find("neon")
local is_manjaro = distro and distro:find("manjaro")

local condition = (vim.env.XDG_SESSION_TYPE == "wayland" or vim.env.WAYLAND_DISPLAY) and not is_neon and
    not (vim.fn.has("wsl") == 1) or is_manjaro

if vim.fn.has("wsl") == 1 and not string.find(vim.fn.system("lsb_release -is 2>/dev/null"):lower(), "ubuntu") then
    vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
elseif condition then
    vim.g.clipboard = {
        name = "wayland",
        copy = {
            ["+"] = "wl-copy",
            ["*"] = "wl-copy",
        },
        paste = {
            ["+"] = "wl-paste",
            ["*"] = "wl-paste",
        },
        cache_enabled = 0,
    }
else
    vim.g.clipboard = {
        name = "x11",
        copy = {
            ["+"] = "xclip -selection clipboard",
            ["*"] = "xclip -selection primary",
        },
        paste = {
            ["+"] = "xclip -selection clipboard -o",
            ["*"] = "xclip -selection primary -o",
        },
        cache_enabled = 0,
    }
end
