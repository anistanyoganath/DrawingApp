lib/
│
├── main.dart
│
├── app/
│ ├── app.dart // MaterialApp, theme setup
│ ├── router.dart // App routes
│
├── core/
│ ├── constants/
│ │ ├── colors.dart // primary, secondary, gradients
│ │ ├── assets.dart // paths for lottie, icons, svg
│ │ ├── api_keys.dart // your AI endpoints (not in repo)
│ │
│ ├── utils/
│ ├── ai_service.dart // API call to generate outline image
│ ├── image_converter.dart // convert AI image → colorable format
│ ├── storage_helper.dart // save drawings locally (Hive)
│ ├── logger.dart
│
├── models/
│ ├── drawing.dart // Drawing model: id, category, imagePath, colorsUsed, etc.
│ ├── category.dart // Category model
│
├── data/
│ ├── categories_data.dart // static list: “space”, “dinos”, “unicorns”
│
├── services/
│ ├── drawing_service.dart // business logic for generating & storing drawings
│
├── presentation/
│ ├── screens/
│ │ ├── home/
│ │ │ ├── home_screen.dart
│ │ │ ├── widgets/
│ │ │ │ ├── category_card.dart
│ │ │ │ └── header.dart
│ │ │
│ │ ├── generate/
│ │ │ ├── generate_screen.dart // AI generates outline
│ │ │ └── widgets/
│ │ │ ├── loader.dart
│ │ │ └── theme_selector.dart
│ │ │
│ │ ├── coloring/
│ │ │ ├── coloring_screen.dart // canvas + colors
│ │ │ ├── widgets/
│ │ │ ├── color_palette.dart
│ │ │ ├── canvas_area.dart
│ │ │ └── tool_bar.dart
│ │ │
│ │ ├── gallery/
│ │ │ ├── gallery_screen.dart // saved drawings
│ │ │ └── widgets/
│ │ │ └── gallery_item.dart
│ │ │
│ │ ├── settings/
│ │ ├── settings_screen.dart
│ │ └── widgets/
│ │ ├── setting_tile.dart
│ │ └── toggle_option.dart
│ │
│ ├── widgets/
│ ├── primary_button.dart
│ ├── app_bar.dart
│ ├── empty_state.dart
│
├── themes/
│ ├── light_theme.dart
│ ├── dark_theme.dart
│ └── theme_manager.dart // for runtime theme change
│
└── generated/ // auto-generated localization (if needed)

assets/
├── animations/
│ ├── loading.json
│ └── spark.json
│
├── icons/
│ ├── dinosaur.png
│ ├── space.png
│ ├── unicorn.png
│ └── brush.png
│
├── drawings/
│ ├── sample1.png
│ └── sample2.png
│
└── lottie/
└── ai_magic.json

test/
├── widget_tests/
└── unit_tests/
