"""
Main entry point for the Word Document MCP Server.
Acts as the central controller for the MCP server that handles Word document operations.
Supports multiple transports: stdio, sse, and streamable-http using standalone FastMCP.
"""

import os
import sys
# Set required environment variable for FastMCP 2.8.1+
os.environ.setdefault('FASTMCP_LOG_LEVEL', 'INFO')
from fastmcp import FastMCP
from word_document_server.tools import (
    document_tools,
    content_tools,
    format_tools,
    protection_tools,
    footnote_tools,
    extended_document_tools
)
def get_transport_config():
    """
    Get transport configuration from environment variables.
    
    Returns:
        dict: Transport configuration with type, host, port, and other settings
    """
    # Default configuration
    config = {
        'transport': 'stdio',  # Default to stdio for backward compatibility
        'host': '127.0.0.1',
        'port': 8000,
        'path': '/mcp',
        'sse_path': '/sse'
    }
    
    # Override with environment variables if provided
    transport = os.getenv('MCP_TRANSPORT', 'stdio').lower()
    print(f"Transport: {transport}")
    # Validate transport type
    valid_transports = ['stdio', 'streamable-http', 'sse']
    if transport not in valid_transports:
        print(f"Warning: Invalid transport '{transport}'. Falling back to 'stdio'.")
        transport = 'stdio'
    
    config['transport'] = transport
    config['host'] = os.getenv('MCP_HOST', config['host'])
    config['port'] = int(os.getenv('MCP_PORT', config['port']))
    config['path'] = os.getenv('MCP_PATH', config['path'])
    config['sse_path'] = os.getenv('MCP_SSE_PATH', config['sse_path'])
    
    return config


def setup_logging(debug_mode):
    """
    Setup logging based on debug mode.
    
    Args:
        debug_mode (bool): Whether to enable debug logging
    """
    import logging
    
    if debug_mode:
        logging.basicConfig(
            level=logging.DEBUG,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        print("Debug logging enabled")
    else:
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )


# Initialize FastMCP server
mcp = FastMCP("Word Document Server")


def register_tools():
    """Register all tools with the MCP server using FastMCP decorators."""
    
    # Document tools (create, copy, info, etc.)
    @mcp.tool()
    def create_document(file_path: str, title: str = None, author: str = None):
        """Create a new Word document with optional metadata."""
        return document_tools.create_document(file_path, title, author)
    
    @mcp.tool()
    def copy_document(source_filename: str, destination_filename: str = None):
        """Create a copy of a Word document."""
        return document_tools.copy_document(source_filename, destination_filename)
    
    @mcp.tool()
    def get_document_info(file_path: str):
        """Get information about a Word document."""
        return document_tools.get_document_info(file_path)
    
    @mcp.tool()
    def get_document_text(file_path: str):
        """Extract all text from a Word document."""
        return document_tools.get_document_text(file_path)
    
    @mcp.tool()
    def get_document_outline(file_path: str):
        """Get the structure of a Word document."""
        return document_tools.get_document_outline(file_path)
    
    @mcp.tool()
    def list_available_documents(directory: str = "."):
        """List all .docx files in the specified directory."""
        return document_tools.list_available_documents(directory)
    
    # @mcp.tool()
    # def get_document_xml(file_path: str):
    #     """Get the raw XML structure of a Word document."""
    #     return document_tools.get_document_xml_tool(file_path)
    
    # @mcp.tool()
    # def insert_header_near_text(file_path: str, target_text: str, header_title: str, position: str = 'after', header_style: str = 'Heading 1'):
    #     """Insert a header (with specified style) before or after the first paragraph containing target_text. Args: filename (str), target_text (str), header_title (str), position ('before' or 'after'), header_style (str, default 'Heading 1')."""
    #     return document_tools.insert_header_near_text_tool(file_path, target_text, header_title, position, header_style)
    
    # @mcp.tool()
    # def insert_line_or_paragraph_near_text(file_path: str, target_text: str, line_text: str, position: str = 'after', line_style: str = None):
    #     """
    #     Insert a new line or paragraph (with specified or matched style) before or after the first paragraph containing target_text.
    #     Args: file_path (str), target_text (str), line_text (str), position ('before' or 'after'), line_style (str, optional).
    #     """
    #     return document_tools.insert_line_or_paragraph_near_text_tool(file_path, target_text, line_text, position, line_style)
    # Content tools (paragraphs, headings, tables, etc.)
    # @mcp.tool()
    # def add_paragraph(file_path: str, text: str, style: str = None):
    #     """Add a paragraph to a Word document."""
    #     return content_tools.add_paragraph(file_path, text, style)
    
    # @mcp.tool()
    # def add_heading(file_path: str, text: str, level: int = 1):
    #     """Add a heading to a Word document."""
    #     return content_tools.add_heading(file_path, text, level)
    
    # @mcp.tool()
    # def add_picture(file_path: str, image_path: str, width: float = None):
    #     """Add an image to a Word document."""
    #     return content_tools.add_picture(file_path, image_path, width)
    
    # @mcp.tool()
    # def add_table(file_path: str, rows: int, cols: int, data: list = None):
    #     """Add a table to a Word document."""
    #     return content_tools.add_table(file_path, rows, cols, data)
    
    # @mcp.tool()
    # def add_page_break(file_path: str):
    #     """Add a page break to the document."""
    #     return content_tools.add_page_break(file_path)
    
    # @mcp.tool()
    # def delete_paragraph(file_path: str, paragraph_index: int):
    #     """Delete a paragraph from a document."""
    #     return content_tools.delete_paragraph(file_path, paragraph_index)
    
    @mcp.tool()
    def search_and_replace(file_path: str, find_text: str, replace_text: str):
        """Search for text and replace all occurrences."""
        return content_tools.search_and_replace(file_path, find_text, replace_text)
    
    # Format tools (styling, text formatting, etc.)
    # @mcp.tool()
    # def create_custom_style(file_path: str, style_name: str, bold: bool = None, 
    #                       italic: bool = None, font_size: int = None, 
    #                       font_name: str = None, color: str = None, 
    #                       base_style: str = None):
    #     """Create a custom style in the document."""
    #     return format_tools.create_custom_style(
    #         file_path, style_name, bold, italic, font_size, font_name, color, base_style
    #     )
    
    # @mcp.tool()
    # def format_text(file_path: str, paragraph_index: int, start_pos: int, end_pos: int,
    #                bold: bool = None, italic: bool = None, underline: bool = None,
    #                color: str = None, font_size: int = None, font_name: str = None):
    #     """Format a specific range of text within a paragraph."""
    #     return format_tools.format_text(
    #         file_path, paragraph_index, start_pos, end_pos, bold, italic, 
    #         underline, color, font_size, font_name
    #     )
    
    # @mcp.tool()
    # def format_table(file_path: str, table_index: int, has_header_row: bool = None,
    #                 border_style: str = None, shading: list = None):
    #     """Format a table with borders, shading, and structure."""
    #     return format_tools.format_table(file_path, table_index, has_header_row, border_style, shading)
    
    # Protection tools
    # @mcp.tool()
    # def protect_document(file_path: str, password: str):
    #     """Add password protection to a Word document."""
    #     return protection_tools.protect_document(file_path, password)
    
    # @mcp.tool()
    # def unprotect_document(file_path: str, password: str):
    #     """Remove password protection from a Word document."""
    #     return protection_tools.unprotect_document(file_path, password)
    
    # # Footnote tools
    # @mcp.tool()
    # def add_footnote_to_document(file_path: str, paragraph_index: int, footnote_text: str):
    #     """Add a footnote to a specific paragraph in a Word document."""
    #     return footnote_tools.add_footnote_to_document(file_path, paragraph_index, footnote_text)
    
    # @mcp.tool()
    # def add_endnote_to_document(file_path: str, paragraph_index: int, endnote_text: str):
    #     """Add an endnote to a specific paragraph in a Word document."""
    #     return footnote_tools.add_endnote_to_document(file_path, paragraph_index, endnote_text)
    
    # @mcp.tool()
    # def customize_footnote_style(file_path: str, numbering_format: str = "1, 2, 3",
    #                             start_number: int = 1, font_name: str = None,
    #                             font_size: int = None):
    #     """Customize footnote numbering and formatting in a Word document."""
    #     return footnote_tools.customize_footnote_style(
    #         file_path, numbering_format, start_number, font_name, font_size
    #     )
    
    # Extended document tools
    # @mcp.tool()
    # def get_paragraph_text_from_document(file_path: str, paragraph_index: int):
    #     """Get text from a specific paragraph in a Word document."""
    #     return extended_document_tools.get_paragraph_text_from_document(file_path, paragraph_index)
    
    @mcp.tool()
    def find_text_in_document(file_path: str, text_to_find: str, match_case: bool = True,
                             whole_word: bool = False):
        """Find occurrences of specific text in a Word document."""
        return extended_document_tools.find_text_in_document(
            file_path, text_to_find, match_case, whole_word
        )
    
    # @mcp.tool()
    # def convert_to_pdf(file_path: str, output_filename: str = None):
    #     """Convert a Word document to PDF format."""
    #     return extended_document_tools.convert_to_pdf(file_path, output_filename)


def run_server():
    """Run the Word Document MCP Server with configurable transport."""
    # Get transport configuration
    config = get_transport_config()
    
    # Setup logging
    # setup_logging(config['debug'])
    
    # Register all tools
    register_tools()
    
    # Print startup information
    transport_type = config['transport']
    print(f"Starting Word Document MCP Server with {transport_type} transport...")
    
    # if config['debug']:
    #     print(f"Configuration: {config}")
    
    try:
        if transport_type == 'stdio':
            # Run with stdio transport (default, backward compatible)
            print("Server running on stdio transport")
            mcp.run(transport='stdio')
            
        elif transport_type == 'streamable-http':
            # Run with streamable HTTP transport
            print(f"Server running on streamable-http transport at http://{config['host']}:{config['port']}{config['path']}")
            mcp.run(
                transport='streamable-http',
                host=config['host'],
                port=config['port'],
                path=config['path']
            )
            
        elif transport_type == 'sse':
            # Run with SSE transport
            print(f"Server running on SSE transport at http://{config['host']}:{config['port']}{config['sse_path']}")
            mcp.run(
                transport='sse',
                host=config['host'],
                port=config['port'],
                path=config['sse_path']
            )
            
    except KeyboardInterrupt:
        print("\nShutting down server...")
    except Exception as e:
        print(f"Error starting server: {e}")
        if config['debug']:
            import traceback
            traceback.print_exc()
        sys.exit(1)
    
    return mcp


def main():
    """Main entry point for the server."""
    run_server()


if __name__ == "__main__":
    main()