The process of putting into a production an NMT system consists in the following steps:
    - Create a docker image which encapsulates the whole inference process carried out by the model
    - Push the docker image to the docker registry
    - Create a tlp module for the MT system, commit and push it to the tlp-modules repo. You should then update the repo on the tlp machine
    - Edit the Postgres database on the tlp machine and add the newly created system

The scripts held inside this folder aim to automate the whole process, with some caveats.
- If you have never done it, you need to login into the docker registry: docker login mllp.upv.es:5000
- It is expected that you run this from a folder that contains a complete training of a system based on nmt_scripts. (i.e. you need a working config.sh and so on)
- The scripts should always be run one level above the production folder, that is, from the nmt_scripts root( i.e. jiranzo@sangonera:~/trabajo/git/nmt-scripts$ ./production/step01_prepare_templates.sh)
- By default, an image is created and tagged with the "v1" suffix. If you need to do some changes to this image in the future, it is reccomended that you instead increment the version counter and re-run the whole process. There might be conflicts in you try to give it the same tag.
- The scripts have been created for the latest nmt_scripts recipe at the time of writing. If you want to use then for your own custom system, you will need to edit translate-fairseq-docker scripts, and you could also need to edit other files to get it working with your system. Be very careful with this step.

If you have setup everything corretly, you should do as follows:

production/step01_prepare_templates.sh
production/step02_prepare_system_for_production_to_scratchTranslectures_and_mtsystems_prod.sh
production/step03_dockerize.sh

Current tlp machine: valor.cc.upv.es

Those 3 scripts take care of copying the system to /scratch/translectures, setting up the docker image and pushing it to the repo. You will now need to manually do the following:
- Commit the generated tlp modules file (modules.tl...) to the tlp-modules repo. (https://mllp.upv.es/git/jsilvestre/tlp-modules.git), mt/ folder.
- Login into the tlp-machine (Ideally in a new ssh session)
- (tlp-machine) Do a git pull at /home/ttpuser/git/tlp-modules
- (tlp-machine) Access the postgress db: docker exec -it ttp_postgres_1 psql ttp -U ttpuser
    * Obtain the system id (OLD_ID) from the old system (Omit this step if no previous systems exists)
- run production/step04_get_production_commands.sh <BLEU_OF_YOUR_NEW_SYSTEM> <OLD_ID>
    * This script is going to provide you with a series of commands to run inside the tlp-machine

