-- colored-charac-shape.lua
-- Pandoc Lua filter: replaces `shape:#RRGGBB` (inline code) with a filled
-- colored shape character. Supports HTML, PDF (LaTeX), and DOCX (OpenXML).
--
-- Recognized shapes: square, circle, triangle, diamond, star
-- Syntax example:  `square:#FF4500`

local SHAPES = {
  square   = { html = "&#x25A0;", latex = "\\rule{0.8em}{0.8em}",  utf8 = "\xe2\x96\xa0" },
  circle   = { html = "&#x25CF;", latex = "$\\bullet$",             utf8 = "\xe2\x97\x8f" },
  triangle = { html = "&#x25B2;", latex = "$\\blacktriangle$",      utf8 = "\xe2\x96\xb2" },
  diamond  = { html = "&#x25C6;", latex = "$\\blacklozenge$",       utf8 = "\xe2\x97\x86" },
  star     = { html = "&#x2605;", latex = "$\\bigstar$",            utf8 = "\xe2\x98\x85" },
}

local function make_shape(name, hex)
  local shape = SHAPES[name]
  if not shape then return nil end
  local h = hex:upper()

  if FORMAT:match("^html") then
    return pandoc.RawInline("html",
      '<span style="color:#' .. h .. '">' .. shape.html .. '</span>')

  elseif FORMAT == "latex" or FORMAT == "pdf" then
    return pandoc.RawInline("latex",
      "\\textcolor[HTML]{" .. h .. "}{" .. shape.latex .. "}")

  elseif FORMAT == "docx" or FORMAT == "openxml" then
    return pandoc.RawInline("openxml",
      '<w:r><w:rPr><w:color w:val="' .. h .. '"/></w:rPr>'
      .. '<w:t>' .. shape.utf8 .. '</w:t></w:r>')

  else
    return pandoc.Str(shape.utf8)
  end
end

function Code(el)
  local name, hex = el.text:match("^(%a+):#(%x%x%x%x%x%x)$")
  if name and SHAPES[name] then
    return make_shape(name, hex)
  end
end

-- Inject xcolor and amssymb into the LaTeX preamble for PDF output.
function Meta(meta)
  if FORMAT == "latex" or FORMAT == "pdf" then
    local pkgs = {
      pandoc.RawBlock("latex", "\\usepackage{xcolor}"),
      pandoc.RawBlock("latex", "\\usepackage{amssymb}"),
    }
    local hi = meta["header-includes"]
    if hi == nil then
      meta["header-includes"] = pandoc.MetaList({})
      hi = meta["header-includes"]
    elseif hi.t ~= "MetaList" then
      meta["header-includes"] = pandoc.MetaList({ hi })
      hi = meta["header-includes"]
    end
    for _, pkg in ipairs(pkgs) do
      table.insert(hi, pandoc.MetaBlocks({ pkg }))
    end
  end
  return meta
end
