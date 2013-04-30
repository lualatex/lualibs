lualibs = lualibs or { }

lualibs.module_info = {
  name          = "lualibs",
  version       = 2.00,
  date          = "2013/04/30",
  description   = "ConTeXt Lua standard libraries.",
  author        = "Hans Hagen, PRAGMA-ADE, Hasselt NL & Elie Roux & Philipp Gesang",
  copyright     = "PRAGMA ADE / ConTeXt Development Team",
  license       = "See ConTeXt's mreadme.pdf for the license",
}

config           = config or { }
config.lualibs   = config.lualibs or { }

if config.lualibs.prefer_merged == nil then
  lualibs.prefer_merged = true
end
if config.lualibs.load_extended == nil then
  lualibs.load_extended = true
end
config.lualibs.verbose = config.lualibs.verbose == true

local dofile        = dofile
local kpsefind_file = kpse.find_file
local stringformat  = string.format
local texiowrit_nl  = texio.write_nl

local find_file, error, warn, info
do
  local _error, _warn, _info
  if luatexbase and luatexbase.provides_module then
    _error, _warn, _info = luatexbase.provides_module(lualibs_module)
  else
    _error, _warn, _info = texiowrite_nl, texiowrite_nl, texiowrite_nl
  end

  if lualibs.verbose then
    error, warn, info = _error, _warn, _info
  else
    local dummylogger = function ( ) end
    error, warn, info = _error, dummylogger, dummylogger
  end
  lualibs.error, lualibs.warn, lualibs.info = error, warn, info
end

if luatexbase and luatexbase.find_file then
  find_file = luatexbase.find_file
else
  kpse.set_program_name"luatex"
  find_file = kpsefind_file
end

loadmodule = loadmodule or function (name, t)
  if not t then t = "library" end
  local filepath  = kpsefind_file(name, "lua")
  if not filepath or filepath == "" then
    warn(stringformat("Could not locate %s “%s”.", t, name))
    return false
  end
  dofile(filepath)
  return true
end
lualibs.loadmodule = loadmodule

--[[doc--
The separation of the “basic” from the “extended” sets coincides with
the split into luat-bas.mkiv and luat-lib.mkiv.
--doc]]--
if lualibs.basic_loaded ~= true then
  loadmodule"lualibs-basic.lua"
  loadmodule"lualibs-compat.lua" --- restore stuff gone since v1.*
end

if  lualibs.load_extended   == true
and lualibs.extended_loaded ~= true then
  loadmodule"lualibs-extended.lua"
end

-- vim:tw=71:sw=2:ts=2:expandtab
--  End of File `lualibs-basic.lua'.
