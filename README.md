# BusinessProcess

**TODO: Add description**

```
def some_func(input) do ...               # no
def some_func(%{}=input) do ...           # no
def some_func(%MyStruct{}=input) do ...   # yes
```
