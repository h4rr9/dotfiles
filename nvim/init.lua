local modules = {'options', 'plugins', 'mapping', 'autocmd'}

for _, a in ipairs(modules) do
    local ok, err = pcall(require, a)
    if not ok then error('Error calling ' .. a .. err) end
end

