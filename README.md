# UNHEX

🚧 UNDER CONSTRUCTION 🚧


Swiss-Army Knife to Hexadecimal Data

```bash
$ unhex --help

Swiss-Army Knife to Hexadecimal Data

Usage: unhex [INPUT]

Arguments:
  [INPUT]

Options:
  -h, --help     Print help
  -V, --version  Print version
```


## Examples

```bash
dd if=/dev/urandom of=/dev/stdout count=8 bs=9 | xxd -p | tr -d '[:space:]' | unhex
```
