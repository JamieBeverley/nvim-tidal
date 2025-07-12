-- Private
local M = {}
local ghci_term_buf = nil
local ghci_job_id = nil

local tidal_boot = "~/TidalBoot.hs"

local function _start_ghci()
    -- Reuse if running
    if vim.g.ghci_job_id and vim.fn.jobwait({ vim.g.ghci_job_id }, 0)[1] == -1 then
        print("ghci already running")
        return
    end

    local current_win = vim.api.nvim_get_current_win()

    vim.cmd("belowright split")
    local term_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(term_win, buf)

    local job_id = vim.fn.termopen({ "ghci", "-ghci-script", "MyScript.hs" })
    vim.g.ghci_job_id = job_id
    vim.b.ghci_buf = buf

    -- Return focus to original window
    vim.api.nvim_set_current_win(current_win)
end


local function _send_to_ghci(cmd)
    local ghci_job_id = vim.g.ghci_job_id
    if vim.g.ghci_job_id and vim.fn.jobwait({ ghci_job_id }, 0)[1] == -1 then
        vim.api.nvim_chan_send(ghci_job_id, cmd .. "\n")
    else
        print("ghci is not running")
    end
end

local function _end_ghci()
    local job = vim.g.ghci_job_id
    local buf = vim.b.ghci_buf

    if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
        vim.fn.jobstop(job)
        print("ghci stopped")
    else
        print("ghci is not running")
    end

    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
    end

    vim.g.ghci_job_id = nil
    vim.b.ghci_buf = nil
end

-- return {
--     _start_ghci = _start_ghci,
--     _send_to_ghci = _send_to_ghci,
--     _end_ghci = _end_ghci,
-- }

-- Public APIs
local plugin = {
    start_ghci = _start_ghci,
    end_ghci = _end_ghci
}

plugin.setup = function(opts_
    print("setup called")
end

return plugin
