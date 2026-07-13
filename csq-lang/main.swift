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
var my_token: token = my_lexer.get_next_token()

while my_token.type != .EOF
{
	print(my_token)
	my_token = my_lexer.get_next_token()
}

print(my_lexer.get_line(0)!)
print(my_lexer.get_line(1)!)
