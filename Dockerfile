# Use an official Clojure image with OpenJDK 11 as a base
FROM clojure:openjdk-11

# Switch to root user to install system packages
USER root

# Install required system packages: git, curl, python3, and pip3
RUN apt-get update && \
    apt-get install -y git curl python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter Notebook using pip
RUN pip3 install notebook

# Install Leiningen (needed to build Cljupyter)
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/local/bin/ && \
    lein --version

# Clone Cljupyter and build its uberjar
RUN git clone https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
    cd /opt/clojupyter && \
    lein uberjar

# Set the working directory to /home/jovyan (Binder expects notebooks here)
WORKDIR /home/jovyan

# (Optional) Copy your deps.edn if your project needs it
COPY deps.edn /home/jovyan/deps.edn

# Expose the default Jupyter Notebook port
EXPOSE 8888

# Set the default command to launch Jupyter Notebook.
# Binder will use this command to start your container.
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
