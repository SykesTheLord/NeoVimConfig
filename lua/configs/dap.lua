local dap = require("dap")
local dapui = require("dapui")

dapui.setup({})
require("nvim-dap-virtual-text").setup({})

dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

-- Signs
vim.fn.sign_define("DapBreakpoint",          { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn"  })
vim.fn.sign_define("DapLogPoint",            { text = "", texthl = "DiagnosticInfo"  })
vim.fn.sign_define("DapStopped",             { text = "", texthl = "DiagnosticOk"    })
vim.fn.sign_define("DapBreakpointRejected",  { text = "", texthl = "DiagnosticHint"  })

-- Python
dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch Python file",
        program = "${file}",
        pythonPath = function() return "python" end,
    },
}

-- C#
dap.adapters.coreclr = {
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
    args = { "--interpreter=vscode" },
}
dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch C# project",
        request = "launch",
        program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
    },
}

-- Java
dap.adapters.java = { type = "server", host = "127.0.0.1", port = 5005 }
dap.configurations.java = {
    {
        type = "java",
        request = "attach",
        name = "Attach to Java process",
        hostName = "127.0.0.1",
        port = 5005,
    },
}

-- C/C++
dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
    {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
    },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Persistent breakpoints
require("persistent-breakpoints").setup({ load_breakpoints_event = { "BufReadPost" } })
local pb = require("persistent-breakpoints.api")

local map = vim.keymap.set
map("n", "<F5>",       function() dap.continue() end,    { desc = "DAP Continue" })
map("n", "<F10>",      function() dap.step_over() end,   { desc = "DAP Step Over" })
map("n", "<F11>",      function() dap.step_into() end,   { desc = "DAP Step Into" })
map("n", "<F12>",      function() dap.step_out() end,    { desc = "DAP Step Out" })
map("n", "<leader>dr", function() dap.repl.open() end,   { desc = "DAP REPL" })
map("n", "<leader>du", function() dapui.toggle() end,    { desc = "DAP UI Toggle" })
map("n", "<leader>dc", function() dap.continue() end,    { desc = "DAP Continue" })
map("n", "<leader>dt", function() dap.terminate() end,   { desc = "DAP Terminate" })

map("n", "db", function() pb.toggle_breakpoint() end,           { desc = "Toggle Breakpoint" })
map("n", "dc", function() pb.set_conditional_breakpoint() end,  { desc = "Conditional Breakpoint" })
map("n", "bc", function() pb.clear_all_breakpoints() end,       { desc = "Clear All Breakpoints" })
map("n", "lp", function() pb.set_log_point() end,               { desc = "Log Point" })
