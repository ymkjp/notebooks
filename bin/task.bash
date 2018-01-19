#!/usr/bin/env bash

#PBS -j oe -l select=1 -M s1510756@jaist.ac.jp -m e
cd $PBS_O_WORKDIR

conda create --yes --prefix $HOME/py27 python=2.7
source activate $HOME/py27

APP_DIR="$HOME/hpcc"
LOG_DIR="logs"
TARGET_DATA="vcc_data.npz"
#TARGET_DATA="vcc_data_40x800.npz"

[[ -d "${LOG_DIR}" ]] || mkdir ${LOG_DIR}

TASK_ID="$(date +%s)"
TASK_OUTPUT="${HOME}/logs/figure_${TASK_ID}.png"

cat ${APP_DIR}/message.txt \
  && echo '' > ${APP_DIR}/message.txt \
  && pip install -qr ${APP_DIR}/requirements.txt \
  && time python ${APP_DIR}/vcc-combine.py -f ${TARGET_DATA} -o 1 -i "${TASK_ID}" \
  && sh ${HOME}/bin/clean.sh

if [[ -f "${TASK_OUTPUT}" ]]; then
  ${HOME}/pushbullet-bash/pushbullet push all "${TASK_OUTPUT}" "Task #${TASK_ID} completed"
else
  ${HOME}/pushbullet-bash/pushbullet push all note "History-based Vulnerability Detector" "Task #${TASK_ID} completed"
fi