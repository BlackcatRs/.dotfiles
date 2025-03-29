#!/usr/bin/env bash

VIEW() {

    _BIGGEST=-1
    _TOKEEP=""

    echo "Analysing New Group"

    # Find the biggest in the group
    for f in "${@}";do
        size=$(du -b "${f}" | cut -f1)
        echo "${f}: size in bytes: $size"
        if [ ${size} -gt ${_BIGGEST} ]; then
            _BIGGEST="$size"
            _TOKEEP="$f"
        fi
    done

    # Rename any file that is not the one to keep
    for f in "${@}";do 
        if [ "${f}" != "${_TOKEEP}" ]; then
            mv "${f}" "${f}.TODELETE"
            echo "Image to delete ${f}"
        else
            echo "Image to preserve: ${f}"
        fi
    done 
}
