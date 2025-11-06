interface CreateMarkmapOptions {
    /**
     * Markdown content to be converted into a mind map
     */
    content: string;
    /**
     * Output file path, if not provided, a temporary file will be created
     */
    output?: string;
    /**
     * Whether to open the output file after generation
     * @default false
     */
    openIt?: boolean;
}
interface CreateMarkmapResult {
    /**
     * Path to the generated HTML file
     */
    filePath: string;
    /**
     * Content of the generated HTML file
     */
    content: string;
}
/**
 * Creates a mind map from Markdown content with additional features.
 *
 * @param options Options for creating the mind map
 * @returns Promise containing the generated mind map file path and content
 */
export declare function createMarkmap(options: CreateMarkmapOptions): Promise<CreateMarkmapResult>;
export {};
