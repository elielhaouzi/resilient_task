# ResilientTask

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/elielhaouzi/resilient_task/CI?cacheSeconds=3600&style=flat-square)](https://github.com/elielhaouzi/resilient_task/actions) [![GitHub issues](https://img.shields.io/github/issues-raw/elielhaouzi/resilient_task?style=flat-square&cacheSeconds=3600)](https://github.com/elielhaouzi/resilient_task/issues) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?cacheSeconds=3600?style=flat-square)](http://opensource.org/licenses/MIT) [![Hex.pm](https://img.shields.io/hexpm/v/resilient_task?style=flat-square)](https://hex.pm/packages/resilient_task) [![Hex.pm](https://img.shields.io/hexpm/dt/resilient_task?style=flat-square)](https://hex.pm/packages/resilient_task)

Don't worry, the task will be done.  
Based on OTP, a GenServer will try to run the task. In case of success, the GenServer will stop. In case of error, it will retry next time with a backoff.  
`ResilientTask` is a tiny library to make your tasks resilient.

## Installation

ResilientTask is published on [Hex](https://hex.pm/packages/resilient_task).
The package can be installed by adding `resilient_task` to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:resilient_task, "~> 0.1.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/resilient_task](https://hexdocs.pm/resilient_task).
