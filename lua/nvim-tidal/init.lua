local M = {}

local ghci_job_id = nil
local ghci_buf = nil
local config = {
    boot_tidal = nil, -- default: not set
}

function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})
end

function M._start_ghci()
    if ghci_job_id and vim.fn.jobwait({ ghci_job_id }, 0)[1] == -1 then
        print("ghci already running")
        return
    end

    local boot_script = vim.fn.expand(config.boot_tidal)
    if not boot_script then
        local cwd = vim.fn.getcwd()
        local candidate = cwd .. "/BootTidal.hs"
        if vim.fn.filereadable(candidate) == 1 then
            boot_script = candidate
        else
            print("No BootTidal.hs provided or found in cwd")
            return
        end
    end

    local current_win = vim.api.nvim_get_current_win()
    vim.cmd("belowright split")
    local term_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(term_win, buf)

    ghci_job_id = vim.fn.termopen({ "ghci", "-ghci-script", boot_script })
    ghci_buf = buf
    vim.api.nvim_set_current_win(current_win)
end

function M._send_to_ghci(cmd)
    if ghci_job_id and vim.fn.jobwait({ ghci_job_id }, 0)[1] == -1 then
        vim.api.nvim_chan_send(ghci_job_id, cmd .. "\n")
    else
        print("ghci is not running")
    end
end

function M._end_ghci()
    if ghci_job_id and vim.fn.jobwait({ ghci_job_id }, 0)[1] == -1 then
        vim.fn.jobstop(ghci_job_id)
        print("ghci stopped")
    else
        print("ghci is not running")
    end

    if ghci_buf and vim.api.nvim_buf_is_valid(ghci_buf) then
        vim.api.nvim_buf_delete(ghci_buf, { force = true })
    end

    ghci_job_id = nil
    ghci_buf = nil
end

return M
