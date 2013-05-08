#!/usr/bin/env texlua

local luafiles = {
  "lualibs-boolean.lua",   "lualibs-compat.lua",
  "lualibs-dir.lua",       "lualibs-file.lua",
  "lualibs-function.lua",  "lualibs-io.lua",
  "lualibs-lpeg.lua",      "lualibs-lua.lua",
  "lualibs-math.lua",      "lualibs-md5.lua",
  "lualibs-number.lua",    "lualibs-os.lua",
  "lualibs-package.lua",   "lualibs-set.lua",
  "lualibs-string.lua",    "lualibs-table.lua",
  "lualibs-trac-inf.lua",  "lualibs-unicode.lua",
  "lualibs-url.lua",       "lualibs-util-deb.lua",
  "lualibs-util-dim.lua",  "lualibs-util-env.lua",
  "lualibs-util-jsn.lua",  "lualibs-util-lua.lua",
  "lualibs-util-prs.lua",  "lualibs-util-sta.lua",
  "lualibs-util-sto.lua",  "lualibs-util-str.lua",
  "lualibs-util-tab.lua",  "lualibs-util-fmt.lua",
  "lualibs-util-tpl.lua",  "lualibs.lua",
  "lualibs-basic.lua",     "lualibs-basic-merged.lua",
  "lualibs-extended.lua",  "lualibs-extended-merged.lua",
}

local test_cmd = "texluac -p %s &> /dev/null"

local check_wellformed = function (file)
  io.write"testing "
  io.write(file)
  io.write" ... "
  local exit_status = os.execute(string.format(test_cmd, file))
  if exit_status == 0 then
    io.write"SUCCESS!\n"
    return true
  end
  io.write"FAIL :-/\n"
  return false
end

local check_files check_files = function (lst, n)
  if n == nil then
    return check_files(lst, 1)
  end
  local this = lst[n]
  if this then
    if check_wellformed(this) then
      return check_files(lst, n+1)
    else
      return false
    end
  end
  return true
end

config = { lualibs = { force_reload = true } }

local load_all = function ( )

  io.write"testing merged packages ... "
  config.lualibs.prefer_merged = true
  if not pcall(function () dofile"lualibs.lua"end) then
    io.write"FAIL :-/\n"
  end
  io.write"SUCCESS\n"

  io.write"testing files ... "
  config.lualibs.prefer_merged = false
  if not pcall(function () dofile"lualibs.lua"end) then
    io.write"FAIL :-/\n"
  end
  io.write"SUCCESS\n"
  return true
end

local main = function ( )
  local retval = 0
  retval = check_files(luafiles) and retval or 1
  retval = load_all()            and retval or 1
  os.exit(retval)
end

return main()
