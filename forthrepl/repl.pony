use "collections"
use "promises"
use "term"

type PartialFunRef is ({ref() ?} ref)
type FunBox is ({box()} ref)
type AnyMethod is (PartialFunRef | FunBox)

class ForthRepl is ReadlineNotify
  let _env: Env
  let _dict: Map[String, AnyMethod] = _dict.create()
  let _stack: Array[I64] = _stack.create()
  var _i: U64 = 0
  
  new create(env: Env) =>
    _env = env
    _dict("+") = this~_add()
    _dict("-") = this~_sub()
    _dict("*") = this~_mul()
    _dict("/") = this~_div()
    _dict(".") = this~_print()

  fun ref apply(line: String, prompt: Promise[String]) =>
    if line == "bye" then
      prompt.reject()
    else
      _interpret(line)
      _i = _i + 1
      prompt(_i.string() + " > ")
    end

  fun ref _interpret(line: String) =>
    for each_token in line.split(" ").values() do
    	try
        _execute(_dict(each_token))
      else
        _number(each_token)
      end
    end

  fun ref _execute(func: AnyMethod) =>
    match func
    | let fun_ref: PartialFunRef => try fun_ref() else _env.out.print("Stack underflow") end
    | let fun_box: FunBox => fun_box()
    end

  fun ref _number(token: String) =>
    try
      _stack.push(token.i64())
    else
      _env.out.print(token + " ?")
    end

  fun ref _add() ? => _stack.push(_stack.pop() + _stack.pop())
  fun ref _sub() ? => _stack.push(_stack.pop() - _stack.pop())
  fun ref _mul() ? => _stack.push(_stack.pop() * _stack.pop())
  fun ref _div() ? => _stack.push(_stack.pop() / _stack.pop())
  
  fun _print() =>
    for n in _stack.reverse().values() do
      _env.out.write(n.string() + " ")
    end
    _env.out.write("\n")

actor Main
  new create(env: Env) =>
    env.out.print("Use 'bye' to exit.")
    
    let term = ANSITerm(Readline(recover ForthRepl(env) end, env.out), env.input)
    term.prompt("0 > ")

    let notify = object iso
      let term: ANSITerm = term
      fun ref apply(data: Array[U8] iso) => term(consume data)
      fun ref dispose() => term.dispose()
    end

    env.input(consume notify)
