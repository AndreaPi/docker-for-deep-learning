# Docker for Deep Learning

The purpose of this repo is:
 - to introduce Docker as a useful tool developing Deep Learning models, and to show how [Portainer](https://www.portainer.io/) or [Depend on Docker](https://github.com/datasailors/depend-on-docker) {DoD} simplify Docker usage ([slides](https://github.com/AndreaPi/docker-training-2019-public/blob/master/Docker_basics_public.pdf))
 - to illustrate the use of DoD with a simple exercise, where you will run an image classification model ([Keras ResNet-50 example](https://github.com/AndreaPi/docker-training-2019-public/blob/master/notebooks/keras_resnet50_example.ipynb)) and an object detection model ([Keras RetinaNet example](https://github.com/AndreaPi/docker-training-2019-public/blob/master/notebooks/keras_resnet50_example.ipynb)).

**Warning**: before attempting the exercise, you should get familiar with Depend on Docker. At least, you need to know that you can build an image, run a container, check its status and stop it with these four scripts:

##### Build

    ./build.sh 

Builds the Docker container image and tags it using the registry and version tag settings specified in your environment file

##### Run

    ./run.sh [command] 

Creates a Docker container and, if no argument is specified, opens a Jupyter notebook. If a command line is specified as an argument to the run script, this command line is executed in the container in place of the default command (starting Jupyter, in this case).

##### Status

    ./status.sh 

This script shows the current status of the Docker container including any mapped ports.

##### Stop

    ./stop.sh 

Stops the container and cleans up its files.

The scripts rely on shell variables defined in the `.env` file.

### Exercise

 1. Clone this repository
 2. `cd` to the repository, and try to build the Docker image with the `build.sh` script. What error do you get? Which file should you modify in order to fix the error?
 3. After fixing the first error, try building again. Depending on whether you're behind a firewall or not, you may need to edit the same file again.
 4. Now launch the container with `run.sh`, open a browser and go to http://localhost:5555. You should see the Jupyter server dashboard.
 5. Navigate to `workdir/notebooks`, execute the [Keras ResNet-50 example](https://github.com/AndreaPi/docker-training-2019-public/blob/master/notebooks/keras_resnet50_example.ipynb) and the [Keras RetinaNet example](https://github.com/AndreaPi/docker-training-2019-public/blob/master/notebooks/keras_resnet50_example.ipynb)
 6. Go back to the terminal, check the status of the container with `status.sh` and check that it's still running. Close the Jupyter notebook (log out and halt).
 7. What happened to the list of container (hint: check the docs for `docker ps`)? What should you change to make sure that the container’s file system is cleaned on exit? Instead than modifying a file, you can obtain the same effect running `stop.sh`.

 That's it! You're now a Docker Pro! Well....maybe a Docker Duckling 😉 Note how easy it was to make inference with the ResNet-50 model on your pc! Usually, each time you want to run the same model on a different machine, we would have to:

 - configure proxies (if behind a corporate proxy)
 - install conda and create a conda env, or install Python and create a virtual environment with venv  or pipenv
 - (possibly) configure paths
 - install Tensorflow, Keras, Pillow, opencv-python, h5py, numpy, jupyter in the venv/conda env

Even more packages would have to be installed if we also wanted to _train_ a ResNet-50 model. Instead, we packaged all the necessary dependencies into our image. **Running the Jupyter notebook** becomes very simple: `./run.sh` will get you your own Jupyter Notebook server! After that, simply point your browser to http://localhost:5555 et voilà! Your model is running. 


### NOTE: dowloading weights
The Keras ResNet-50  and the Keras RetinaNet examples download model weights from the Internet at runtime. Since Docker containers are **stateless**, this means that each time the notebook is run, weights are downloaded again. This can be a pain on slow Internet connections. To avoid that, rename `Dockerfile.download.weights` to `Dockerfile` before building the Docker image. This will make Docker download all model weights just once at build time. Then, each time the Docker container is run, weights don't need to be downloaded anymore. 

### GPU
Both examples run pretty fast on a modern laptop CPU, but if you have a GPU and you'd like to use it, just rename `Dockerfile.GPU` to `Dockerfile` and then run `build.sh`. You'll have a GPU-powered Docker image!