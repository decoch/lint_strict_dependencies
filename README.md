# lint_strict_dependencies

Simple linter of strict dependencies for Flutter apps.

## Usage

### Install

```yaml
dev_dependencies:
  lint_strict_dependencies: any
```

### Config

To use lint_strict_dependencies, you need adding setting to your strict_dependencies.yaml.

```yaml
rules:
  - module: "ui/components"
    allowReferenceFrom:
      - "ui/pages"
    allowSameModule: true
  - module: "view_models"
    allowReferenceFrom:
      - "ui/pages"
    allowSameModule: false
  - module: "models"
    allowReferenceFrom:
      - "view_models"
      - "ui/pages"
    allowSameModule: false
```

### Execute lint

```bash
flutter pub run lint_strict_dependencies:main
```
