# Use an official Clojure image as the base
FROM clojure:openjdk-11-lein

# Install any system dependencies needed (if any)
RUN apt-get update && apt-get install -y \
    # add any extra packages here if needed
    && rm -rf /var/lib/apt/lists/*

# Clone clojupyter and install it
RUN git clone https://github.com/clojupyter/clojupyter.git /opt/clojupyter && \
    cd /opt/clojupyter && \
    lein uberjar

# Set the working directory for Jupyter
WORKDIR /home/jovyan

# Copy your deps.edn if needed
COPY deps.edn /home/jovyan/deps.edn

# Expose the port (if required by your setup)
EXPOSE 8888

# Set an entrypoint if needed; for now, simply run bash (Binder will take care of launching Jupyter)
CMD ["bash"]
