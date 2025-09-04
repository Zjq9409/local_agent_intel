export OPENAI_BASE_URL=http://10.238.157.33:8000/v1
export OPENAI_API_KEY="intel123"
export OPENAI_MODEL=ui-tars 
export no_proxy=10.238.157.33
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":0.09, "clientCapabilities": {"fs": {"readTextFile": true,"writeTextFile": true,"stat": true}}}}' | qwen --experimental-acp &
