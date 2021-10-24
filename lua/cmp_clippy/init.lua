local curl = require("plenary.curl")

local source = {}

---Source constructor.
source.new = function()
  local self = setmetatable({}, { __index = source })
  self.regex = vim.regex([[\%(\.\|\w\)\+\ze\.\w*$]])
  return self
end

---Return the source is available or not.
---@return boolean
function source:is_available()
  if next(vim.lsp.get_active_clients()) == nil then
    return false
  else
    return true
  end
end

---Return the source name for some information.
function source:get_debug_name()
  return 'cmp_clippy'
end

---Return keyword pattern which will be used...
---  1. Trigger keyword completion
---  2. Detect menu start offset
---  3. Reset completion state
---@param params cmp.SourceBaseApiParams
---@return string
function source:get_keyword_pattern(params)
  return [[\w\+]]
end

---Return trigger characters.
---@param params cmp.SourceBaseApiParams
---@return string[]
function source:get_trigger_characters(params)
  return {'.', ',', '{', '(', ' ', '-', '_', '+', '-', '*', '=', '/', '?', '<', '>'}
end

---Invoke completion (required).
---  If you want to abort completion, just call the callback without arguments.
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  local s, e = self.regex:match_str(params.context.cursor_before_line)
  if not s then
    return callback()
  end

  local api_url = "https://api-inference.huggingface.co/models/" .. params.option.model

  local header = {
    authorization = "Bearer " .. params.option.key,
    content_type = "application/json",
  }

  local code = string.sub(params.context.cursor_line, 1, -2)

  local data = {
    inputs = code,
    parameters = {
      max_new_tokens = 16,
      return_full_text = false,
      do_sample = true,
      temperature = 0.8,
      top_p = 0.95,
      max_time = 10,
      num_return_sequences = 3,
      use_gpu = false,
    }
  }

  local res = curl.post(api_url, {
      body = vim.fn.json_encode(data),
      headers  = header
    })

  local item = vim.json.decode(res.body)
  local suggestion = item[1].generated_text
  suggestion = string.sub(suggestion, e+1)

  callback({ { label = suggestion, documentation = suggestion}, isIncomplete = false})
end

---Resolve completion item that will be called when the item selected or before the item confirmation.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:resolve(completion_item, callback)
  callback(completion_item)
end

---Execute command that will be called when after the item confirmation.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
  callback(completion_item)
end

---Execute the api call to the model
---@param code lsp.CompletionItem
source.fetchCodeCompletionTexts = function(code)
end

return source
