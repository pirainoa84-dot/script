#!/bin/bash

SESSION="k8s"

MASTER_HOST=${MASTER_HOST:-"master-host"}
WORKER1_HOST=${WORKER1_HOST:-"worker1-host"}
WORKER2_HOST=${WORKER2_HOST:-"worker2-host"}

tmux new-session -d -s $SESSION
tmux rename-window -t $SESSION "cluster"

tmux send-keys -t $SESSION:0.0 \
"ssh $MASTER_HOST 'virsh -c qemu:///system start MasterPLane-k8s-rhel9.6'" C-m

tmux split-window -v -t $SESSION:0.0
tmux send-keys -t $SESSION:0.1 "ssh $MASTER_HOST" C-m

tmux select-pane -t $SESSION:0.0
tmux split-window -h -t $SESSION:0.0

tmux send-keys -t $SESSION:0.2 \
"ssh $WORKER1_HOST 'virsh -c qemu:///system start worker1-k8s-rhel9.6-clone' && \
ssh $WORKER2_HOST 'virsh -c qemu:///system start worker2-k8s-rhel9.6-clone'" C-m

tmux select-layout -t $SESSION main-vertical
tmux select-pane -t 0 -T "MASTER-START"
tmux select-pane -t 1 -T "MASTER-SHELL"
tmux select-pane -t 2 -T "WORKERS"

tmux attach -t $SESSION
