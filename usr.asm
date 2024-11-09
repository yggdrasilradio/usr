
; ROM routines
INTCNV	EQU	$B3ED	; Convert incoming floating numeric value to integer in D
GIVABF	EQU	$B4F4	; Return D as integer value to caller
GIVBF	EQU	$B4F3 	; Return B as integer value to caller

	org	$1000

	; dispatch table
	fdb	usr0
	fdb	usr1
	fdb	usr2

	; multiply by 2
usr0	jsr	INTCNV	; Get passed-in value in D
	lslb
	rola
	jmp	GIVABF	; Return to caller

	; divide by 2
usr1	jsr	INTCNV	; Get passed-in value in D
	lsra
	rorb
	jmp	GIVABF	; Return to caller

	; Return number of vowels in string to caller
usr2	clrb		; return value is zero for now
	tsta		; is this a string?
	beq	wrong@	; if not, string length is zero
	lda	,x	; it's a string; get string length
wrong@	pshs	a	; loop counter is on stack
	tsta		; zero length string?
	beq	done@	; if so, we're done
	ldx	2,x	; pointer to string data
loop@	lda	,x+	; get next character
	anda	#$DF	; convert to upper case
	cmpa	#'A'	; A?
	beq	vowel@
	cmpa	#'E'	; E?
	beq	vowel@
	cmpa	#'I'	; I?
	beq	vowel@
	cmpa	#'O'	; O?
	beq	vowel@
	cmpa	#'U'	; U?
	bne	*+3
vowel@	incb		; count one more vowel
	dec	,s	; looked at all the characters yet?
	bne	loop@	; keep going if not
done@	puls	a	; clean up stack
	jmp	GIVBF	; return number of vowels
