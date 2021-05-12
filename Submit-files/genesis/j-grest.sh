#PBS -N job_5xpl
#PBS -q q0002
#PBS -l select=36

cd $PBS_O_WORKDIR
export PATH=/home/g0002/u0005/gREST-test-20180720/genesis-1.3.0/bin:$PATH

export OMP_NUM_THREADS=5

time aprun -n 288 -d 5 -N 8 -S 4 -j 1 -cc depth spdyn ${file}.inp | tee ${file}.out
