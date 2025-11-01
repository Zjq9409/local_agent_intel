import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { RegistryBase } from "../../common/registry-base.js";
import { MarkmapMcpContext } from "./context.js";
export declare abstract class ToolRegistry extends RegistryBase {
    protected server: McpServer;
    protected context: MarkmapMcpContext;
    constructor(server: McpServer, context: MarkmapMcpContext);
    /**
     * Registers all applicable tools based on site version and authentication status.
     * This method follows a specific registration sequence to ensure proper tool organization.
     */
    registerTools(): void;
}
