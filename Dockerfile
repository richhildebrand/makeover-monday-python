FROM jupyter/tensorflow-notebook

USER root

RUN apt-get update -y && \
    apt-get install -y build-essential && \
    apt-get install -y libstdc++6 && \
    apt-get install -y zlib1g-dev

# ===========================================================================
# JUPYTER NOTEBOOK EXTENSIONS
# ===========================================================================

# define the jupyter directories explicitly to make them user-independent
ENV JUPYTER_CONFIG_DIR /jupyter/.jupyter
ENV JUPYTER_DATA_DIR /jupyter/.local/share/jupyter
ENV JUPYTER_RUNTIME_DIR /jupyter/.local/share/jupyter/runtime

# make sure the directories exist
RUN mkdir -p $JUPYTER_CONFIG_DIR
RUN mkdir -p $JUPYTER_DATA_DIR
RUN mkdir -p $JUPYTER_RUNTIME_DIR

# install a collection of extensions
RUN pip install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master && \
    jupyter contrib nbextension install --system

# install the vim binding extension
RUN mkdir -p $(jupyter --data-dir)/nbextensions && cd $(jupyter --data-dir)/nbextensions && \
    git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding

# jupyter nbextension configurator
RUN pip install jupyter_nbextensions_configurator
RUN jupyter nbextensions_configurator enable

# make sure all jupyter config and data files are accessible by all users
RUN chmod -R 777 /jupyter

USER jovyan

RUN pip install xgboost && \
    pip install shap && \
    pip install sklearn-pandas && \
    pip install pandas -U \