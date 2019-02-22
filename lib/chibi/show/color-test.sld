(define-library (chibi show color-test)
  (import (scheme base) (chibi show) (chibi show color) (chibi test))
  (export run-tests)
  (begin
    (define (run-tests)
      (test-begin "(chibi show color)")

      ;; Confirm only one attribute setting and one reset when done
      ;; when nesting with the same attribute value
      (test "\x1b;[33mfoomoreso\x1b;[0m"
            (show #f (as-yellow "foo" (as-yellow "moreso"))))
      (test "\x1b;[4mfoomoreso\x1b;[24m"
            (show #f (as-underline "foo" (as-underline "moreso"))))
      (test "\x1b;[1mfoomoreso\x1b;[0m"
            (show #f (as-bold "foo" (as-bold "moreso"))))

      (test "\x1b;[31mred\n\x1b;[1mred and bold\n\x1b;[4mred bold underline\n\x1b;[34mswitched to blue with a little \x1b;[35mmagenta\x1b;[34m in between\n\x1b;[31m\x1b;[24mback to red and bold\n\x1b;[0m\x1b;[31mjust red\n\x1b;[0mnormal\n"
            (show #f
                  (as-red "red" nl
                          (as-bold "red and bold" nl
                                   (as-underline "red bold underline" nl
                                                 (as-blue "switched to blue with a little " (as-magenta "magenta") " in between" nl))
                                   "back to red and bold" nl)
                          "just red" nl)
                  "normal" nl))

      (test "normal\n\x1b;[4munderlined\n\x1b;[32mgreen underlined\n\x1b;[1mgreen underlined bold\n\x1b;[0m\x1b;[32m\x1b;[4mback to green underlined\n\x1b;[0m\x1b;[4mback to underlined\n\x1b;[24mback to normal\n"
            (show #f
                  "normal" nl
                  (as-underline "underlined" nl
                                (as-green "green underlined" nl
                                          (as-bold "green underlined bold" nl)
                                          "back to green underlined" nl)
                                "back to underlined" nl)
                  "back to normal" nl))

      (test-end)
      )
    )
  )
