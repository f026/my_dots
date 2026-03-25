require('ruscmd').setup {
    local defaults = {
    cabbrev = { 'bd', 'bn', 'q', 'qa', 'w', 'wq', 'wqa' },
    map = { -- :help default-mappings
        n = { 'Y', 'gc', 'gcc', ']d', '[d', '<C-W>d', 'K' },
        v = {},
        x = { 'Q', 'gc' },
        s = {},
        o = { 'gc' },
        i = {},
        l = {},
        c = {},
        t = {},
    },
}
}
