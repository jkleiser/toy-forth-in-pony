# toy-forth-in-pony
This will not teach you much about how to implement real Forth. The most interesting part is probably 
how one can keep references to Pony functions (the Forth words) in a Map (the `_dict`). 
Without the crucial help I got from Chris and Joe, I would have had problems solving that part.

I more or less ported the Scala code found at [https://github.com/joneshf/forla](https://github.com/joneshf/forla).

The readline part is based on the Pony [readline example](https://github.com/ponylang/ponyc/tree/master/examples/readline).

There may of course be things in my Pony code that could be improved. Feel free to file an issue.