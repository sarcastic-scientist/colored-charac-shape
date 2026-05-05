# colored-charac-shape

A pandoc `.lua` filter that replaces inline code spans of the form `` `shape:#RRGGBB` `` with a filled colored shape character. The filter is compatible with **pandoc**, **quarto**, and **rmarkdown**. The filter has been texted for `.html`, `.pdf`, and `.docx` outputs. 

## Shapes

| Syntax | Shape | Character |
|:------:|:-----:|:---------:|
| `` `square:#RRGGBB` `` | Filled square | ■ |
| `` `circle:#RRGGBB` `` | Filled circle | ● |
| `` `triangle:#RRGGBB` `` | Filled triangle | ▲ |
| `` `diamond:#RRGGBB` `` | Filled diamond | ◆ |
| `` `star:#RRGGBB` `` | Filled star | ★ |

`#RRGGBB` is the standard 6-digit hex color code and the filter is case-insensitive.

## Examples

```markdown

Traffic light: `circle:#FF0000` `circle:#FFCC00` `circle:#00CC00`

Status icons: `square:#E74C3C` error  `square:#2ECC71` ok  `square:#3498DB` info

Gold star rating: `star:#FFD700`

```

## Usage

### pandoc

```bash
pandoc input.md --lua-filter colored-charac-shape.lua -o output.html
pandoc input.md --lua-filter colored-charac-shape.lua -o output.pdf
pandoc input.md --lua-filter colored-charac-shape.lua -o output.docx
```

### Quarto

In `_quarto.yml` or document front-matter:

```yaml
filters:
  - colored-charac-shape.lua
```

### R Markdown

In the document YAML front-matter:

```yaml
output:
  html_document:
    pandoc_args: ["--lua-filter", "colored-charac-shape.lua"]
```
## Non-matching code passes through

Code spans that don't match the pattern are left unchanged:

```markdown
`notashape:#FF0000`   ← unknown shape name, left as code
`square:#GG0000`      ← invalid hex digits, left as code
`square:FF0000`       ← missing #, left as code
```

## Testing

```bash
chmod +x test.sh
bash ./test.sh
```

`./output/test.{html,docx,pdf}` file is generated and verified.

## Requirements

- **Pandoc** 2.11 or later (Lua filter API)
- **.pdf output**: a LaTeX distribution with `pdflatex` or `xelatex`, plus the `xcolor` and `amssymb` packages (included in TeX Live / MiKTeX by default)
- **.docx/.html output**: no extra dependencies


