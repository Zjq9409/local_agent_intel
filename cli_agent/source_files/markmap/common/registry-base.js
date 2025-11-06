export class RegistryBase {
    server;
    context;
    /**
     * Creates a new registry instance.
     *
     * @param server - The MCP server instance to register components with
     * @param context - The context object containing configuration and state information
     */
    constructor(server, context) {
        this.server = server;
        this.context = context;
    }
}
//# sourceMappingURL=registry-base.js.map