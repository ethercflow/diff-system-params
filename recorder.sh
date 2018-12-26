#!/usr/bin/env bash

opt_disks=0; disks=

function usage {
    cat <<-END >&2
    USAGE: recorder [-h] [-d disks]
                     -d                   # disk list
                     -h                   # this usage message

    eg,
           recorder -d sda,sdb,nvme0n1    # record block, mount parameters
END
}

function record {
    rm -rf sys-params

    dirty_ratio=`cat /proc/sys/vm/dirty_ratio` && echo "/proc/sys/vm/dirty_ratio=$dirty_ratio" >> sys-params
    dirty_background_ratio=`cat /proc/sys/vm/dirty_background_ratio` && echo "/proc/sys/vm/dirty_background_ratio=$dirty_background_ratio" >> sys-params
    overcommit_memory=`cat /proc/sys/vm/overcommit_memory` && echo "/proc/sys/vm/overcommit_memory=$overcommit_memory" >> sys-params
    overcommit_ratio=`cat /proc/sys/vm/overcommit_ratio` && echo "/proc/sys/vm/overcommit_ratio=$overcommit_ratio" >> sys-params
    max_map_count=`cat /proc/sys/vm/max_map_count` && echo "/proc/sys/vm/max_map_count=$max_map_count" >> sys-params
    min_free_kbytes=`cat /proc/sys/vm/min_free_kbytes` && echo "/proc/sys/vm/min_free_kbytes=$min_free_kbytes" >> sys-params
    panic_on_oom=`cat /proc/sys/vm/panic_on_oom` && echo "/proc/sys/vm/panic_on_oom=$panic_on_oom" >> sys-params
    swappiness=`cat /proc/sys/vm/swappiness` && echo "/proc/sys/vm/swappiness=$swappiness" >> sys-params
    aio_max_nr=`cat /proc/sys/fs/aio-max-nr` && echo "/proc/sys/fs/aio-max-nr=$aio_max_nr" >> sys-params
    file_max=`cat /proc/sys/fs/file-max` && echo "/proc/sys/fs/file-max=$file_max" >> sys-params
    msgmax=`cat /proc/sys/kernel/msgmax` && echo "/proc/sys/kernel/msgmax=$msgmax" >> sys-params
    msgmnb=`cat /proc/sys/kernel/msgmnb` && echo "/proc/sys/kernel/msgmnb=$msgmnb" >> sys-params
    msgmni=`cat /proc/sys/kernel/msgmni` && echo "/proc/sys/kernel/msgmni=$msgmni" >> sys-params
    shmall=`cat /proc/sys/kernel/shmall` && echo "/proc/sys/kernel/shmall=$shmall" >> sys-params
    shmmax=`cat /proc/sys/kernel/shmmax` && echo "/proc/sys/kernel/shmmax=$shmmax" >> sys-params
    shmmni=`cat /proc/sys/kernel/shmmni` && echo "/proc/sys/kernel/shmmni=$shmmni" >> sys-params
    threads_max=`cat /proc/sys/kernel/threads-max` && echo "/proc/sys/kernel/threads-max=$threads_max" >> sys-params

    if (( opt_disks )); then
        IFS=,
        arr=($disks)
        for i in "${arr[@]}"
        do
            add_random=`cat /sys/block/${arr[$i]}/queue/add_random` && echo "/sys/block/${arr[$i]}/queue/add_random=$add_random" >> sys-params
            iostats=`cat /sys/block/${arr[$i]}/queue/iostats` && echo "/sys/block/${arr[$i]}/queue/iostats=$iostats" >> sys-params
            max_sectors_kb=`cat /sys/block/${arr[$i]}/queue/max_sectors_kb` && echo "/sys/block/${arr[$i]}/queue/max_sectors_kb=$max_sectors_kb" >> sys-params
            nomerges=`cat /sys/block/${arr[$i]}/queue/nomerges` && echo "/sys/block/${arr[$i]}/queue/nomerges=$nomerges" >> sys-params
            nr_requests=`cat /sys/block/${arr[$i]}/queue/nr_requests` && echo "/sys/block/${arr[$i]}/queue/nr_requests=$nr_requests" >>  sys-params
            optimal_io_size=`cat /sys/block/${arr[$i]}/queue/optimal_io_size` && echo "/sys/block/${arr[$i]}/queue/optimal_io_size=$optimal_io_size" >> sys-params
            read_ahead_kb=`cat /sys/block/${arr[$i]}/queue/read_ahead_kb` && echo "/sys/block/${arr[$i]}/queue/read_ahead_kb=$read_ahead_kb" >> sys-params
            rotational=`cat /sys/block/${arr[$i]}/queue/rotational` && echo "/sys/block/${arr[$i]}/queue/rotational=$rotational" >> sys-params
            rq_affinity=`cat /sys/block/${arr[$i]}/queue/rq_affinity` && echo "/sys/block/${arr[$i]}/queue/rq_affinity=$rq_affinity" >> sys-params
            scheduler=`cat /sys/block/${arr[$i]}/queue/scheduler` && echo "/sys/block/${arr[$i]}/queue/scheduler=$scheduler" >> sys-params
            mounts=`cat /proc/mounts | grep ${arr[$i]}` && echo $mounts >> sys-params
        done
    fi
}

while getopts h:d: opt
do
    case $opt in
    d) opt_disks=1; disks=$OPTARG ;;
    h|?) usage ;;
    esac
done

record
