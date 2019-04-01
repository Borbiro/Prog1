; bhax_chrome3_border2.scm
;
; BHAX-Chrome creates a chrome effect on a given text.
; Copyright (C) 2019  
; Norbert Bátfai, batfai.norbert@inf.unideb.hu
; Nándor Bátfai, batfai.nandi@gmail.com
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
;  This Scheme code is partially based on the Gimp tutorial 
;  http://penguinpetes.com/b2evo/index.php?p=351 
;  (the interactive steps of this tutorial are written in Scheme)
;
;  https://bhaxor.blog.hu/2019/01/10/a_gimp_lisp_hackelese_a_scheme_programozasi_nyelv
; 

(define (color-curve)
    (let* (
        (tomb (cons-array 8 'byte))
    )
        (aset tomb 0 0)
        (aset tomb 1 0)
        (aset tomb 2 50)
        (aset tomb 3 190)
        (aset tomb 4 110)
        (aset tomb 5 20)
        (aset tomb 6 200)
        (aset tomb 7 190)
    tomb)    
)

;(color-curve)

(define (elem x lista)

    (if (= x 1) (car lista) (elem (- x 1) ( cdr lista ) ) )

)

(define (text-wh text font fontsize)
(let*
    (
        (text-width 1)
        (text-height 1)
    )
 
    (set! text-width (car (gimp-text-get-extents-fontname text fontsize PIXELS font)))    
    (set! text-height (elem 2  (gimp-text-get-extents-fontname text fontsize PIXELS font)))    
    
    (list text-width text-height)
    )
)

;(text-width "alma" "Sans" 100)

(define (script-fu-bhax-chrome-border text font fontsize width height new-width color gradient border-size)
(let*
    (
        (text-width (car (text-wh text font fontsize)))
        (text-height (elem 2 (text-wh text font fontsize)))
        (image (car (gimp-image-new width (+ height (/ text-height 2)) 0)))
        (layer (car (gimp-layer-new image width (+ height (/ text-height 2)) RGB-IMAGE "bg" 100 LAYER-MODE-NORMAL-LEGACY)))
        (textfs)
        (layer2) 
    )
        
    (gimp-image-insert-layer image layer 0 0)
        
    (gimp-image-select-rectangle image CHANNEL-OP-ADD 0 (/ text-height 2) width height)
    (gimp-context-set-foreground '(255 255 255))
    (gimp-drawable-edit-fill layer FILL-FOREGROUND )
    
    (gimp-image-select-rectangle image CHANNEL-OP-REPLACE border-size (+ (/ text-height 2) border-size) (- width (* border-size 2)) (- height (* border-size 2)))
    (gimp-context-set-foreground '(0 0 0))
    (gimp-drawable-edit-fill layer FILL-FOREGROUND )
    
    (gimp-image-select-rectangle image CHANNEL-OP-REPLACE (* border-size 3) 0 text-width text-height)
    (gimp-drawable-edit-fill layer FILL-FOREGROUND )    
    
    (gimp-selection-none image)
    
    ;step 1
    (gimp-context-set-foreground '(255 255 255))
   
    (set! textfs (car (gimp-text-layer-new image text font fontsize PIXELS)))
    (gimp-image-insert-layer image textfs 0 0)   
    (gimp-layer-set-offsets textfs (* border-size 3) 0)
   
    (set! layer (car(gimp-image-merge-down image textfs CLIP-TO-BOTTOM-LAYER)))
   
    ;step 2   
    (plug-in-gauss-iir RUN-INTERACTIVE image layer 25 TRUE TRUE)
   
    ;step 3
    (gimp-drawable-levels layer HISTOGRAM-VALUE .18 .38 TRUE 1 0 1 TRUE)
   
    ;step 4   
    (plug-in-gauss-iir RUN-INTERACTIVE image layer 2 TRUE TRUE)

    ;step 5    
    (gimp-image-select-color image CHANNEL-OP-REPLACE layer '(0 0 0))
    (gimp-selection-invert image)

    ;step 6        
    (set! layer2 (car (gimp-layer-new image width (+ height (/ text-height 2)) RGB-IMAGE "2" 100 LAYER-MODE-NORMAL-LEGACY)))
    (gimp-image-insert-layer image layer2 0 0)

    ;step 7        
	(gimp-context-set-gradient gradient) 
	(gimp-edit-blend layer2 BLEND-CUSTOM LAYER-MODE-NORMAL-LEGACY GRADIENT-LINEAR 100 0 REPEAT-NONE 
        FALSE TRUE 5 .1 TRUE width 0 width (+ height (/ text-height 2)))
    
    ;step 8        
    (plug-in-bump-map RUN-NONINTERACTIVE image layer2 layer 120 25 7 5 5 0 0 TRUE FALSE 2)
   
    ;step 9       
    (gimp-curves-spline layer2 HISTOGRAM-VALUE 8 (color-curve))
            
    (gimp-image-scale image new-width (/ (* new-width (+ height (/ text-height 2))) width))
      
    (gimp-display-new image)
    (gimp-image-clean-all image)
    )
)

;(script-fu-bhax-chrome-border "Bátf41 Haxor Stream" "Sans" 160 1920 1080 400 '(255 0 0) "Crown molding" 7)
;(script-fu-bhax-chrome-border "Programozás" "Sans" 110 768 576 300 '(255 0 0) "Crown molding" 6)


(script-fu-register "script-fu-bhax-chrome-border"
    "Chrome3-Border2"
    "Creates a chrome effect on a given text."
    "Norbert Bátfai"
    "Copyright 2019, Norbert Bátfai"
    "January 19, 2019"
    ""
    SF-STRING       "Text"      "Bátf41 Haxor"
    SF-FONT         "Font"      "Sans"
    SF-ADJUSTMENT   "Font size" '(160 1 1000 1 10 0 1)
    SF-VALUE        "Width"     "1920"
    SF-VALUE        "Height"    "1080"
    SF-VALUE        "New width" "400"
    SF-COLOR        "Color"     '(255 0 0)
    SF-GRADIENT     "Gradient"  "Crown molding"    
    SF-VALUE        "Border size"   "7"    
)
(script-fu-menu-register "script-fu-bhax-chrome-border" 
    "<Image>/File/Create/BHAX"
)
