
;; digit and identifiers lists
(defvar digit '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))
(defvar identifiers '(#\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z #\_) )

;; Operators and Keywords lists
(defvar keywordList '("and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "deffun" "for" "if" "exit" "load" "disp" "true" "false"))
(defvar TokenKwList '("KW_AND" "KW_OR" "KW_NOT" "KW_EQUAL" "KW_LESS" "KW_NIL" "KW_LIST" "KW_APPEND" "KW_CONCAT" "KW_SET" "KW_DEFFUN" "KW_FOR" "KW_IF" "KW_EXIT" "KW_LOAD" "KW_DISP" "KW_TRUE" "KW_FALSE"))
(defvar operatorList '("+" "-" "/" "*" "(" ")" "**" "\"" "\"" ","))
(defvar TokenOpList '("OP_PLUS" "OP_MINUS" "OP_DIV" "OP_MULT" "OP_OP" "OP_CP" "OP_DBLMULT" "OP_OC" "OP_CC" "OP_COMMA"))

;; Operators and Comment list
(defvar operatorListAndComma '("+" "-" "/" "*" "(" ")" "**" "\"" "\"" "," ";;"))
;; Flag for quot
(defvar Qflag 0)


(defun gppinterpreter (&optional (filename -1))
	(progn
		(with-open-file (stream  "parsed_lisp.txt"
                       :direction :output
                       :if-exists :rename-and-delete
                       :if-does-not-exist :create ))
		(if (equal filename -1)
			(let ((line))
				(loop 
				   (setq line (read-line))
				   (ParseLine line)
				   (when (equal line "") (return))
				)
			)
			(let ((inStream (open filename :if-does-not-exist nil)))
	   			(when inStream
	      			(loop for line = (read-line inStream nil)
	      			while line do (ParseLine line))
	      			(close inStream)
	   			)
			)
		)
	)
)

(defun ParseLine (line)
	(let ((words) (ret 0) (tempword))
		(setq line (string-trim '(#\Space #\Tab #\Newline) line))
		(setq words (my-split-func line))
		(loop for word in words
			do
			(progn
				(setq ret (lexer word))
				(if (= ret 2) (return ret))
			)
		)
		ret			
	)
)

(defun lexer (word)
	(let ((len (length word)) (subword) (j 0) (res) (temp) (symbol))
		(loop for i from 1 to len
			do
			(progn
				(setq subword (subseq word j i))
				(setq symbol (char word (- i 1)))

				;determine word is operator
				(setq res (findIndexInListRec subword operatorList))
				(when (not (equal res nil))
					(progn
						(if (equal res 7)
							(if (equal Qflag 0)
								(setq Qflag 1)
								(progn
									(setq Qflag 0)
									(setq res 8)
								)
							)
						)
						(if (and (equal res 3) (> len 1) (equal (char word i) #\*))
							(progn
								(setq res 6)
								(setq i (+ i 1))
							)
						)
						(write-line (nth res TokenOpList))
						(writeToFile (nth res TokenOpList))
						(setq j i)
					)
				)

				;determine word is comment
				(when (and (equal symbol #\;) (> len 1) (equal (char word i) #\;))
					(progn
						(write-line "COMMENT")
						(writeToFile "COMMENT")
						(return-from lexer 2)
					)
				)

				;determine word is value
				(when (equal (is-Digit symbol) t)
					(progn
						(if (and (equal symbol #\0) (= i len))
							(progn
								(write-line "VALUE")
								(writeToFile "VALUE")
							)
							(if (and (equal symbol #\0) (< i len))
								(progn
								 	(setq temp (subseq word i (+ i 1)))
								 	(if (equal (findIndexInListRec temp operatorListAndComma) nil)
										(progn 
											(setq i (- i 1))
											(loop
												(setq temp (subseq word i (+ i 1)))
												(setq symbol (char word i))
												(setq i (+ i 1))
												(when (or (equal (is-Digit symbol) nil) (not (equal (findIndexInListRec temp operatorListAndComma) nil)) (>= i len)) (return))
											)
											(if (not (equal (findIndexInListRec temp operatorListAndComma) nil)) (setq i (- i 1)))
											(format t "SYNTAX ERROR ~S can not be tokenized. ERROR" (subseq word j i)) (terpri) (writeToFile "ERROR  can not be tokenized.") (setq j i)
										)
								 		(progn (write-line "VALUE") (writeToFile "VALUE") (setq j i))
								 	)
								)
								(progn
									(setq i (- i 1))
									(loop
										(setq temp (char word i))
										(setq i (+ i 1))
										(when (or (equal (is-Digit temp) nil) (>= i len)) (return))
									)
									(if (equal (is-Digit temp) nil) (setq i (- i 1)))
									(if (>= i len)
										(progn
											(write-line "VALUE")
											(writeToFile "VALUE")
										)
										(progn
										 	(setq temp (subseq word i (+ i 1)))
										 	(if (equal (findIndexInListRec temp operatorListAndComma) nil)
												(progn (format t "SYNTAX ERROR ~S can not be tokenized. ERROR" (subseq word j len)) (terpri) (writeToFile "ERROR  can not be tokenized.")  (return-from lexer 1))
										 		(progn (write-line "VALUE") (writeToFile "VALUE") (setq j i))
										 	)
										)
									)
								)
							)
						)
					)
				)

				;determine word is identifier or keyword
				(when (equal (is-Alphabetical symbol) t)
					(progn
						(setq i (- i 1))
						(loop
							(setq temp (char word i))
							(setq i (+ i 1))
							(when (or (and (equal (is-Digit temp) nil) (equal (is-Alphabetical temp) nil)) (>= i len)) (return))
						)
						(if (and (equal (is-Digit temp) nil) (equal (is-Alphabetical temp) nil)) (setq i (- i 1)))
						(if (>= i len)
							(progn
								(setq temp (subseq word j len))
								(setq res (findIndexInListRec temp keywordList))
							 	(if (equal res nil)
									(progn (write-line "IDENTIFIER") (writeToFile "IDENTIFIER") (return-from lexer 1))
							 		(progn (write-line (nth res TokenKwList)) (writeToFile (nth res TokenKwList)) (return-from lexer 1))
							 	)
							)
							(progn
							 	(setq temp (subseq word i (+ i 1)))
							 	(if (equal (findIndexInListRec temp operatorListAndComma) nil)
									(progn (format t "SYNTAX ERROR ~S can not be tokenized. ERROR" (subseq word j len)) (terpri) (writeToFile "ERROR  can not be tokenized.") (return-from lexer 1))
							 		(progn
							 			(setq temp (subseq word j i))
							 			(setq res (findIndexInListRec temp keywordList))
							 			(if (equal res nil)
											(progn (write-line "IDENTIFIER") (writeToFile "IDENTIFIER") )
									 		(progn (write-line (nth res TokenKwList)) (writeToFile (nth res TokenKwList)) )
									 	)
							 			(setq j i)
							 		)
							 	)
							)
						)
					)
				)
			)
		)
		1
	)
)

(defun writeToFile (content)
  (with-open-file (stream  "parsed_lisp.txt"
                           :direction :output
                           :if-exists :append
                           :if-does-not-exist :create )
  (format stream content)
  (terpri stream))
)

(defun delimiterp (_char) (or (char= _char #\Space) (char= _char #\Tab) (char= _char #\Newline)))

(defun my-split-func (string &key (delimiterp #'delimiterp))
  (loop :for beg = (position-if-not delimiterp string)
    :then (position-if-not delimiterp string :start (1+ end))
    :for end = (and beg (position-if delimiterp string :start beg))
    :when beg :collect (subseq string beg end)
    :while end))

(defun findIndexInListRec (word _List &optional (i 0))
	(if (null _List)
		nil
		(if (string= word (car _List))
			i
			(findIndexInListRec word (cdr _List) (+ i 1))
		)
	)
)

(defun is-Digit (_char)
	(if (equal(position _char digit ) nil)
		nil
		t
	)
)

(defun is-Alphabetical (_char)
	(if (equal(position _char identifiers ) nil)
		nil
		t
	)
)


(if (equal (nth 0  *args*) nil)
	(gppinterpreter)
	(gppinterpreter (nth 0  *args*))
)