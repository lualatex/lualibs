-- 
--  This is file `lualibs.lua',
--  generated with the docstrip utility.
-- 
--  The original source files were:
-- 
--  lualibs.dtx  (with options: `lua')
--  This is a generated file.
--  
--  Copyright (C) 2009 by PRAGMA ADE / ConTeXt Development Team
--  
--  See ConTeXt's mreadme.pdf for the license.
--  
--  This work consists of the main source file lualibs.dtx
--  and the derived file lualibs.lua.
--  
module('lualibs', package.seeall)

local lualibs_module = {
    name          = "lualibs",
    version       = 0.97,
    date          = "2012/10/19",
    description   = "Lua additional functions.",
    author        = "Hans Hagen, PRAGMA-ADE, Hasselt NL & Elie Roux",
    copyright     = "PRAGMA ADE / ConTeXt Development Team",
    license       = "See ConTeXt's mreadme.pdf for the license",
}

if luatexbase and luatexbase.provides_module then
    luatexbase.provides_module(lualibs_module)
end
require("lualibs-string")
require("lualibs-lpeg")
require("lualibs-boolean")
require("lualibs-number")
require("lualibs-math")
require("lualibs-table")
require("lualibs-io")
require("lualibs-os")
require("lualibs-file")
require("lualibs-md5")
require("lualibs-dir")
require("lualibs-unicode")
require("lualibs-url")
require("lualibs-set")
require("lualibs-util-lua")
require("lualibs-util-sto")
require("lualibs-util-mrg")
require("lualibs-util-dim")
require("lualibs-util-str")
require("lualibs-util-tab")
require("lualibs-util-jsn")
-- 
--  End of File `lualibs.lua'.
