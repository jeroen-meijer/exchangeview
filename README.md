# ExchangeView

A simple CLI tool to help with currency conversion and other calculations related to invoicing.

## What is this tool?

ExchangeView is a command line interface tool made with [Dart](https://dart.dev/) that uses the [Exchange rates API](http://exchangeratesapi.io) to fetch and calculate currency exchange rates.

## Why?

I was tired of looking up exchange rates on [xe.com](https://xe.com/) and calculating salary/rates manually, so I made this handy dandy program.

## Installation

```shell
> pub global activate --source git https://github.com/jeroen-meijer/exchangeview.git
```

## Usage

```shell
> exchangeview

Date: 2020-06-20 03:37:04.173880
Fetching current exchange rate for USD and EUR... 0.2s

1.00 USD = 0.8920606601 EUR

> exchangeview

Date: 2020-06-20 03:37:23.615454
Fetching current exchange rate for EUR and JPY... 0.2s

1.00 EUR = 119.77 JPY
An hourly rate of 45.00 EUR is equal to about 5389.65 JPY
```

For help, use `--help`.

```shell
ExchangeView is a tool to help with currency conversion and other calculations related to invoicing.

usage: exchangeview
-r, --rate=<HOURLY RATE>      The billable hourly rate in the source currency.
                              If provided, the hourly rate will be converted
                              from the source to the target currency.
-f, --from=<CURRENCY CODE>    The source currency.
                              (defaults to "USD")
-t, --to=<CURRENCY CODE>      The target currency.
                              (defaults to "EUR")
-h, --help                    Display this help menu.
-v, --verbose                 Enable verbose logging.
-a, --[no-]ansi               Enable or disable ANSI logging.
                              (defaults to on)
```

## License

[MIT License](https://opensource.org/licenses/MIT)

Copyright (c) 2020 Jeroen Meijer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.