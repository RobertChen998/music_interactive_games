import numpy as np
from PIL import Image
from sklearn.cluster import KMeans

class VerilogImageConverter:
    def __init__(self, image_path, max_colors=16, pixel_width=60, pixel_height=60):
        """
        Convert an image to Verilog color palette and multiple pixel data modules
        """
        # Open and resize the image
        self.original_image = Image.open(image_path)
        self.image = self.original_image.resize((pixel_width, pixel_height), Image.LANCZOS)
        
        # Convert image to numpy array
        self.image_array = np.array(self.image)
        
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
        module = f"module image_data_{layout_name}(output reg [3:0] pixel_data [0:{self.pixel_height-1}][0:{self.pixel_width-1}]);\n"
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
        
        # Up layout (vertically flipped)
        up_layout = self._generate_layout_module(
            np.flipud(self.pixel_color_indices), 
            "up"
        )
        
        # Down layout (original)
        down_layout = self._generate_layout_module(
            np.fliplr(self.pixel_color_indices), 
            "down"
        )
        
        # Right layout (90 degree clockwise rotation)
        right_layout = self._generate_layout_module(
            np.rot90(self.pixel_color_indices, k=1), 
            "right"
        )
        
        # Left layout (90 degree counterclockwise rotation)
        left_layout = self._generate_layout_module(
            np.rot90(self.pixel_color_indices, k=3), 
            "left"
        )
        
        return original_layout, up_layout, down_layout, right_layout, left_layout
    
    def save_verilog_modules(self, output_file='image_vga.v'):
        """
        Save all Verilog modules to a file
        """
        with open(output_file, 'w') as f:
            # Write color palette module
            f.write(self.generate_color_palette_module())
            f.write("\n")
            
            # Write all layout modules
            layouts = self.generate_all_layout_modules()
            for layout in layouts:
                f.write(layout)
                f.write("\n")
        
        print(f"Verilog modules saved to {output_file}")

# Example usage function
def convert_image_to_verilog(image_path, output_file='image_vga.sv', pixel_width=60, pixel_height=60):
    """
    Convenience function to convert an image to Verilog modules with multiple layouts
    
    :param image_path: Path to the input image
    :param output_file: Output Verilog file name
    :param pixel_width: Width of the pixel data array
    :param pixel_height: Height of the pixel data array
    """
    converter = VerilogImageConverter(image_path, pixel_width=pixel_width, pixel_height=pixel_height)
    converter.save_verilog_modules(output_file)

# Demonstration
if __name__ == "__main__":
    # Uncomment and use with an actual image path
    convert_image_to_verilog('./0.png', "test.sv", pixel_width=60, pixel_height=60)