--  This is file `lualibs.lua',
module('lualibs', package.seeall)

local lualibs_module = {
  name          = "lualibs",
  version       = 1.01,
  date          = "2013/04/10",
  description   = "Lua additional functions.",
  author        = "Hans Hagen, PRAGMA-ADE, Hasselt NL & Elie Roux",
  copyright     = "PRAGMA ADE / ConTeXt Development Team",
  license       = "See ConTeXt's mreadme.pdf for the license",
}

_G.config              = _G.config or { }
_G.config.lualibs      = _G.config.lualibs or { }
local lualibs          = _G.config.lualibs

if lualibs.prefer_merged == nil then lualibs.prefer_merged = true end
if lualibs.load_extended == nil then lualibs.load_extended = true end
lualibs.verbose = lualibs.verbose == true or false

local lpeg, kpse = lpeg, kpse

local dofile       = dofile
local lpegmatch    = lpeg.match
local stringformat = string.format

local find_file, error, warn, info
do
  local _error, _warn, _info
  if luatexbase and luatexbase.provides_module then
    _error, _warn, _info = luatexbase.provides_module(lualibs_module)
  else
    _error, _warn, _info = texio.write_nl, texio.write_nl, texio.write_nl -- stub
  end

  -- if lualibs.verbose then 
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
  find_file = kpse.find_file
end

loadmodule = _G.loadmodule or function (name, t)
  if not t then t = "library" end
  local filepath  = kpse.find_file(name, "lua")
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
loadmodule"lualibs-basic.lua"
loadmodule"lualibs-compat.lua" --- restore stuff gone since v1.*

if load_extended == true then
  loadmodule"lualibs-extended.lua"
end

-- vim:tw=71:sw=2:ts=2:expandtab
--  End of File `lualibs-basic.lua'.
