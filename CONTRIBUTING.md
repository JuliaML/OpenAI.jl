## Contributing

All contributions are welcome, just open a PR and let's talk!
As this project matures, I'll come up with interface and style guidelines.

**Table of Contents**

- [Contributing](#contributing)
  - [Pull Request Checklist](#pull-request-checklist)
  - [Style Guide](#style-guide)


### Pull Request Checklist
- [ ] Add tests for new features
- [ ] Add documentation for new features
- [ ] Add a line to the `CHANGELOG.md` file describing the new feature
- [ ] All tests pass
- [ ] The code is formatted with `JuliaFormatter` (see [Style Guide](#style-guide) below)

### Style Guide
This repository follows SciML's [Style](https://github.com/SciML/SciMLStyle). The exact flavor is described in the file `./JuliaFormatter.toml`.

Before opening a PR, please run `using JuliaFormatter; format(".")` in the root directory of the repository to make sure that your contributions are formatted accordingly.

If your contribution is not formatted, the CI will fail and you will be asked to format your code before the PR can be merged.