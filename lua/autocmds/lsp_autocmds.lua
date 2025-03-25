local M = {}

function M.setup()
	-- C and C++ (using clangd)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp" },
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_clangd(lsp.on_attach, lsp.capabilities)
			local debug = require("debugging")
			debug.setup_cpp()
		end,
	})

	-- JavaScript / TypeScript (using eslint)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_eslint(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Python (using jedi_language_server)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_jedi_language_server(lsp.on_attach, lsp.capabilities)
			local debug = require("debugging")
			debug.setup_python()
		end,
	})

	-- JSON (using jsonls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "json",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_jsonls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Dockerfile (using dockerls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "dockerfile",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_dockerls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Docker Compose (using docker_compose_language_service)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "dockercompose",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_docker_compose_language_service(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Bash (using bashls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "sh", "bash" },
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_bashls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Java (using jdtls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "java",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_jdtls(lsp.on_attach, lsp.capabilities)
			local debug = require("debugging")
			debug.setup_java()
		end,
	})

	-- Lua (using lua_ls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "lua",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_lua_ls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Markdown (using marksman)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_marksman(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- PowerShell (using powershell_es)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "powershell",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_powershell_es(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Terraform (using terraformls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "terraform", "tf", "tfvars" },
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_terraformls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- SQL (using sqls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "sql",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_sqls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- Vimscript (using vimls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "vim",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_vimls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- YAML (using yamlls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "yaml", "yml" },
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_yamlls(lsp.on_attach, lsp.capabilities)
		end,
	})

	-- C# (using omnisharp and csharp_ls)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "cs",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_omnisharp(lsp.on_attach, lsp.capabilities)
			lsp.lsp_setup.setup_csharp_ls(lsp.on_attach, lsp.capabilities)
			local debug = require("debugging")
			debug.setup_cs()
		end,
	})

	-- Bicep (using bicep)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "bicep",
		callback = function()
			local lsp = require("lsp")
			lsp.lsp_setup.setup_bicep(lsp.on_attach, lsp.capabilities)
		end,
	})
end

return M
