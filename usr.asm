
; ROM routines
STRDES	EQU	$56	; String descriptor
_LEN	EQU	0	;	length
_PTR	EQU	2	;	pointer
CHKNUM	EQU	$B143	; Check for number type
CHKSTR	EQU	$B146	; Check for string type
INTCNV	EQU	$B3ED	; Convert incoming floating numeric value to integer in D
GIVBF	EQU	$B4F3 	; Return B as integer value to caller
GIVABF	EQU	$B4F4	; Return D as integer value to caller
GIVSTR	EQU	$B54C	; Return string to caller
RSVPSTR	EQU	$B56D	; Reserve string space

	org	$1000

	; dispatch table
	fdb	usr0
	fdb	usr1
	fdb	usr2
	fdb	usr3

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
	lda	_LEN,x	; it's a string; get string length
wrong@	pshs	a	; loop counter is on stack
	tsta		; zero length string?
	beq	done@	; if so, we're done
	ldx	_PTR,x	; pointer to string data
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

	; return string based on sign of numeric argument
usr3	jsr	CHKNUM		; check for number
	jsr	INTCNV		; convert argument to integer
	bmi	ltz@		; if negative, return "MINUS"
	beq	eqz@		; if zero, return "ZERO"
	leax	plus,pcr	; else return "PLUS"
	bra	done@
ltz@	leax	minus,pcr
	bra	done@
eqz@	leax	zero,pcr
done@	ldb	,x+		; get length
	stb	STRDES + _LEN	; save length
	stx	STRDES + _PTR	; save text
	jmp	GIVSTR		; return string

minus	fcb	5
	fcc	'MINUS'
zero	fcb	4
	fcc	'ZERO'
plus	fcb	4
	fcc	'PLUS'

