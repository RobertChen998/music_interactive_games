# Image Converter Project

This project provides a tool for converting images into Verilog modules. The main functionality is encapsulated in the `VerilogImageConverter` class, which allows users to resize images and generate color palettes, as well as layout modules for use in hardware design.

## Features

- Convert images to Verilog color palette and pixel data modules.
- Resize images to specified pixel dimensions.
- Support for color quantization to a defined maximum number of colors.
- Generate multiple layout variants of the image.

## Installation

To set up the project, you need to install the required dependencies. You can do this by running:

```
pip install -r requirements.txt
```

## Usage

To use the image converter, you can call the `convert_image_to_verilog` function from the `image_converter.py` file. Here’s a basic example:

```python
from src.image_converter import convert_image_to_verilog

convert_image_to_verilog('path/to/your/image.png', 'output_file.sv', image_width=60, image_height=60, pixel_width=60, pixel_height=60)
```

### Parameters

- `image_path`: The path to the input image file.
- `output_file`: The name of the output Verilog file.
- `image_width`: The width to which the image will be resized.
- `image_height`: The height to which the image will be resized.
- `pixel_width`: The width of the pixel data array in the Verilog module.
- `pixel_height`: The height of the pixel data array in the Verilog module.

## License

This project is licensed under the MIT License - see the LICENSE file for details.