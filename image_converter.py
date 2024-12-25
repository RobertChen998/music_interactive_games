import numpy as np
from PIL import Image
from sklearn.cluster import KMeans

class VerilogImageConverter:
    def __init__(self, image_path, max_colors=16, image_width=60, image_height=60):
        """
        Convert a JPG image to Verilog color palette and multiple pixel data modules
        """
        # Open and resize the image
        self.original_image = Image.open(image_path).convert('RGB')
        self.image = self.original_image.resize((image_width, image_height), Image.LANCZOS)
        
        # Convert image to numpy array
        self.image_array = np.array(self.image)
        print(f"Image array shape: {self.image_array.shape}")

        # Initialize color palette and pixel indices
        self.color_palette = None
        self.pixel_color_indices = None
        
        # Process the image
        self._process_image(max_colors)
    
    def _process_image(self, max_colors):
        """
        Process the image to create a color palette and pixel indices
        """
        # Reshape the image to a list of RGB tuples
        pixels = self.image_array.reshape(-1, 3)
        
        # Perform color quantization
        kmeans = KMeans(n_clusters=min(max_colors, len(np.unique(pixels, axis=0))), 
                        random_state=42)
        kmeans.fit(pixels)
        
        # Get the unique colors (cluster centers)
        self.color_palette = kmeans.cluster_centers_.astype(int)
        
        # Map each pixel to its closest cluster center
        self.pixel_color_indices = kmeans.predict(pixels).reshape(
            self.image_array.shape[:2])
    
    def _generate_layout_module(self, pixels, layout_name):
        """
        Generate Verilog module for a specific pixel layout
        """
        module = f"module image_data_{layout_name}(output reg [3:0] pixel_data [0:59][0:59]);\n"
        module += "    initial begin\n"
        
        for y in range(pixels.shape[0]):
            for x in range(pixels.shape[1]):
                # Get the color index for this pixel
                color_index = pixels[y, x]
                module += f"        pixel_data[{y}][{x}] = 4'b{color_index:04b}; // x={x}, y={y}\n"
        
        module += "    end\n"
        module += "endmodule\n"
        
        return module
    
    def generate_color_palette_module(self):
        """
        Generate Verilog color palette module
        """
        module = "module color_palette(output reg [23:0] color_map [0:15]);\n"
        module += "    initial begin\n"
        
        for i, color in enumerate(self.color_palette):
            # Convert RGB to 24-bit hex
            hex_color = f"{color[0]:02x}{color[1]:02x}{color[2]:02x}"
            module += f"        color_map[{i}] = 24'h{hex_color};\n"
        
        module += "    end\n"
        module += "endmodule\n"
        
        return module
    
    def generate_all_layout_modules(self):
        """
        Generate all layout variants
        """
        # Original layout
        original_layout = self._generate_layout_module(
            self.pixel_color_indices, 
            "original"
        )
        
        return original_layout
    
    def save_verilog_modules(self, output_file):
        """
        Save all Verilog modules to a file
        """
        with open(output_file, 'w') as f:
            # Write color palette module
            f.write(self.generate_color_palette_module())
            f.write("\n")
            
            # Write the original layout module
            layout = self.generate_all_layout_modules()
            f.write(layout)
            f.write("\n")
        
        print(f"Verilog modules saved to {output_file}")

def convert_png_to_jpg(png_path, jpg_path):
    """
    Convert a PNG image to JPG format.
    
    :param png_path: Path to the input PNG image
    :param jpg_path: Path to save the output JPG image
    """
    # Open the PNG image
    image = Image.open(png_path).convert('RGB')
    
    # Save the image in JPG format
    image.save(jpg_path, 'JPEG')
    print(f"Image saved as {jpg_path}")

# Example usage function
def convert_jpg_to_verilog(image_path, output_file='image_vga.sv'):
    """
    Convenience function to convert a JPG to Verilog modules with multiple layouts
    
    :param image_path: Path to the input JPG image
    :param output_file: Output Verilog file name
    """
    converter = VerilogImageConverter(image_path)
    converter.save_verilog_modules(output_file)

# Demonstration
if __name__ == "__main__":
    # Uncomment and use with an actual image path
    for i in range(1, 4):
        convert_png_to_jpg(f'circle{i}.png', f"circle{i}.jpg")
        convert_jpg_to_verilog(f"circle{i}.jpg", f"circle{i}.sv")
    # convert_png_to_jpg('score.png', 'score.jpg')
    # convert_jpg_to_verilog('score.jpg', 'score.sv')