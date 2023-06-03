# geckodriver-unchained
Unrestricted geckodriver that works on not only Mozilla Firefox but also other Firefox-based browsers such as LibreWolf, Waterfox, Mullvad Browser, etc.

## Why?
The official geckodriver checks if the browser is Mozilla Firefox by checking the binary version using `--version` or using `application.ini` file. But the problem with `--version` is it try to match a [regex pattern](https://github.com/mozilla/gecko-dev/blob/f5dde549cca5193743d11daa1c5f08258bee9d42/testing/mozbase/rust/mozversion/src/lib.rs#L259): `Mozilla Firefox[[:space:]]+(?P<version>.+)`. So if the browser is not "Mozilla Firefox" (e.g. LibreWolf), it will fail even if the browser is based on Mozilla Firefox. This problem causes the geckodriver to not work on other Firefox-based browsers specifically on Linux.

## How?
This geckodriver removes the check. Thus, it will work on other Firefox-based browsers.

## Build
1. Install Rust
2. Clone this repository and cd into it
3. Run `make`

You can also specify the version of Firefox source to use by setting `FIREFOX_VERSION` argument. For example, `make FIREFOX_VERSION=113.0.2`.

You may need to install some target for cross-compiling using `rustup target add <target>`.

Run `make help` for more information.

## Binary Releases
You can download the binary releases from the [releases page](https://github.com/rafiibrahim8/geckodriver-unchained/releases/latest).

## Usage
1. Download the binary release or build it yourself
2. Make sure the binary is executable on linux and macos (e.g. `chmod +x geckodriver`)
3. Use the path to the binary as the `executable_path` argument in your selenium script

Here is an example of using it with selenium in python:

```python
from selenium import webdriver
from selenium.webdriver.firefox.service import Service as FirefoxService

options = webdriver.FirefoxOptions()
options.binary_location = '/not/a/mozilla/firefox/binary'
executable_path = "/path/to/geckodriver"

driver = webdriver.Firefox(service=FirefoxService(executable_path), options=options)
```

## TODO
- [ ] Add macOS binary release in github actions

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
For the license of the original geckodriver, see [here](https://github.com/mozilla/gecko-dev/blob/master/LICENSE).
