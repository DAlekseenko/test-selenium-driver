FROM ubuntu:xenial

RUN apt-get update; apt-get clean

# Install xvfb.
RUN apt-get install -y xvfb curl unzip wget

ADD xvfb.init /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb && \
    update-rc.d xvfb defaults

ENV CHROMEDRIVER_VERSION 2.37

# Install Chrome WebDriver
RUN mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chrome.
RUN apt-get update && apt-get -y install google-chrome-stable

# Install NodeJS.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash && \
    apt-get install -y nodejs

RUN npm install -g testable-openfin-cli

ENV DISPLAY :10
ENV CHROMEDRIVER_PORT 9515
ENV CHROMEDRIVER_WHITELISTED_IPS ""

EXPOSE $CHROMEDRIVER_PORT

CMD (service xvfb start; export DISPLAY=$DISPLAY)
