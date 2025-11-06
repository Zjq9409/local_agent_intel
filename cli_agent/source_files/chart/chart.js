#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { CallToolRequestSchema, ErrorCode, ListToolsRequestSchema, McpError, } from '@modelcontextprotocol/sdk/types.js';
import axios from 'axios';
import getenv from 'getenv';
import { HttpsProxyAgent } from 'https-proxy-agent';
const proxyUrl = process.env.https_proxy || process.env.http_proxy;
const proxyAgent = proxyUrl ? new HttpsProxyAgent(proxyUrl) : undefined;
const QUICKCHART_BASE_URL = getenv('QUICKCHART_BASE_URL', 'https://quickchart.io/chart');
class QuickChartServer {
    server;
    constructor() {
        this.server = new Server({
            name: 'quickchart-server',
            version: '1.0.0',
        }, {
            capabilities: {
                tools: {},
            },
        });
        this.setupToolHandlers();
        this.server.onerror = (error) => console.error('[MCP Error]', error);
        process.on('SIGINT', async () => {
            await this.server.close();
            process.exit(0);
        });
    }
    validateChartType(type) {
        const validTypes = [
            'bar', 'line', 'pie', 'doughnut', 'radar',
            'polarArea', 'scatter', 'bubble', 'radialGauge', 'speedometer'
        ];
        if (!validTypes.includes(type)) {
            throw new McpError(ErrorCode.InvalidParams, `Invalid chart type. Must be one of: ${validTypes.join(', ')}`);
        }
    }
    generateChartConfig(args) {
        if (!args) {
            throw new McpError(ErrorCode.InvalidParams, 'No arguments provided to generateChartConfig');
        }
        if (!args.type) {
            throw new McpError(ErrorCode.InvalidParams, 'Chart type is required');
        }
        if (!args.datasets || !Array.isArray(args.datasets)) {
            throw new McpError(ErrorCode.InvalidParams, 'Datasets must be a non-empty array');
        }
        const { type, labels, datasets, title, options = {} } = args;
        this.validateChartType(type);
        const config = {
            type,
            data: {
                labels: labels || [],
                datasets: datasets.map((dataset) => {
                    if (!dataset || !dataset.data) {
                        throw new McpError(ErrorCode.InvalidParams, 'Each dataset must have a data property');
                    }
                    return {
                        label: dataset.label || '',
                        data: dataset.data,
                        backgroundColor: dataset.backgroundColor,
                        borderColor: dataset.borderColor,
                        ...(dataset.additionalConfig || {})
                    };
                })
            },
            options: {
                ...options,
                ...(title && {
                    title: { display: true, text: title }
                })
            }
        };
        // 特殊图表类型校验
        switch (type) {
            case 'radialGauge':
            case 'speedometer':
                if (!datasets?.[0]?.data?.[0]) {
                    throw new McpError(ErrorCode.InvalidParams, `${type} requires a single numeric value`);
                }
                config.options = {
                    ...config.options,
                    plugins: {
                        datalabels: {
                            display: true,
                            formatter: (value) => value
                        }
                    }
                };
                break;
            case 'scatter':
            case 'bubble':
                datasets.forEach((dataset) => {
                    if (!Array.isArray(dataset.data[0])) {
                        throw new McpError(ErrorCode.InvalidParams, `${type} requires data points in [x, y${type === 'bubble' ? ', r' : ''}] format`);
                    }
                });
                break;
        }
        return config;
    }
    async generateChartUrl(config) {
        const encodedConfig = encodeURIComponent(JSON.stringify(config));
        return `${QUICKCHART_BASE_URL}?c=${encodedConfig}`;
    }
    setupToolHandlers() {
        this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
            tools: [
                {
                    name: 'chart_tool',
                    description: 'Generate a chart and download or save image using QuickChart',
                    inputSchema: {
                        type: 'object',
                        properties: {
                          
                            type: { type: 'string', description: 'Chart type (bar, line, pie, ...)' },
                            labels: { type: 'array', items: { type: 'string' }, description: 'Labels for data points' },
                            datasets: {
                                type: 'array',
                                items: {
                                    type: 'object',
                                    properties: {
                                        label: { type: 'string' },
                                        data: { type: 'array' },
                                        backgroundColor: { oneOf: [{ type: 'string' }, { type: 'array', items: { type: 'string' } }] },
                                        borderColor: { oneOf: [{ type: 'string' }, { type: 'array', items: { type: 'string' } }] },
                                        additionalConfig: { type: 'object' }
                                    },
                                    required: ['data']
                                }
                            },
                            title: { type: 'string' },
                            
                            options: { type: 'object' },
                           
                        },
                        required: ['type', 'datasets']
                    }
                }
            ]
        }));
        this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
            if (request.params.name !== 'chart_tool') {
                throw new McpError(ErrorCode.MethodNotFound, `Unknown tool: ${request.params.name}`);
            }
            try {
                const {  outputPath: userProvidedPath } = request.params.arguments;
                const config = this.generateChartConfig(request.params.arguments);
                const url = await this.generateChartUrl(config);
                const fs = await import('fs');
                const path = await import('path');
                const os = await import('os');
                
                let outputPath = userProvidedPath;
                if (!outputPath) {

                        const currentDir = process.cwd();

                        // 判断当前目录是否可写
                        try {
                            await fs.promises.access(currentDir, fs.constants.W_OK);
                        } catch {
                            throw new McpError(ErrorCode.InvalidParams, `Current directory not writable: ${currentDir}`);
                        }

                        const timestamp = new Date().toISOString()
                            .replace(/:/g, '-')
                            .replace(/\..+/, '')
                            .replace('T', '_');

                        outputPath = path.join(currentDir, `chart_${timestamp}.png`);
                        console.error(`No output path provided, using current directory: ${outputPath}`);
                                    }
                const outputDir = path.dirname(outputPath);
                try {
                    await fs.promises.access(outputDir, fs.constants.W_OK);
                }
                catch {
                    throw new McpError(ErrorCode.InvalidParams, `Output directory not writable: ${outputDir}`);
                }
                const response = await axios.get(url, {
                    responseType: 'arraybuffer',
                    httpsAgent: proxyAgent,
                    proxy: false,
                    headers: { 'User-Agent': 'Mozilla/5.0' }
                });
                await fs.promises.writeFile(outputPath, response.data);
                               
                return {
                    content: [
                        { type: 'text', text: `Chart saved to: ${outputPath}` }
                    ]
                };
            }
            catch (error) {
                if (error instanceof McpError)
                    throw error;
                throw new McpError(ErrorCode.InternalError, `Chart tool failed: ${error?.message || 'Unknown error'}`);
            }
        });
    }
    async run() {
        const transport = new StdioServerTransport();
        await this.server.connect(transport);
        console.error('QuickChart MCP server running on stdio');
    }options
}
const server = new QuickChartServer();
server.run().catch(console.error);
