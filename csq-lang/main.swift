//
//  main.swift
//  csq-lang
//
//  Created by Cope on 12/7/2569 BE.
//

import Foundation

let my_src = """
int x = 128;
int ~ptr = &x;
"""

let my_lexer = lexer(my_src)
