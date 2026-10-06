#!/bin/bash

LIBDIR="/p/pshare/transp/opt/pspline/2.0.1/gcc/13.2.0/lib"

for lib in "$LIBDIR"/*.so; do

    base=$(basename "$lib")

    echo
    echo "============================================================"
    echo "$base"
    echo "============================================================"

    symbols=$(
        ldd -r "$lib" 2>&1 |
        sed -n 's/.*undefined symbol: \([^[:space:]]*\).*/\1/p'
    )

    if [ -z "$symbols" ]; then
        echo "CLEAN"
        continue
    fi

    for sym in $symbols; do

        provider=""

        for candidate in "$LIBDIR"/*.so; do

            [ "$candidate" = "$lib" ] && continue

            if nm -D --defined-only "$candidate" 2>/dev/null |
               awk '{print $3}' |
               grep -qx "$sym"; then

                provider=$(basename "$candidate")
                break
            fi
        done

        if [ -n "$provider" ]; then
            printf "%-35s -> %s\n" "$sym" "$provider"
        else
            printf "%-35s -> EXTERNAL/NOT FOUND\n" "$sym"
        fi
    done

done
