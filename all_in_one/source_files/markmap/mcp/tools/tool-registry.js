import { RegistryBase } from "../../common/registry-base.js";
export class ToolRegistry extends RegistryBase {
    server;
    context;
    constructor(server, context) {
        super(server, context);
        this.server = server;
        this.context = context;
    }
    /**
     * Registers all applicable tools based on site version and authentication status.
     * This method follows a specific registration sequence to ensure proper tool organization.
     */
    registerTools() {
        this.register();
    }
}
//# sourceMappingURL=tool-registry.js.map