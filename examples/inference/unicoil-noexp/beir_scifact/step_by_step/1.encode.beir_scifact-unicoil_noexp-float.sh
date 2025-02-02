export SPRINT_HOME=../../../../  # Path to the repo, please change it accordingly
export PYTHONPATH=$SPRINT_HOME:"${PYTHONPATH}"

export stage=encode

export encoder_name='unicoil'
export encoder_ckpt_name='unicoil_noexp'  # Here we use noexp model (i.e. no document expansion), since the documents are not expanded
export data_name='beir_scifact'  # beir data can be downloaded automatically
export quantization=float  # The current encoding stage will output the original float weights without quantization

export ckpt_name='castorini/unicoil-noexp-msmarco-passage'
export long_idenitifer=$data_name-$encoder_ckpt_name-$quantization

export output_dir=$long_idenitifer/collection
export log_name=$stage.$long_idenitifer.log
export gpus="10 11"  # GPU IDs, separated by blank ' '

nohup python -m inference.$stage \
    --encoder_name $encoder_name \
    --ckpt_name  $ckpt_name \
    --data_name $data_name \
    --gpus $gpus \
    --output_dir $output_dir \
    > $log_name &