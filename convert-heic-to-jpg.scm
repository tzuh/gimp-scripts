;; Get the base filename without extension
(define (get-filename filepath)
  (let* ((basename (car (last (strbreakup filepath DIR-SEPARATOR))))
         (filename (substring basename 0 (- (string-length basename) 5))))
  filename)
)

(define (script-fu-convert-heic-to-jpg source-folder dest-folder jpg-quality)
  (let* ((filelist (cadr (file-glob (string-append source-folder DIR-SEPARATOR "*.heic") 1))))
    (begin
      (for-each 
        (lambda (filepath)
          (let* ((filename (get-filename filepath))
                 (image (car (gimp-file-load RUN-NONINTERACTIVE filepath filepath)))  ; Load the image
                 (drawable (car (gimp-image-get-active-layer image)))  ; Get the active layer
                 (jpg-path (string-append dest-folder DIR-SEPARATOR filename ".jpg"))
                )
            ;; Save the image as JPG format
            (file-jpeg-save RUN-NONINTERACTIVE
                            image drawable
                            jpg-path jpg-path
                            jpg-quality  ; Compression quality, range from 0.0 to 1.0
                            0 1 0 " " 0 1 0 1
            )
            ;; Delete the image from memory
            (gimp-image-delete image)
          )
        )
      filelist)
    )
  )
)

(script-fu-register
 "script-fu-convert-heic-to-jpg"                      ; Function name
 "Convert HEIC to JPG"                                ; Menu label
 "Converts all HEIC files in a folder to JPG format"  ; Description
 ""                                                   ; Author
 ""                                                   ; Copyright holder
 "2024"                                               ; Date
 ""
 SF-DIRNAME "Source Folder" ""
 SF-DIRNAME "Destination Folder" ""
 SF-ADJUSTMENT "JPG Quality" '(0.9 0.0 1.0 0.01 0.1 2 1))

(script-fu-menu-register "script-fu-convert-heic-to-jpg" "<Image>/File/Convert")
