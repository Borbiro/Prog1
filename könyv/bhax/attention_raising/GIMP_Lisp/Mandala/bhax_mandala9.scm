; bhax_mandala9.scm
;
; BHAX-Mandala creates a mandala from a text box.
; Copyright (C) 2019  Norbert Bátfai, batfai.norbert@inf.unideb.hu
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
; Version history
;
;  This Scheme code is partially based on the Python code 
;  Pat625_Mandala_With_Your_Name.py by Tin Tran, which is released under the GNU GPL v3, see 
;  https://gimplearn.net/viewtopic.php/Pat625-Mandala-With-Your-Name-Script-for-GIMP?t=269&p=976
;
;  https://bhaxor.blog.hu/2019/01/10/a_gimp_lisp_hackelese_a_scheme_programozasi_nyelv
; 

(define (elem x lista)

    (if (= x 1) (car lista) (elem (- x 1) ( cdr lista ) ) )

)

(define (text-width text font fontsize)
(let*
    (
        (text-width 1)
    )
    (set! text-width (car (gimp-text-get-extents-fontname text fontsize PIXELS font)))    

    text-width
    )
)

(define (text-wh text font fontsize)
(let*
    (
        (text-width 1)
        (text-height 1)
    )
    ;;;
    (set! text-width (car (gimp-text-get-extents-fontname text fontsize PIXELS font)))    
    ;;; ved ki a lista 2. elemét
    (set! text-height (elem 2  (gimp-text-get-extents-fontname text fontsize PIXELS font)))    
    ;;;    
    
    (list text-width text-height)
    )
)


;(text-width "alma" "Sans" 100)

(define (script-fu-bhax-mandala text text2 font fontsize width height color gradient)
(let*
    (
        (image (car (gimp-image-new width height 0)))
        (layer (car (gimp-layer-new image width height RGB-IMAGE "bg" 100 LAYER-MODE-NORMAL-LEGACY)))
        (textfs)
        (text-layer)
        (text-width (text-width text font fontsize))
        ;;;
        (text2-width (car (text-wh text2 font fontsize)))
        (text2-height (elem 2 (text-wh text2 font fontsize)))
        ;;;
        (textfs-width)
        (textfs-height)
        (gradient-layer)
    )

    (gimp-image-insert-layer image layer 0 0)

    (gimp-context-set-foreground '(0 255 0))
    (gimp-drawable-fill layer FILL-FOREGROUND)
    (gimp-image-undo-disable image) 

    (gimp-context-set-foreground color)

    (set! textfs (car (gimp-text-layer-new image text font fontsize PIXELS)))
    (gimp-image-insert-layer image textfs 0 -1)
    (gimp-layer-set-offsets textfs (- (/ width 2) (/ text-width 2))  (/ height 2))
    (gimp-layer-resize-to-image-size textfs)

    (set! text-layer (car (gimp-layer-new-from-drawable textfs image)))
    (gimp-image-insert-layer image text-layer 0 -1)
    (gimp-item-transform-rotate-simple text-layer ROTATE-180 TRUE 0 0)
    (set! textfs (car(gimp-image-merge-down image text-layer CLIP-TO-BOTTOM-LAYER)))

    (set! text-layer (car (gimp-layer-new-from-drawable textfs image)))
    (gimp-image-insert-layer image text-layer 0 -1)
    (gimp-item-transform-rotate text-layer (/ *pi* 2) TRUE 0 0)
    (set! textfs (car(gimp-image-merge-down image text-layer CLIP-TO-BOTTOM-LAYER)))

    (set! text-layer (car (gimp-layer-new-from-drawable textfs image)))
    (gimp-image-insert-layer image text-layer 0 -1)
    (gimp-item-transform-rotate text-layer (/ *pi* 4) TRUE 0 0)
    (set! textfs (car(gimp-image-merge-down image text-layer CLIP-TO-BOTTOM-LAYER)))
    
    (set! text-layer (car (gimp-layer-new-from-drawable textfs image)))
    (gimp-image-insert-layer image text-layer 0 -1)
    (gimp-item-transform-rotate text-layer (/ *pi* 6) TRUE 0 0)
    (set! textfs (car(gimp-image-merge-down image text-layer CLIP-TO-BOTTOM-LAYER)))    
    
    (plug-in-autocrop-layer RUN-NONINTERACTIVE image textfs)
    (set! textfs-width (+ (car(gimp-drawable-width textfs)) 100))
    (set! textfs-height (+ (car(gimp-drawable-height textfs)) 100))
        
	(gimp-layer-resize-to-image-size textfs)
    
    (gimp-image-select-ellipse image CHANNEL-OP-REPLACE (- (- (/ width 2) (/ textfs-width 2)) 18) 
        (- (- (/ height 2) (/ textfs-height 2)) 18) (+ textfs-width 36) (+ textfs-height 36))
	(plug-in-sel2path RUN-NONINTERACTIVE image textfs)
        
    (gimp-context-set-brush-size 22)
    (gimp-edit-stroke textfs)
    
    (set! textfs-width (- textfs-width 70))
    (set! textfs-height (- textfs-height 70))
    
    (gimp-image-select-ellipse image CHANNEL-OP-REPLACE (- (- (/ width 2) (/ textfs-width 2)) 18) 
        (- (- (/ height 2) (/ textfs-height 2)) 18) (+ textfs-width 36) (+ textfs-height 36))
	(plug-in-sel2path RUN-NONINTERACTIVE image textfs)
        
    (gimp-context-set-brush-size 8)
    (gimp-edit-stroke textfs)
        
    (set! gradient-layer (car (gimp-layer-new image width height RGB-IMAGE "gradient" 100 LAYER-MODE-NORMAL-LEGACY)))
    
    (gimp-image-insert-layer image gradient-layer 0 -1)
	(gimp-image-select-item image CHANNEL-OP-REPLACE textfs)
	(gimp-context-set-gradient gradient) 
	(gimp-edit-blend gradient-layer BLEND-CUSTOM LAYER-MODE-NORMAL-LEGACY GRADIENT-RADIAL 100 0 
	REPEAT-TRIANGULAR FALSE TRUE 5 .1 TRUE (/ width 2) (/ height 2) (+ (+ (/ width 2) (/ textfs-width 2)) 8) (/ height 2))
	
	(plug-in-sel2path RUN-NONINTERACTIVE image textfs)

    (set! textfs (car (gimp-text-layer-new image text2 font fontsize PIXELS)))
    (gimp-image-insert-layer image textfs 0 -1)
    (gimp-message (number->string text2-height))
    (gimp-layer-set-offsets textfs (- (/ width 2) (/ text2-width 2)) (- (/ height 2) (/ text2-height 2)))
		
    ;(gimp-selection-none image)
    ;(gimp-image-flatten image)
    
    (gimp-display-new image)
    (gimp-image-clean-all image)
    )
)

;(script-fu-bhax-mandala "Bátfai Norbert" "BHAX" "Ruge Boogie" 120 1920 1080 '(255 0 0) "Shadows 3")

(script-fu-register "script-fu-bhax-mandala"
    "Mandala9"
    "Creates a mandala from a text box."
    "Norbert Bátfai"
    "Copyright 2019, Norbert Bátfai"
    "January 9, 2019"
    ""
    SF-STRING       "Text"      "Bátf41 Haxor"
    SF-STRING       "Text2"     "BHAX"
    SF-FONT         "Font"      "Sans"
    SF-ADJUSTMENT   "Font size" '(100 1 1000 1 10 0 1)
    SF-VALUE        "Width"     "1000"
    SF-VALUE        "Height"    "1000"
    SF-COLOR        "Color"     '(255 0 0)
    SF-GRADIENT     "Gradient"  "Deep Sea"
)
(script-fu-menu-register "script-fu-bhax-mandala" 
    "<Image>/File/Create/BHAX"
)
