local dap = require("dap")

dap.adapters["haskell-debugger"] = {
  type = "server",
  port = "${port}",
  executable = {
    command = "hdb",
    args = {
      "server", "--port", "${port}"
    }
  }
}

dap.configurations.haskell = {
  {
    type = "haskell-debugger",
    request = "launch",
    name = "hdb:file:main",
    entryFile = "${file}",
    entryPoint = "main",
    projectRoot = "${workspaceFolder}",
    entryArgs = {},
    extraGhcArgs = {},
  },
}
