# headcheck

A simple command-line tool that performs an HTTP HEAD request to check if a URL is accessible.

## Installation

With Go installed:

```bash
go install github.com/ngarside/server/headcheck@latest
```

Or clone and build:

```bash
git clone https://github.com/ngarside/server/headcheck
cd headcheck
go build
```

## Usage

```bash
headcheck <url>
```

The program will perform a HEAD request to the specified URL and exit with:
- Code 0 if the URL returns a successful status code (200-299)
- Code 1 if the URL is inaccessible or returns an error status code

### Options

- `--version` - Print version information
- `--help` - Show help message

### Examples

Check if a website is accessible:
```bash
headcheck https://example.com
```

Expected output:
```
Request: https://example.com
Success: Received status 200
```

Check a non-existent URL:
```bash
headcheck https://example.com/not-found
```

Expected output:
```
Request: https://example.com/not-found
Error: Received status 404
```

## License

This is free and unencumbered software released into the public domain. See the source code for more details.
