//
//  lexer.swift
//  csq-lang
//
//  Created by Cope on 12/7/2569 BE.
//

// i'm going insane
// somebody help

// TODO: add support for puncs, types, and multi chars symbols

enum token_type
{
	case ID
	case NUM
	case OP
	case STR
	case ERR
	case EOF
}

struct token
{
	let type: token_type
	let lexeme: Substring

	let line: Int
	let col: Int
	
	init(_ type: token_type, _ lexeme: Substring, _ line: Int, _ col: Int)
	{
		self.type = type
		self.lexeme = lexeme
		
		self.line = line
		self.col = col
	}
}

private enum state
{
	case DEFAULT
}

struct lexer
{
	private var remainder: Substring
	private let full_src: Substring
	
	private var line_start: Substring.Index
	private var lines: [ Substring ] = []

	private var line: Int = 1
	private var col: Int = 1
	
	private var curr_state: state = .DEFAULT
	
	init(_ src: consuming String)
	{
		let substr = Substring(src)
		
		remainder = substr
		full_src = substr
		
		line_start = substr.startIndex
	}
	
	private func peek() -> Character?
	{
		return remainder.first
	}
	
	private func peek(_ offset: Int) -> Character?
	{
		guard
			let idx: Substring.Index = remainder.index(remainder.startIndex, offsetBy: offset, limitedBy: remainder.endIndex),
			idx != remainder.endIndex
		else
		{
			return nil
		}
		
		return remainder[idx]
	}
	
	private mutating func consume(_ amount: Int = 1) -> Void
	{
		for _ in 0..<amount
		{
			guard let c: Character = remainder.first else { break }
			
			if c.isNewline
			{
				lines.append(full_src[line_start..<remainder.startIndex])
				line_start = remainder.index(after: remainder.startIndex)
				
				line += 1
				col = 1
			}
			else
			{
				col += 1
			}
			
			remainder = remainder.dropFirst()
		}
	}
	
	mutating func get_next_token() -> token
	{
		if curr_state == .DEFAULT
		{
			while let c: Character = peek(), c.isWhitespace
			{
				consume()
			}
		}
		
		if remainder.isEmpty
		{
			if line_start < full_src.endIndex && lines.count < line
			{
				lines.append(full_src[line_start...])
			}
			
			return token(.EOF, "", line, col)
		}
		
		let start_line = line
		let start_col = col
		
		let start_idx = remainder.startIndex
		
		switch curr_state
		{
		case .DEFAULT:
			let c: Character = peek()!
			
			if c.isLetter || c == "_"
			{
				while
					let next_c: Character = peek(),
					next_c.isLetter || next_c.isNumber || next_c == "_"
				{
					consume()
				}
				
				return token(.ID, full_src[start_idx..<remainder.startIndex], start_line, start_col)
			}
			
			if c.isNumber
			{
				while let next_c: Character = peek(), next_c.isNumber
				{
					consume()
				}
				
				return token(.NUM, full_src[start_idx..<remainder.startIndex], start_line, start_col)
			}
			
			consume()
			return token(.OP, full_src[start_idx..<remainder.startIndex], start_line, start_col)
		}
	}
	
	func get_line(_ idx: Int) -> Substring?
	{
		guard idx < lines.endIndex else { return nil }
		return lines[idx]
	}
}
