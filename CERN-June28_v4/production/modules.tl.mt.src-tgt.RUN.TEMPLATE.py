# -*- coding: utf-8 -*-
#
#  Copyright 2013,2014 transLectures-UPV Team
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
SRC="${TEMPLATE_SRC}" # FILL
TRG="${TEMPLATE_TGT}" # FILL
LABEL="${TEMPLATE_RUN}" # FILL
ID="%s-%s_%s" % (SRC, TRG, LABEL) # Required by the Ingest Service 

TRANSLATE_SCRIPT="/home/ttpuser/git/ttp-scripts/ml/mt/docker-wrapper-nmt-fairseq.sh"
DOCKER_IMG="mllp.upv.es:5000/mt-${TEMPLATE_SRC}-${TEMPLATE_TGT}:${TEMPLATE_RUN}.v${TEMPLATE_VERSION}"

def translate(jbs, l_in_txt_fp, l_out_txt_fp, tmp_dir, html=False, log_file=None, job_name=None, hold_job_ids=[]):
    jids=[]
    if log_file == None:
        log_file = "%s/translate.log" % tmp_dir 
    cmd = "%s %s %s %s" % (TRANSLATE_SCRIPT, DOCKER_IMG, l_in_txt_fp, l_out_txt_fp)
    res_tra = jbs.submit_job(cmd, mem=8.0, other_opts="-gmem 3G", time="4:00:00", output=log_file, job_name=job_name, hold_jid=hold_job_ids)
    if res_tra['code'] != 0:
        return res_tra
    jids.append(res_tra['jid'])

    return {'code':0, 'jids':jids, 'cmd':cmd, 'log':log_file}

