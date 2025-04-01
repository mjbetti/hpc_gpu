# hpc_gpu
A short tutorial on running interactive Jupyter notebooks on an HPC's GPU node.

## Introduction
When using a GPU on a local machine or personal server, the device is readily available for interactive sessions. On an HPC, however, the process of requesting a GPU for running interactive Jupyter notebook sessions is less straightforward. This is a tutorial of how to open a Jupyter notebook in an interactive GPU session on an HPC using SLURM.

## Tutorial
1. First, an Anaconda environment with Jupyter and all other Python packages you plan on using (i.e. PyTorch) should be installed. A .yml file included in this repository, ```torch-gpu.yml```, can be used to create an environment that includes Jupyter, PyTorch, and scikit-learn, among other packages. The environment can be built using the following command:
```
conda env create -f torch-gpu.yml
```

2. Next, a SLURM batch submission script should be written. An example script, called ```jupyterLab.sh```, is included in this repository:
```
#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --account=accre_guests_acc
#SBATCH --partition=pascal
#SBATCH --gres=gpu:2
#SBATCH --time=5-00:00:00
#SBATCH --mem=48GB
#SBATCH --output=/home/bettimj/gamazon_rotation/deep_learning_tcga_lc/jupyter.log

source activate /home/bettimj/miniconda3/envs/torch-gpu

cat /etc/hosts
jupyter lab --ip=0.0.0.0 --port=8889
```
In this script, two GPUs on NVIDIA's ```pascal``` architecture are being requested through the ```accre_guests_acc``` account. This job will utilize ```48GB``` of memory and run for a total of 5 days. It will be running on port ```8889```. Typically, either ```8888``` or ```8889``` are commonly used.

3. This script can be submitted to the queue using the following command:
```
sbatch jupyterLab.sh
```

4. Once the job has started running, first find the name of the GPU to which the job has been allocated using ```squeue --user username```. Let's say, for example, that our job is running on ```gpu0042```.

5. Open the log file ```jupyter.log``` and locate the IP address of the GPU (in the lefthand column). For example, for ```gpu0042```, we may see the following line in our log file:
```
10.0.29.8       gpu0042 gpu0042.vampire
```

6. Open a new terminal window on your local machine (not logged in to the HPC). Enter the following command to link your GPU job on the HPC to a port on your local machine:
```
ssh -L8889:10.0.29.8:8889 username@your.hpc.url
```

7. Scroll to the bottom of the ```jupyter.log``` log file, where you should see a command similar to the following:
```
    To access the server, open this file in a browser:
        file:///panfs/accrepfs.vampire/home/bettimj/.local/share/jupyter/runtime/jpserver-19946-open.html
    Or copy and paste one of these URLs:
        http://gpu0030.vampire:8889/lab?token=0aa21fa026cda3a3f04af694d259c11b2d3d3b3fad9806b1
        http://127.0.0.1:8889/lab?token=0aa21fa026cda3a3f04af694d259c11b2d3d3b3fad9806b1
```

Paste the URL into a local web browser, and you should now be able to access the Jupyter notebook running on your HPC's GPU node.