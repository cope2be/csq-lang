//
//  main.swift
//  csq-lang
//
//  Created by Cope on 12/7/2569 BE.
//

import Foundation

let my_src: String = """
int x = 128;
int ~ptr = &x;
"""

var my_lexer: lexer = lexer(my_src)
var my_tokens: [ token ] = []

repeat
{
	let t = my_lexer.next_token()
	
//	print(t)
	my_tokens.append(t)
}
while my_tokens.last?.type != .EOF
				
diag_err("help: *useful info*", [ diag_ctx(my_tokens[3], "haha yes", "something something error"), diag_ctx(my_tokens[5], "no info") ])

exit(0)
