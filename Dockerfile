FROM jupyter/tensorflow-notebook

USER root

RUN apt-get update -y && \
    apt-get install -y build-essential && \
    apt-get install -y libstdc++6 && \
    apt-get install -y zlib1g-dev


# Start Juypter Notebook Extensions
ENV JUPYTER_CONFIG_DIR /jupyter/.jupyter
ENV JUPYTER_DATA_DIR /jupyter/.local/share/jupyter
ENV JUPYTER_RUNTIME_DIR /jupyter/.local/share/jupyter/runtime

RUN mkdir -p $JUPYTER_CONFIG_DIR
RUN mkdir -p $JUPYTER_DATA_DIR
RUN mkdir -p $JUPYTER_RUNTIME_DIR

RUN pip install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master && \
    jupyter contrib nbextension install --system

RUN mkdir -p $(jupyter --data-dir)/nbextensions && cd $(jupyter --data-dir)/nbextensions && \
    git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding

RUN pip install jupyter_nbextensions_configurator
RUN jupyter nbextensions_configurator enable

RUN chmod -R 777 /jupyter
# End Juypter Notebook Extensions


# Allow PDF backend
RUN mkdir -p /jupyter/.config/matplotlib
RUN echo "backend : pgf" > /jupyter/.config/matplotlib/matplotlibrc


#USER jovyan

# Intall TinyTex
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh
RUN apt-get update && apt-get -y install dvipng


RUN pip install xgboost && \
    pip install shap && \
    pip install sklearn-pandas && \
    pip install pandas -U \