//
//  lexer.swift
//  csq-lang
//
//  Created by Cope on 12/7/2569 BE.
//

enum token_type
{
	case ID
	case NUM
	case OP
	case ERR
	case EOF
}

struct token
{
	let type: token_type
	let lexeme: Substring

	let line: Int
	let col: Int
	
	init(_ type: token_type, _ lexeme: Substring, _ line: Int, col: Int)
	{
		self.type = type
		self.lexeme = lexeme
		
		self.line = line
		self.col = col
	}
}

struct lexer
{
	private var remainder: Substring
	private let full_src: Substring
	
	private var line: Int = 1
	private var col: Int = 1
	
	init(_ src: consuming String)
	{
		remainder = Substring(src)
		full_src = remainder
	}
	
	private func peek() -> Character?
	{
		return remainder.first
	}
	
	private func peek(_ offset: Int) -> Character?
	{
		return remainder.prefix(offset).last
	}
	
	private mutating func consume(_ amount: Int = 1) -> Void
	{
		remainder = remainder.dropFirst(amount)
	}
	
	private mutating func next() -> Character?
	{
		guard let c = peek() else { return nil }
		consume()
		
		return c
	}
	
	mutating func next_token() -> token
	{
		if remainder.isEmpty
		{
			return token(.EOF, "", line, col: col + 1)
		}
		
		return token(.ERR, "", line, col: col)
	}
}
