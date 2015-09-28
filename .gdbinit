set history save
handle SIG38 noprint
set follow-fork-mode child

python
#sys.path.insert(0, '/home/phulin/.gdb_printers/4.8.2-ubuntu')
#from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end

#------------------------------------------------------------------------------#
# Utils
#------------------------------------------------------------------------------#

define setup-color-pipe
    shell rm -f ./.gdb-color-pipe
    set logging redirect on
    set logging on ./.gdb-color-pipe
end

define cleanup-color-pipe
    set logging off
    set logging redirect off
    shell rm -f ./.gdb-color-pipe
end

document cleanup-color-pipe
    Disables command redirection and removes the color pipe file.
    Syntax: cleanup-color-pipe
end


define do-generic-colors
    # 1. Function names and the class they belong to
    # 2. Function argument names
    # 3. Stack frame number
    # 4. Thread id colorization
    # 5. File path and line number
    shell cat ./.gdb-color-pipe | \
        sed -r "s_([^<])(\b([a-zA-Z0-9_]+::)?[a-zA-Z0-9_\.@]+)( ?)\(_\1$(tput setaf 6)$(tput bold)\2$(tput sgr0)\4(_g" | \
        sed -r "s_([a-zA-Z0-9_#]*)=_$(tput setaf 2)$(tput bold)\1$(tput sgr0)=_g" | \
        sed -r "s_^(#[0-9]*)_$(tput setaf 1)$(tput bold)\1$(tput sgr0)_" | \
        sed -r "s_^([ \*]) ([0-9]+)_$(tput bold)$(tput setaf 6)\1 $(tput setaf 1)\2$(tput sgr0)_" | \
        sed -r "s_(\.*[/A-Za-z0-9\+_\.\-]*):([0-9]+)\$_$(tput setaf 4)\1$(tput sgr0):$(tput setaf 3)\2$(tput sgr0)_"
end

#------------------------------------------------------------------------------#
# Prompt
#------------------------------------------------------------------------------#

# \todo I believe this has a tendency to bork the prompt
#set prompt \033[0;34m(gdb) \033[0;00m


#------------------------------------------------------------------------------#
# backtrace
#------------------------------------------------------------------------------#

define hook-backtrace
    setup-color-pipe
end

define hookpost-backtrace
    do-generic-colors
    cleanup-color-pipe
end


#------------------------------------------------------------------------------#
# up
#------------------------------------------------------------------------------#

define hook-up
    setup-color-pipe
end

define hookpost-up
    do-generic-colors
    cleanup-color-pipe
end


#------------------------------------------------------------------------------#
# down
#------------------------------------------------------------------------------#

define hook-down
    setup-color-pipe
end

define hookpost-down
    do-generic-colors
    cleanup-color-pipe
end


#------------------------------------------------------------------------------#
# frame
#------------------------------------------------------------------------------#

define hook-frame
    setup-color-pipe
end

define hookpost-frame
    do-generic-colors
    cleanup-color-pipe
end


#------------------------------------------------------------------------------#
# info threads
#------------------------------------------------------------------------------#

define info hook-threads
    setup-color-pipe
end

define info hookpost-threads
    do-generic-colors
    cleanup-color-pipe
end


#------------------------------------------------------------------------------#
# thread
#------------------------------------------------------------------------------#

define hook-thread
    setup-color-pipe
end

define hookpost-thread
    do-generic-colors
    cleanup-color-pipe
end
