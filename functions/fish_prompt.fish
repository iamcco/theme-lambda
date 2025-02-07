function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (uname -n|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
        set -g __fish_prompt_char '#'
      case '*'
        set -g __fish_prompt_char 'λ'
    end
  end

  # Setup colors
  set -l hostcolor (set_color (uname -n | md5 -r | cut -f1 -d' ' | tr -d '\n' | tail -c6))
  if [ $THEME = "dark" ]
      set -g normal (set_color normal)
      set -g white (set_color FFFFFF)
      set -g turquoise (set_color 5fdfff)
      set -g orange (set_color df5f00)
      set -g hotpink (set_color df005f)
      set -g blue (set_color blue)
      set -g limegreen (set_color 87ff00)
      set -g purple (set_color af5fff)
  else
      set -g normal (set_color normal)
      set -g white (set_color 544d40)
      set -g turquoise (set_color 147baa)
      set -g orange (set_color df5f00)
      set -g hotpink (set_color df005f)
      set -g blue (set_color blue)
      set -g limegreen (set_color 477c0b)
      set -g purple (set_color af5fff)

  end

  # Configure __fish_git_prompt
  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_color 147baa
  set -g __fish_git_prompt_color_flags df5f00
  set -g __fish_git_prompt_color_prefix white
  set -g __fish_git_prompt_color_suffix white
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showstashstate true
  set -g __fish_git_prompt_show_informative_status true

  set -l current_user (whoami)

  ##
  ## Line 1
  ##
  echo -n $hostcolor'╭─'$hotpink$current_user$white' at '$orange$__fish_prompt_hostname$white' in '$limegreen(pwd|sed "s=$HOME=⌁=")$turquoise
  __fish_git_prompt " (%s)"
  echo

  ##
  ## Line 2
  ##
  echo -n $hostcolor'╰'

  # Disable virtualenv's default prompt
  set -g VIRTUAL_ENV_DISABLE_PROMPT true

  # support for virtual env name
  if set -q VIRTUAL_ENV
    echo -n "($turquoise"(basename "$VIRTUAL_ENV")"$white)"
  end

  ##
  ## Support for vi mode
  ##
  set -l lambdaViMode "$THEME_LAMBDA_VI_MODE"

  # Do nothing if not in vi mode
  if test "$fish_key_bindings" = fish_vi_key_bindings
      or test "$fish_key_bindings" = fish_hybrid_key_bindings
    if test -z (string match -ri '^no|false|0$' $lambdaViMode)
      set_color --bold
      echo -n $white'─['
      switch $fish_bind_mode
        case default
          set_color red
          echo -n 'n'
        case insert
          if [ $THEME = "dark" ]
              set_color green
          else
              set_color 477c0b
          end;
          echo -n 'i'
        case replace_one
          if [ $THEME = "dark" ]
              set_color green
          else
              set_color 477c0b
          end;
          echo -n 'r'
        case replace
          set_color cyan
          echo -n 'r'
        case visual
          set_color magenta
          echo -n 'v'
      end
      echo -n $white']'
    end
  end

  ##
  ## Rest of the prompt
  ##
  echo -n $hostcolor'─'$white$__fish_prompt_char $normal
end

