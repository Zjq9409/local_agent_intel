import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { MarkmapMcpContext } from "../mcp/tools/context.js";
export declare abstract class RegistryBase {
    protected server: McpServer;
    protected context: MarkmapMcpContext;
    /**
     * Creates a new registry instance.
     *
     * @param server - The MCP server instance to register components with
     * @param context - The context object containing configuration and state information
     */
    constructor(server: McpServer, context: MarkmapMcpContext);
    /**
     * Registers all applicable components based on site version and authentication status.
     * This method follows a specific registration sequence to ensure proper component organization.
     */
    abstract register(): void;
}
