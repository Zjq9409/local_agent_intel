import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { MarkmapMcpContext } from "./context.js";
import { ToolRegistry } from "./tool-registry.js";
export declare class MarkmapToolRegistry extends ToolRegistry {
    register(): void;
}
/**
 * Registers Markmap tools with the provided server and context.
 * @param server - The MCP server instance to register tools with
 * @param context - The context object containing configuration and state information
 */
export declare function registerMarkmapTools(server: McpServer, context: MarkmapMcpContext): void;
