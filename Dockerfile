ARG BUILDER_BASE_IMAGE=quay.io/jupyter/pytorch-notebook:cuda12-python-3.11.8
FROM $BUILDER_BASE_IMAGE as builder


# ================================================================================
# Linux applications and libraries
# ================================================================================

# USER root
#
# RUN apt-get update \
#  && apt-get install --yes --quiet --no-install-recommends \
#     build-essential \
#  && apt-get clean \
#  && rm -rf /var/lib/apt/lists/*


# ================================================================================
# Install all needed Python Packages
# ================================================================================


USER ${NB_UID}

# WORKDIR /app
# ENV VIRTUAL_ENV=/app/.venv
# RUN python3 -m venv $VIRTUAL_ENV
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"


WORKDIR /tmp/

# Install from the requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.in .
RUN pip install --no-cache-dir --requirement requirements.in  \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"


# USER ${NB_UID}

# RUN mamba install --quiet --yes \
#     'numpy' \
#     'pandas' \
#     'scipy' \
#     'seaborn' \
#     'scikit-learn' \
#     'toml' \
#     'pytest' \
#  && mamba clean --all -f -y \
#  && fix-permissions "${CONDA_DIR}" \
#  && fix-permissions "/home/${NB_USER}"

# ================================================================================
# Setup the user
# ================================================================================

USER ${NB_UID}
WORKDIR "${HOME}"

COPY --chown=${NB_UID}:${NB_GID} notebook ./
