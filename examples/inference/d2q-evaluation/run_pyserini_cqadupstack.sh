for dataset in english gaming gis mathematica physics programmers stats tex unix webmasters wordpress
do
    export data_path="/store2/scratch/n3thakur/beir-datasets/cqadupstack/${dataset}"
    export d2q_filepath="/store2/scratch/n3thakur/beir-datasets/cqadupstack/${dataset}/top20-gen-queries.jsonl"
    export output_path="/store2/scratch/n3thakur/beir-datasets-d2q/cqadupstack/${dataset}"
    export output_results_path="/store2/scratch/n3thakur/sparse-retrieval-results/d2q-bm25-multifield/cqadupstack/${dataset}"
    export split="test"
    
    python preprocessing.py \
        --dataset_dir ${data_path} \
        --output_path ${output_path} \
        --d2q_filepath ${d2q_filepath}

    python -m pyserini.index -collection JsonCollection -generator DefaultLuceneDocumentGenerator \
        -threads 1 -input ${output_path} \
        -index ${output_results_path}/indexes/lucene-index-d2q-${dataset} -storePositions -storeDocvectors -storeRaw -fields title

    python -m pyserini.search.lucene \
              --index ${output_results_path}/indexes/lucene-index-d2q-${dataset} \
              --topics beir-v1.0.0-cqadupstack-${dataset}-test \
              --output ${output_results_path}/runs/run.beir-v1.0.0-d2q-${dataset}-multifield.trec \
              --output-format trec \
              --batch 36 --threads 12 \
              --fields contents=1.0 title=1.0 \
              --remove-query --hits 1001
    
    mkdir ${output_results_path}/eval/
    python -m pyserini.eval.trec_eval -c -m ndcg_cut.10 -m recall.100,1000 beir-v1.0.0-cqadupstack-${dataset}-test ${output_results_path}/runs/run.beir-v1.0.0-d2q-${dataset}-multifield.trec >> ${output_results_path}/eval/results.txt
done