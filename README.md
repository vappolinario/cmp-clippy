# cmp-clippy

nvim-cmp source implementation of VSCode Clippy extension.

## Code Clippy VSCode

[Code Clippy VSCode](https://github.com/ncoop57/code-clippy-vscode) extension is an effort to create an open source version of Github Copilot where both the extension, model, and data that the model was trained on is free for everyone to use. If you'd like to learn more about how the model power Code Clippy, check out this [repo](https://github.com/ncoop57/gpt-code-clippy/).

# Installlation

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'vappolinario/cmp-clippy'
```

Additionally, you will need a [Huggingface account](https://huggingface.co/join) in order to obtain the necessary API key that is used to authorize calls to Huggingface's Inference API.

## Setup

```lua
require'cmp'.setup {
  sources = {
    { name = 'cmp-clippy',
      opts = {
        model = "EleutherAI/gpt-neo-2.7B", -- check code clippy vscode repo for options
        key = "", -- huggingface.co api key
      }
    }
  }
}
```

# Limitations

As expressed in code-clippy-vscode README.md:

| :exclamation:  **Important -**  First and formost, this extension is a **prototype** and the model it was trained on is for **research purposes** only and should not be used for developing real world applications. This is because the default model that is used to generate the code suggestions was trained on a large set of data scraped from [GitHub]() that might have contained things such as vulnerable code or private information such as private keys or passwords. Vulnerable code or private information can and therefore probably will leak into the suggestions. Currently the suggestions are just limited to a few additional tokens since the model starts to [hallucinate]() variables and methods the longer suggestions it is allowed to generate. If you would like to read more about the shortcomings of the model used in the generation and data used to train the model please refer to this [model card]() and [datasheet]() that explain it more in-depth. If you would like to learn more about how the model was trained and data was collected please refer to this [repository](https://github.com/ncoop57/gpt-code-clippy/). |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
