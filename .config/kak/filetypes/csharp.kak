# Detection
# ‾‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](cs|csx|csi) %{
	set-option buffer filetype csharp
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=csharp %{
	require-module csharp
}

hook -group csharp-highlight global WinSetOption filetype=csharp %{
    add-highlighter window/csharp ref csharp
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/csharp }
}

# Highlighters & Completion
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/csharp regions
add-highlighter shared/csharp/code default-region group
add-highlighter shared/csharp/double_string region @?(?<!')" (?<!\\)(\\\\)*"B? fill string
add-highlighter shared/csharp/single_string region @?(?<!')' (?<!\\)(\\\\)*'B? fill string
add-highlighter shared/csharp/comment-line region '//' '$' fill comment
add-highlighter shared/csharp/comment-block region '/\*' '\*/' fill comment
# add-highlighter shared/csharp/attributes region "\s\[" "\]" fill meta

# functions
# add-highlighter shared/csharp/code/ regex '(([_a-zA-Z])([_a-zA-Z0-9])*(?=\())' 0:function
add-highlighter shared/csharp/code/ regex '(([_a-zA-Z])\w*(?=\())' 0:function

# attributes
# add-highlighter shared/csharp/code/ regex '(?<=\s\[)[a-zA-Z]*(?=[\(\]])' 0:meta
add-highlighter shared/csharp/code/ regex '(?<=\s\[)\w*(?=[\(\]])' 0:meta

# class and struct declaration
# add-highlighter shared/csharp/code/ regex '(((?<=class )|(?<=struct ))([_a-zA-Z])([_a-zA-Z0-9])*(?=\s))' 0:attribute
add-highlighter shared/csharp/code/ regex '(((?<=class )|(?<=struct ))([_a-zA-Z])\w*(?=\s))' 0:attribute

# variables
# add-highlighter shared/csharp/code/ regex '(?<=[\h(])\w*((?=\.\w)|(?=\[\w))' 0:variable
# add-highlighter shared/csharp/code/ regex '(^\h*|(?<=\w)\h+|(?<=;)\h*)\w*\h*((?=;)|(?==)|(?=\+)|(?=-)|(?=\*))' 0:variable
add-highlighter shared/csharp/code/ regex '(^\h*|(?<=[\w\]>])\h+|(?<=[;=+\-*/<>{}(,])\h*)\w*\h*((?=[,;)=+\-*/<>])\h*|(?=\.\w)|(?=\[\w))' 0:variable

# types
# add-highlighter shared/csharp/code/ regex '\w\h*\w*((?=,)|(?==)|(?=\h=))' 0:meta
# add-highlighter shared/csharp/code/ regex '((?<=\()|(?<=,)|(?<=, ))\w*(?= \w)' 0:type
add-highlighter shared/csharp/code/ regex '\w*\h+(?=\w)' 0:type
add-highlighter shared/csharp/code/ regex '\w*((?=<)|(?=\[\]))' 0:type

# surrounders
add-highlighter shared/csharp/code/ regex '[\[\]\(\){}]' 0:bracket

# numbers
add-highlighter shared/csharp/code/ regex '(?<![^\s(,=\[])(-|)([0-9]+)(\.([0-9]+)|)([fFdDmM]|)' 0:value

# operators
add-highlighter shared/csharp/code/ regex '[=<>+\-*/]' 0:operator

# add-highlighter shared/csharp/code/ regex '\b((?<=(^| |\.))([_a-zA-Z])([_a-zA-Z0-9])*(?=\())\b' 0:function
# add-highlighter shared/csharp/code/ regex '\b(([_\p{L}\p{Nl}])([\p{L}\p{Nl}\p{Nd}\p{Pc}\p{Mc}\p{Mn}\p{Cf}])*(?=\())\b' 0:function

evaluate-commands %sh{
	keywords="abstract|as|base|break|case|catch|checked|class|const|continue"
	keywords="${keywords}|default|do|else|event|explicit|extern|finally"
	keywords="${keywords}|fixed|for|foreach|goto|if|implicit|in|interface"
	keywords="${keywords}|internal|is|lock|namespace|new|operator|out"
	keywords="${keywords}|override|params|private|protected|public|readonly"
	keywords="${keywords}|ref|return|sealed|sizeof|stackalloc|static|struct"
	keywords="${keywords}|switch|this|throw|try|typeof|unchecked|unsafe"
	keywords="${keywords}|using|virtual|volatile|while"

	context="add|alias|ascending|async|await|by|descending|dynamic|equals"
	context="${context}|from|get|global|group|into|join|let|nameof|on"
	context="${context}|orderby|partial|remove|select|set|unmanaged|value"
	context="${context}|var|when|where|yield"

	types="bool|byte|char|decimal|delegate|double|float|int|long"
	types="${types}|object|sbyte|short|string|uint|ulong|ushort|void"

	values="true|false|null"

	# Add the language's grammar to the static completion list
	printf '%s\n' "hook global WinSetOption filetype=csharp %{
		set-option window static_words ${keywords} ${context} ${types}
	}" | tr '|' ' '

    # Highlight keywords
    printf '%s\n' "
        add-highlighter shared/csharp/code/ regex '\b(${keywords})\b' 0:keyword
        add-highlighter shared/csharp/code/ regex '\b(${context})\b' 0:keyword
        add-highlighter shared/csharp/code/ regex '\b(${types})\b' 0:type
        add-highlighter shared/csharp/code/ regex '\b(${values})\b' 0:value
    "
}
