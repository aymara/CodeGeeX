# This script is for evaluating the functional correctness of the generated codes of HumanEval-X.

INPUT_FILE=$1  # Path to the .jsonl file that contains the generated codes.
LANGUAGE=$2  # Target programming language, currently support one of ["python", "java", "cpp", "js", "go"]
N_WORKERS=$3  # Number of parallel workers.
TIMEOUT=$4  # Timeout in seconds.

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
MAIN_DIR=$(dirname "$SCRIPT_DIR")
TMP_DIR="${TMP_DIR:=/tmp}"
echo "$INPUT_FILE"

if [ -z "$N_WORKERS" ]
then
    N_WORKERS=64
fi

if [ -z "$LANGUAGE" ]
then
    LANGUAGE=python
fi

if [ -z "$TIMEOUT" ]
then
    TIMEOUT=5
fi

DATA_DIR=$MAIN_DIR/codegeex/benchmark/humaneval-x/$LANGUAGE/data
DATA_FILE=$DATA_DIR/humaneval_$LANGUAGE.jsonl.gz

if [ $LANGUAGE = go ]; then
  export PATH=$PATH:/usr/local/go/bin
fi

if [ $LANGUAGE = cpp ]; then
  export PATH=$PATH:/usr/bin/openssl
fi

CMD="python $MAIN_DIR/codegeex/benchmark/humaneval-x/evaluate_humaneval_x.py \
    --input-file "$INPUT_FILE" \
    --n-workers $N_WORKERS \
    --tmp-dir $TMP_DIR \
    --problem-file $DATA_FILE \
    --timeout $TIMEOUT \
    --drop-prompt"  # To remove prompt from hypothesis if present

echo "$CMD"
eval "$CMD"
