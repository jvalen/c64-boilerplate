; load sid music

* = address_music                  ; address to load the music data
!bin "res/yourtune.sid",, $7c+2    ; remove header from sid and cut off
                                   ; original loading address
